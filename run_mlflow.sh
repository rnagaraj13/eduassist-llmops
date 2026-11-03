#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f .venv/bin/activate ]]; then
  echo "Missing .venv. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

# Prefer a fresh file store for class labs. If a previous run left a broken
# sqlite DB, remove it so `mlflow ui` can start cleanly.
if [[ -f mlflow.db ]]; then
  echo "==> Removing stale mlflow.db (avoids migration errors)"
  rm -f mlflow.db
fi

mkdir -p mlruns

echo "MLflow UI -> http://127.0.0.1:5000"
echo "Press Ctrl+C to stop."
exec mlflow ui --backend-store-uri ./mlruns --host 127.0.0.1 --port 5000
