# Start local MLflow UI (leave this terminal open)
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$activate = Join-Path $PSScriptRoot ".venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    Write-Error "Missing .venv. Run .\setup.ps1 first."
}
. $activate

Write-Host "MLflow UI -> http://127.0.0.1:5000" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop."
mlflow ui --host 127.0.0.1 --port 5000
