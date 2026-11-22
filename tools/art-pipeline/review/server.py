#!/usr/bin/env python3
"""Local review server for generated art: browse, grade, annotate and rerun.

Run from the repo root:
    python3 tools/art-pipeline/review/server.py        # http://localhost:8686

Standard library only. State lives in tools/art-pipeline/out/:
  manifest.json  one entry per generated image (prompt, model, seed, size, time)
  reviews.json   grades, verdicts and notes
Reruns go in a queue and run one at a time (two models at once swap on 24 GB).
"""
import json
import os
import re
import shutil
import subprocess
import threading
import time
import uuid
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import urlparse, unquote

HERE = Path(__file__).resolve().parent
PIPE = HERE.parent
OUT = PIPE / "out"
MANIFEST = OUT / "manifest.json"
REVIEWS = OUT / "reviews.json"
PORT = int(os.environ.get("PORT", "8686"))
HOME = Path.home()
os.environ["PATH"] = f"{HOME}/.local/bin:/opt/homebrew/bin:" + os.environ.get("PATH", "")

MODELS = {
    "zimage": {
        "label": "Z-Image Turbo (Apache 2.0)",
        "cmd": ["mflux-generate-z-image-turbo", "--quantize", "4", "--low-ram", "--steps", "9"],
    },
    "flux": {
        "label": "FLUX.1 schnell 4-bit (Apache 2.0)",
        "cmd": ["mflux-generate", "--model", "dhairyashil/FLUX.1-schnell-mflux-4bit",
                "--base-model", "schnell", "--low-ram", "--steps", "4"],
    },
}

lock = threading.Lock()
jobs = []  # dicts: id, status, params, started, finished, error, output


def read_json(path, default):
    try:
        return json.loads(path.read_text())
    except Exception:
        return default


def write_json(path, data):
    tmp = path.with_suffix(".tmp")
    tmp.write_text(json.dumps(data, indent=2, ensure_ascii=False))
    tmp.replace(path)


def prompt_vars():
    """Parse NAME="..." assignments from prompts.sh."""
    text = (PIPE / "prompts.sh").read_text()
    return dict(re.findall(r'^([A-Z0-9_]+)="(.*?)"\s*$', text, re.M | re.S))


def backfill():
    """Add manifest entries for images generated before the review tool existed."""
    manifest = read_json(MANIFEST, {})
    v = prompt_vars()
    known = {
        "nemo-zit-1868.png": ("NEMO", "zimage", 1868, 768, 1024, 25 * 60, "q8, 9 steps; time includes the model download"),
        "salon-zit-1868.png": ("SALON", "zimage", 1868, 1280, 720, 891, "q8, 9 steps; memory swapping"),
        "nemo2-zit-1868.png": ("NEMO2", "zimage", 1868, 576, 768, 915, "q8, 9 steps; memory swapping"),
        "nemo2-zit-2024.png": ("NEMO2", "zimage", 2024, 576, 768, 781, "q8, 9 steps; memory swapping"),
        "nemo2-flux-1868.png": ("NEMO2", "flux", 1868, 576, 768, 96, "4-bit, 4 steps, low-ram"),
        "salon-flux-1868.png": ("SALON", "flux", 1868, 960, 540, 107, "4-bit, 4 steps, low-ram"),
    }
    changed = False
    for name, (subj, model, seed, w, h, secs, note) in known.items():
        if name in manifest or not (OUT / name).exists():
            continue
        manifest[name] = {
            "subject": subj, "model": model, "seed": seed, "width": w, "height": h,
            "prompt": v.get(subj, ""), "style": v.get("STYLE", ""), "seconds": secs,
            "note": note, "created": (OUT / name).stat().st_mtime, "parent": None,
        }
        changed = True
    if changed:
        write_json(MANIFEST, manifest)


def pixel_versions(name):
    stem = name[:-4]
    return sorted(p.name for p in OUT.glob(stem + "-px*.png") if not re.search(r"-x\d+\.png$", p.name))


def pixelize(name, w, h):
    size, strength, scale = ("144x192", "0.35", "4") if h > w else ("320x180", "0.5", "3")
    uv = shutil.which("uv") or str(HOME / ".local/bin/uv")
    subprocess.run([uv, "run", str(PIPE / "pixelize.py"), str(OUT / name), "--size", size,
                    "--colors", "32", "--dither", "bayer", "--strength", strength,
                    "--preview-scale", scale], cwd=PIPE, capture_output=True)


def other_generation_running():
    r = subprocess.run(["pgrep", "-f", "mflux-generate"], capture_output=True, text=True)
    return bool(r.stdout.strip())


def worker():
    while True:
        job = None
        with lock:
            job = next((j for j in jobs if j["status"] == "queued"), None)
            if job:
                job["status"] = "waiting"
        if not job:
            time.sleep(1)
            continue
        while other_generation_running():  # e.g. a run started from the terminal
            time.sleep(5)
        p = job["params"]
        name = f'{p["subject"].lower()}-{p["model"]}-{p["seed"]}-{job["id"][:4]}.png'
        log = OUT / f"gen-{job['id'][:8]}.log"
        cmd = MODELS[p["model"]]["cmd"] + [
            "--width", str(p["width"]), "--height", str(p["height"]), "--seed", str(p["seed"]),
            "--prompt", f'{p["prompt"]}, {p["style"]}'.strip(", "), "--output", str(OUT / name)]
        with lock:
            job.update(status="running", started=time.time(), output=name, log=log.name)
        with open(log, "w") as fh:
            rc = subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT, cwd=PIPE).returncode
        secs = round(time.time() - job["started"])
        if rc == 0 and (OUT / name).exists():
            pixelize(name, p["width"], p["height"])
            with lock:
                manifest = read_json(MANIFEST, {})
                manifest[name] = {**p, "seconds": secs, "created": time.time(),
                                  "note": "rerun from review tool"}
                write_json(MANIFEST, manifest)
                job.update(status="done", finished=time.time(), seconds=secs)
        else:
            tail = log.read_text()[-600:] if log.exists() else ""
            with lock:
                job.update(status="failed", finished=time.time(), error=tail)


def progress(job):
    if job.get("status") != "running" or not job.get("log"):
        return None
    try:
        tail = (OUT / job["log"]).read_text()[-400:].replace("\r", "\n")
        m = re.findall(r"(\d+)%\|.*?\|\s*(\d+)/(\d+)", tail)
        return f"{m[-1][1]}/{m[-1][2]} steps" if m else "loading model"
    except Exception:
        return None


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=str(PIPE), **kw)

    def log_message(self, *a):
        pass

    def send_json(self, data, code=200):
        body = json.dumps(data, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urlparse(self.path).path
        if path in ("/", "/index.html"):
            self.path = "/review/review.html"
            return super().do_GET()
        if path == "/api/state":
            manifest = read_json(MANIFEST, {})
            images = []
            for name, meta in manifest.items():
                if (OUT / name).exists():
                    images.append({"name": name, **meta, "pixel": pixel_versions(name)})
            images.sort(key=lambda x: x.get("created") or 0, reverse=True)
            with lock:
                js = [{**j, "progress": progress(j)} for j in jobs[-30:]]
            v = prompt_vars()
            return self.send_json({
                "images": images, "reviews": read_json(REVIEWS, {}), "jobs": js,
                "models": {k: m["label"] for k, m in MODELS.items()},
                "subjects": {k: val for k, val in v.items() if k != "STYLE"},
                "style": v.get("STYLE", ""),
            })
        if path.startswith("/out/"):
            self.path = "/out/" + unquote(path[5:])
            return super().do_GET()
        self.send_error(404)

    def do_POST(self):
        path = urlparse(self.path).path
        length = int(self.headers.get("Content-Length", 0))
        data = json.loads(self.rfile.read(length) or b"{}")
        if path == "/api/review":
            name = data.get("name")
            if not name or not (OUT / name).exists():
                return self.send_json({"error": "unknown image"}, 400)
            with lock:
                reviews = read_json(REVIEWS, {})
                r = reviews.get(name, {})
                for k in ("grade", "verdict", "notes", "checks"):
                    if k in data:
                        r[k] = data[k]
                r["updated"] = time.time()
                reviews[name] = r
                write_json(REVIEWS, reviews)
            return self.send_json({"ok": True})
        if path == "/api/rerun":
            model = data.get("model")
            if model not in MODELS:
                return self.send_json({"error": "unknown model"}, 400)
            try:
                w, h = int(data["width"]), int(data["height"])
                count = max(1, min(4, int(data.get("count", 1))))
                seed = int(data.get("seed") or 0)
            except (KeyError, ValueError):
                return self.send_json({"error": "bad size, seed or count"}, 400)
            if not (256 <= w <= 1536 and 256 <= h <= 1536):
                return self.send_json({"error": "size must be 256–1536"}, 400)
            subject = re.sub(r"[^A-Za-z0-9]", "", data.get("subject") or "CUSTOM")[:16] or "CUSTOM"
            created = []
            with lock:
                for i in range(count):
                    s = seed + i if seed else int.from_bytes(os.urandom(2), "big")
                    job = {"id": uuid.uuid4().hex, "status": "queued", "params": {
                        "subject": subject, "model": model, "seed": s, "width": w, "height": h,
                        "prompt": data.get("prompt", ""), "style": data.get("style", ""),
                        "parent": data.get("parent")}}
                    jobs.append(job)
                    created.append(job["id"])
            return self.send_json({"ok": True, "jobs": created})
        if path == "/api/cancel":
            with lock:
                for j in jobs:
                    if j["id"] == data.get("id") and j["status"] == "queued":
                        j["status"] = "cancelled"
            return self.send_json({"ok": True})
        self.send_error(404)


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    backfill()
    threading.Thread(target=worker, daemon=True).start()
    print(f"Art review on http://localhost:{PORT}  (Ctrl+C to stop)")
    ThreadingHTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
