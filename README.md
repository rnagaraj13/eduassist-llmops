# LLMOps Assignment 2 — EduAssist AI
**API Cost, Latency, and Prompt Version Management**  
Course: MLOps | Marks: 10 | Mode: Individual

---

## Environment

| Item | Value |
|---|---|
| Python | 3.10 or higher |
| OpenAI model | `gpt-4o-mini` |
| MLflow | ≥ 2.14.0 (Prompt Registry required) |
| Pricing date | 2024-07-01 (USD) |
| Pricing — input | $0.150 / 1M tokens |
| Pricing — output | $0.600 / 1M tokens |

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
| `OPENAI_API_KEY` | Your OpenAI API key — **never hard-code this** |

Set it before running the notebook:

```bash
export OPENAI_API_KEY="sk-..."
```

Or create a `.env` file in this directory:

```
OPENAI_API_KEY=sk-...
```

---

## Installation

```bash
# 1. Clone / unzip the submission
cd llmops_assignment

# 2. (Optional) create a virtual environment
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Set your API key
export OPENAI_API_KEY="sk-..."
```

---

## MLflow UI

Start the local MLflow tracking server **before** running the notebook:

```bash
mlflow ui --host 127.0.0.1 --port 5000
```

Open your browser at: **http://127.0.0.1:5000**

---

## Steps to Reproduce the Experiment

1. Start the MLflow UI (command above).
2. Open `LLMOps_Assignment.ipynb` in JupyterLab or VS Code.
3. Run all cells in order from top to bottom (*Kernel → Restart & Run All*).
4. The notebook will:
   - Make 5 API calls for Task 1 and collect latency data.
   - Compute token counts and costs for Task 2.
   - Register prompt versions `v1`, `v2`, `v3` in the MLflow Prompt Registry.
   - Run all 3 prompts on all 5 questions (15 API calls total).
   - Log metrics (`avg_latency_seconds`, `avg_input_tokens`, `avg_output_tokens`,
     `avg_cost_per_request`, `valid_json`) to the `eduassist_llmops_assignment`
     MLflow experiment.
   - Compare prompt versions and promote the best one to the `production` alias.
   - Save `latency_tokens_cost.csv` and `prompt_evaluation_results.csv`.
5. Take screenshots of the MLflow UI as listed below.

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
- Pricing information is attributed to the OpenAI pricing page, model `gpt-4o-mini`, retrieved 2024-07-01 (USD).
- If OpenAI API access is unavailable, substitute a locally-hosted open-source model (e.g. `ollama run mistral`), document the alternative clearly in the notebook, and estimate costs using the model's tokenizer and published hosting rates.
