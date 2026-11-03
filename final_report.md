# LLMOps Assignment 2 — Final Report
**EduAssist AI: API Cost, Latency, and Prompt Version Management**

Provider: Groq (OpenAI-compatible API) · Model: `openai/gpt-oss-20b` · Pricing date: 2026-11-03 (USD) · Input $0.075 / 1M tokens · Output $0.30 / 1M tokens · Experiment: `eduassist_llmops_assignment`

## 1. LLMOps versus MLOps

MLOps manages datasets, feature pipelines, training, deployment, and monitoring of trained models. LLMOps extends that lifecycle to applications that call large language models through APIs. Prompts, model or API versions, retrieved context, and output guardrails can change independently and each change can affect quality, cost, and latency. In this assignment, prompts were treated as versioned production artifacts in MLflow, latency and token economics were measured, and the best prompt was promoted with a `production` alias instead of informal edits.

## 2. Task 1 — Latency

Five academic questions were answered with Prompt v1. Each call logged question ID, prompt version, model name, start time, end time, latency, and status. Across the evaluation runs, average latency was about **1.17 s for v1**, and about **3.3 s for v2/v3**. The slower requests are most plausibly explained by longer generated outputs and occasional API or network queueing on Groq, not local notebook overhead. For an undergraduate Q&A assistant, few-second responses are acceptable if they stay predictable under load.

## 3. Task 2 — Tokens and Cost

Token counts came from each API response. Cost used published Groq rates:

Input cost = input tokens / 1,000,000 × $0.075  
Output cost = output tokens / 1,000,000 × $0.30  
Total cost = input + output  
Monthly projection = average cost per request × 10,000  

Average cost per request ranged roughly **$0.00009–$0.00023**. At 10,000 monthly requests that is about **$0.89–$2.28 / month** at published rates. The main optimization recommendation is to **cap `max_tokens` for short factual questions** and **route simple queries to a smaller model**, because output tokens dominate spend.

## 4. Task 3 — Evaluation and promotion

Three prompts were registered as `eduassist_prompt`: **v1** basic, **v2** structured academic role, and **v3** strict JSON with `answer`, `confidence`, and `key_points`. Metrics logged per version were `avg_latency_seconds`, `avg_input_tokens`, `avg_output_tokens`, `avg_cost_per_request`, and for v3 `valid_json`.

| Prompt | Avg Latency (s) | Avg In | Avg Out | Avg Cost (USD) | Valid JSON | Recommended? |
|--------|----------------:|-------:|--------:|---------------:|-----------:|--------------|
| v1 | 1.166 | 93.8 | 738.0 | 0.00022843 | N/A | No |
| v2 | 3.302 | 115.8 | 520.4 | 0.00016480 | N/A | No |
| v3 | 3.388 | 149.8 | 259.4 | 0.00008905 | **1.0** | **Yes** |

v1 was fastest but produced long free text (highest output tokens and cost). v2 improved tone but stayed unstructured. **v3** achieved a **100% valid JSON rate**, shorter outputs, and the **lowest average cost**, so it was promoted to **`eduassist_prompt@production`**.

## 5. Promotion justification

Prompt **v3** is the production choice for EduAssist because quality depends on reliable integration, not only fluent prose. The JSON contract enables confidence-based escalation and key-point extraction without brittle parsing. Validity was perfect on the five-question set (`valid_json = 1.0`). Although latency is higher than v1 (~3.4 s vs ~1.2 s), it remains acceptable for academic assistance, and structured answers used fewer output tokens, cutting average request cost. Versioning with commit messages, diffs, metrics, and a `production` alias follows LLMOps practice: the app can load `prompts:/eduassist_prompt@production` and roll back without code changes if quality regresses.

## 6. Conclusion

This assignment completed an LLMOps loop: measure latency, price tokens, version prompts, evaluate objectively, and promote with an environment alias. **Prompt v3** is the recommended production prompt for EduAssist AI.
