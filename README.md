# LLMOps Assignment 2 — EduAssist AI
**API Cost, Latency, and Prompt Version Management**  
Course: MLOps | Marks: 10 | Mode: Individual

---

## Environment

| Item | Value |
|---|---|
| Python | 3.10 or higher |
| Provider | Groq (OpenAI-compatible API) |
| Model | `openai/gpt-oss-20b` |
| MLflow | ≥ 2.14.0 (Prompt Registry required) |
| Pricing date | 2026-11-03 (USD) |
| Pricing — input | $0.075 / 1M tokens |
| Pricing — output | $0.30 / 1M tokens |

> Groq free-tier API key: https://console.groq.com/keys  
> Cost tables use Groq **published** on-demand rates for assignment economics.

---

## Required Libraries

```
openai>=1.0.0
mlflow>=2.14.0
pandas>=2.0.0
numpy>=1.24.0
python-dotenv>=1.0.0
```

---

## Environment Variables

| Variable | Description |
|---|---|
| `GROQ_API_KEY` | Your Groq API key — **never hard-code this** |

Set it before running the notebook:

```bash
export GROQ_API_KEY="gsk_..."
```

Or create a `.env` file in this directory:

```
GROQ_API_KEY=gsk_...
```

---

## Quick start (Windows lab) — automated

```powershell
git clone https://github.com/rnagaraj13/eduassist-llmops.git
cd eduassist-llmops

# One-time setup (venv + deps). Pass your Groq key:
.\setup.ps1 -ApiKey "gsk_..."

# Terminal 1 — leave open
.\run_mlflow.ps1

# Terminal 2
.\run_notebook.ps1
```

Then in the browser: open `LLMOps_Assignment.ipynb` → **Kernel → Restart & Run All**.

If PowerShell blocks scripts:
```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Or double-click `setup.bat`, then edit `.env` with your key and run the two scripts above.

---

## Manual install (any OS)

```bash
git clone https://github.com/rnagaraj13/eduassist-llmops.git
cd eduassist-llmops

python -m venv .venv
# Windows: .\.venv\Scripts\Activate.ps1
# macOS/Linux: source .venv/bin/activate

pip install -r requirements.txt
pip install jupyter

# copy .env.example -> .env and set GROQ_API_KEY
```

---

## MLflow UI

Automated: `.\run_mlflow.ps1`  
Manual:

```bash
mlflow ui --host 127.0.0.1 --port 5000
```

Open: **http://127.0.0.1:5000**

---

## Steps to Reproduce the Experiment

1. Create a free Groq key at https://console.groq.com/keys.
2. Run `.\setup.ps1 -ApiKey "gsk_..."` (Windows) or set `GROQ_API_KEY` / `.env`.
3. Start MLflow (`.\run_mlflow.ps1`), then Jupyter (`.\run_notebook.ps1`).
4. Open `LLMOps_Assignment.ipynb` → *Kernel → Restart & Run All*.
5. The notebook will:
   - Make 5 API calls for Task 1 and collect latency data.
   - Compute token counts and costs for Task 2.
   - Register prompt versions `v1`, `v2`, `v3` in the MLflow Prompt Registry.
   - Run all 3 prompts on all 5 questions (15 API calls total).
   - Log metrics (`avg_latency_seconds`, `avg_input_tokens`, `avg_output_tokens`,
     `avg_cost_per_request`, `valid_json`) to the `eduassist_llmops_assignment`
     MLflow experiment.
   - Compare prompt versions and promote the best one to the `production` alias.
   - Save `latency_tokens_cost.csv` and `prompt_evaluation_results.csv`.
6. Take screenshots of the MLflow UI as listed below.

---

## Output Files

| File | Contents |
|---|---|
| `LLMOps_Assignment.ipynb` | Main Jupyter notebook (all tasks) |
| `latency_tokens_cost.csv` | Task 1 & 2 — latency + token + cost data for 5 v1 calls |
| `prompt_evaluation_results.csv` | Task 3 — evaluation results for all 3 prompt versions × 5 questions |
| `requirements.txt` | Python dependency list |
| `README.md` | This file |

---

## Screenshots Required for Submission

1. **MLflow Experiments page** — `eduassist_llmops_assignment` with all runs listed.
2. **Run comparison view** — metrics side-by-side for `prompt_v1_eval`, `prompt_v2_eval`, `prompt_v3_eval`.
3. **Prompt Registry** — `eduassist_prompt` with versions v1, v2, v3 and their commit messages.
4. **Prompt diff / comparison** — selecting two versions and viewing the diff in the MLflow UI.
5. **Production alias** — `eduassist_prompt@production` pointing to the promoted version.

---

## Academic Integrity

- API keys are loaded from environment variables only; they are **never** committed to any file.
- Pricing information is attributed to the Groq pricing page, model `openai/gpt-oss-20b`, retrieved 2026-11-03 (USD).
- If Groq API access is unavailable, substitute a locally-hosted open-source model (e.g. `ollama run llama3.1`), document the alternative clearly in the notebook, and estimate costs using the model's tokenizer and published hosting rates.
