# Start local MLflow UI (leave this terminal open)
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$activate = Join-Path $PSScriptRoot ".venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    Write-Error "Missing .venv. Run .\setup.ps1 first."
}
. $activate

if (Test-Path "mlflow.db") {
    Write-Host "==> Removing stale mlflow.db (avoids migration errors)" -ForegroundColor Yellow
    Remove-Item "mlflow.db" -Force
}

New-Item -ItemType Directory -Force -Path "mlruns" | Out-Null

Write-Host "MLflow UI -> http://127.0.0.1:5000" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop."
mlflow ui --backend-store-uri ./mlruns --host 127.0.0.1 --port 5000
