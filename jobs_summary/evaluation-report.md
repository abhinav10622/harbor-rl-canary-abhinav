# Harbor Evaluation Report

## 1. Local verifier validation

| Implementation | Reward |
|---|---:|
| Original broken program | 0/100 |
| Hardcoded hack | 70/100 |
| Correct solution | 100/100 |

## 2. Reward design

| Test | Weight |
|---|---:|
| CLI argument handling | 20 |
| Status filtering | 25 |
| Timezone-aware duplicate handling | 25 |
| Independent edge-case test | 30 |
| Total | 100 |

## 3. Agent evaluation status

A smoke test was attempted using:
- Agent: terminus-2
- Model: groq/openai/gpt-oss-120b
- Provider: Groq

The run failed with a TPM rate-limit error. The free-tier limit was 8,000 tokens per minute, and the provider rejected the agent requests.

No successful baseline or ablation trials were obtained. Therefore, no trial rewards or advantage values are reported.

## 4. Advantage calculation

For future successful trials, advantage is calculated as:

A_i = R_i - mean(R_group)

Binary reward: 1 for complete success, otherwise 0.

Dense reward: weighted partial score from 0 to 100, normalized to 0–1 when calculating advantages.

## 5. Ablation status

A controlled ablation comparison remains pending because baseline agent trials did not complete.

## 6. Conclusion

The local task, solution, cheating implementation, and dense verifier were implemented and validated. Agent evaluation remains incomplete due to provider rate limits.
