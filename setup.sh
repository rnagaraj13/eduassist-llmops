#!/usr/bin/env bash
# EduAssist LLMOps — one-shot Linux/macOS setup
# Usage:
#   chmod +x setup.sh run_mlflow.sh run_notebook.sh
#   ./setup.sh
#   ./setup.sh gsk_your_key_here

set -euo pipefail
cd "$(dirname "$0")"

echo "==> EduAssist LLMOps setup"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 not found. Install Python 3.10+ and retry." >&2
  exit 1
fi

echo "Python: $(python3 --version)"

if [[ ! -d .venv ]]; then
  echo "==> Creating .venv"
  python3 -m venv .venv
else
  echo "==> Reusing existing .venv"
fi

# shellcheck disable=SC1091
source .venv/bin/activate

echo "==> Installing requirements (+ jupyter)"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install jupyter

API_KEY="${1:-}"
if [[ -n "$API_KEY" ]]; then
  printf 'GROQ_API_KEY=%s\n' "$API_KEY" > .env
  echo "==> Wrote .env from CLI argument"
elif [[ ! -f .env ]]; then
  if [[ -f .env.example ]]; then
    cp .env.example .env
    echo "==> Created .env from .env.example — edit it and set GROQ_API_KEY"
  fi
fi

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if [[ -z "${GROQ_API_KEY:-}" || "$GROQ_API_KEY" == *your_key* ]]; then
  echo
  echo "GROQ_API_KEY is not set yet."
  echo "  1. Get a free key: https://console.groq.com/keys"
  echo "  2. Edit .env  OR  re-run:  ./setup.sh gsk_..."
else
  echo "==> GROQ_API_KEY detected"
fi

echo
echo "Setup complete. Next:"
echo "  Terminal 1:  ./run_mlflow.sh"
echo "  Terminal 2:  ./run_notebook.sh"
echo "Then: Kernel -> Restart & Run All in LLMOps_Assignment.ipynb"
