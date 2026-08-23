#!/usr/bin/env python3
"""Minimal fal.ai client using only the Python standard library (no deps).

Reads FAL_KEY from <repo>/.env or the FAL_KEY environment variable.

Usage:
  python fal.py check                 # verify key auth (no cost)
  python fal.py run <model> [body]    # synchronous run via https://fal.run
                                      # body = inline JSON or path to a .json file
"""
import json
import os
import sys
import urllib.error
import urllib.request

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def load_key():
    key = os.environ.get("FAL_KEY")
    if not key:
        env_path = os.path.join(REPO_ROOT, ".env")
        if os.path.exists(env_path):
            with open(env_path, "r", encoding="utf-8") as fh:
                for line in fh:
                    line = line.strip()
                    if line.startswith("FAL_KEY="):
                        key = line.split("=", 1)[1].strip().strip('"').strip("'")
                        break
    if not key:
        sys.exit("FAL_KEY not found. Set it in <repo>/.env or as an environment variable.")
    return key


def request(method, url, key, body=None):
    req = urllib.request.Request(url, method=method)
    req.add_header("Authorization", "Key " + key)
    req.add_header("Accept", "application/json")
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, data=data, timeout=180) as resp:
            return resp.status, resp.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", errors="replace")
    except urllib.error.URLError as e:
        return None, "network error: " + str(e.reason)


def cmd_check(key):
    # A GET to a queue endpoint authenticates the key; a valid key gets a
    # 4xx (method/body) response, an invalid one gets 401.
    status, raw = request("GET", "https://queue.fal.run/fal-ai/flux/schnell", key)
    print("HTTP " + str(status))
    if status == 401:
        sys.exit("FAL_KEY rejected (401 Unauthorized).")
    if status in (400, 404, 405):
        print("FAL_KEY accepted (key authenticated; endpoint expects POST).")
    elif status is None:
        sys.exit("Could not reach fal.ai: " + raw)
    else:
        print("Unexpected status; key appears accepted. Body: " + raw[:200])


def cmd_run(key, model, body):
    status, raw = request("POST", "https://fal.run/" + model, key, body)
    print("HTTP " + str(status))
    print(raw)


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return 1
    key = load_key()
    cmd = args[0]
    if cmd == "check":
        cmd_check(key)
    elif cmd == "run":
        if len(args) < 2:
            print("usage: python fal.py run <model> [body]")
            return 1
        model = args[1]
        body = {}
        if len(args) > 2:
            raw_arg = args[2]
            if os.path.exists(raw_arg):
                with open(raw_arg, "r", encoding="utf-8") as fh:
                    body = json.load(fh)
            else:
                body = json.loads(raw_arg)
        cmd_run(key, model, body)
    else:
        print(__doc__)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
