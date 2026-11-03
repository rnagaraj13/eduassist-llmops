#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f .venv/bin/activate ]]; then
  echo "Missing .venv. Run ./setup.sh first." >&2
  exit 1
fi

# shellcheck disable=SC1091
source .venv/bin/activate

# Newer MLflow requires a DB backend (file store is maintenance-mode).
# Drop a previous half-initialized DB so migrations start clean.
if [[ -f mlflow.db ]]; then
  echo "==> Removing stale mlflow.db (avoids migration errors)"
  rm -f mlflow.db mlflow.db-*
fi

echo "MLflow UI -> http://127.0.0.1:5000"
echo "Press Ctrl+C to stop."
exec mlflow ui --backend-store-uri sqlite:///mlflow.db --host 127.0.0.1 --port 5000
