#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f .venv/bin/activate ]]; then
  echo "Missing .venv. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if [[ -z "${GROQ_API_KEY:-}" || "$GROQ_API_KEY" == *your_key* ]]; then
  echo "GROQ_API_KEY missing. Edit .env or run: ./setup.sh gsk_..." >&2
  exit 1
fi

echo "GROQ_API_KEY loaded. Starting Jupyter..."
echo "Open LLMOps_Assignment.ipynb -> Kernel -> Restart & Run All"
exec jupyter notebook --ip=127.0.0.1 --no-browser
