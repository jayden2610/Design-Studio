# fal.ai client (Tools/fal)

Minimal, dependency-free fal.ai client using Python stdlib (urllib).

## Setup

- Key lives in <repo>/.env as FAL_KEY=... (gitignored) or as the FAL_KEY
  environment variable.
- Run with any Python 3 (e.g. the workspace runtime:
  C:\Users\angdo\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe).

## Usage

    python Tools\fal\fal.py check
    python Tools\fal\fal.py run fal-ai/flux/schnell "{\"prompt\":\"minimalist monochrome bagel line art\"}"
    python Tools\fal\fal.py run fal-ai/flux/schnell body.json

- check verifies key authentication only (no generation, no cost).
- run posts to https://fal.run/<model> synchronously and prints the result
  JSON (costs credits per generation).
- Body can be inline JSON or a path to a .json file.

## Notes

- Auth header: Authorization: Key <FAL_KEY>.
- API docs: https://docs.fal.ai
- Need queue/webhook support or richer tooling later? Official SDKs:
  - Python: pip install fal-client
  - Node: npm i @fal-ai/client
