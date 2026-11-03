#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f .venv/bin/activate ]]; then
  echo "Missing .venv. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

echo "MLflow UI -> http://127.0.0.1:5000"
echo "Press Ctrl+C to stop."
exec mlflow ui --host 127.0.0.1 --port 5000
