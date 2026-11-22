#!/usr/bin/env python3
"""Queue images from locations.json on the local review server (one job each).

    python3 tools/art-pipeline/queue.py                 # everything
    python3 tools/art-pipeline/queue.py ch05_salon ...  # only these ids
    python3 tools/art-pipeline/queue.py --seed 7 --model zimage ch04_cell
"""
import argparse
import json
import re
import urllib.request
from pathlib import Path

HERE = Path(__file__).resolve().parent


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("ids", nargs="*")
    ap.add_argument("--seed", type=int, default=1868)
    ap.add_argument("--model", default="flux")
    ap.add_argument("--count", type=int, default=1)
    ap.add_argument("--server", default="http://localhost:8686")
    args = ap.parse_args()

    spec = json.loads((HERE / "locations.json").read_text())
    styles = dict(re.findall(r'^([A-Z0-9_]+)="(.*?)"\s*$', (HERE / "prompts.sh").read_text(), re.M | re.S))
    style = styles[spec["style"]]
    for item_id, item in spec["items"].items():
        if args.ids and item_id not in args.ids:
            continue
        w, h = spec["sizes"][item["kind"]]
        body = {"model": args.model, "subject": item_id.upper().replace("_", "")[:16], "seed": args.seed,
                "count": args.count, "width": w, "height": h, "prompt": item["prompt"], "style": style}
        req = urllib.request.Request(args.server + "/api/rerun", json.dumps(body).encode(),
                                     {"Content-Type": "application/json"})
        res = json.loads(urllib.request.urlopen(req).read())
        print(item_id, "queued" if res.get("ok") else res)


if __name__ == "__main__":
    main()
