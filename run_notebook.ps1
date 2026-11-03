# Start Jupyter with GROQ_API_KEY loaded from .env
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$activate = Join-Path $PSScriptRoot ".venv\Scripts\Activate.ps1"
if (-not (Test-Path $activate)) {
    Write-Error "Missing .venv. Run .\setup.ps1 first."
}
. $activate

# Load .env into this session
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
    Write-Error "GROQ_API_KEY missing. Edit .env or run: .\setup.ps1 -ApiKey `"gsk_...`""
}

Write-Host "GROQ_API_KEY loaded. Starting Jupyter..." -ForegroundColor Green
Write-Host "Open LLMOps_Assignment.ipynb -> Kernel -> Restart & Run All"
jupyter notebook
