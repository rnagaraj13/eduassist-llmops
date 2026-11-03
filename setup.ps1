# EduAssist LLMOps — one-shot Windows setup
# Usage (PowerShell):
#   .\setup.ps1
# Optional:
#   .\setup.ps1 -ApiKey "gsk_..."

param(
    [string]$ApiKey = ""
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "==> EduAssist LLMOps setup" -ForegroundColor Cyan

# 1) Python check
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) {
    Write-Error "Python not found on PATH. Install Python 3.10+ and re-open PowerShell."
}

Write-Host "Python: $(python --version)"

# 2) Virtual environment
if (-not (Test-Path ".venv")) {
    Write-Host "==> Creating .venv"
    python -m venv .venv
} else {
    Write-Host "==> Reusing existing .venv"
}

$activate = Join-Path $PSScriptRoot ".venv\Scripts\Activate.ps1"
. $activate

# 3) Dependencies
Write-Host "==> Installing requirements (+ jupyter)"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pip install jupyter

# 4) .env / API key
if ($ApiKey) {
    Set-Content -Path ".env" -Value "GROQ_API_KEY=$ApiKey" -Encoding UTF8
    Write-Host "==> Wrote .env from -ApiKey"
} elseif (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "==> Created .env from .env.example — edit it and set GROQ_API_KEY" -ForegroundColor Yellow
    }
}

# Load .env into this session if present
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
        $name, $value = $_.Split("=", 2)
        if ($name -and $value) {
            [System.Environment]::SetEnvironmentVariable($name.Trim(), $value.Trim(), "Process")
        }
    }
}

if (-not $env:GROQ_API_KEY -or $env:GROQ_API_KEY -like "*your_key*") {
    Write-Host ""
    Write-Host "GROQ_API_KEY is not set yet." -ForegroundColor Yellow
    Write-Host "  1. Get a free key: https://console.groq.com/keys"
    Write-Host "  2. Edit .env  OR  re-run:  .\setup.ps1 -ApiKey `"gsk_...`""
} else {
    Write-Host "==> GROQ_API_KEY detected in environment" -ForegroundColor Green
}

Write-Host ""
Write-Host "Setup complete. Next:" -ForegroundColor Green
Write-Host "  Terminal 1:  .\run_mlflow.ps1"
Write-Host "  Terminal 2:  .\run_notebook.ps1"
Write-Host "Then: Kernel -> Restart & Run All in LLMOps_Assignment.ipynb"
