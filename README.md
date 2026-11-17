# RL Environment and Agent Evaluation in Harbor

## Project: Transaction Reconciliation

A debugging environment built to evaluate an AI agent's ability to identify and fix bugs in a Python transaction reconciliation CLI using Harbor.

## Task Overview

The agent must repair a Python program that reads transaction CSV files and produces a JSON summary.

The task contains three intentional bugs:

1. Command-line argument handling.
2. Transaction status filtering.
3. Duplicate transaction handling using timezone-aware timestamps.

## Environment

- Harbor
- Python 3.12
- Docker
- Bash
- Terminus-2 agent
- Groq API provider (smoke test attempted)

## Dense Reward Design

The verifier uses four checks with weighted partial rewards:

| Check | Weight |
|---|---:|
| CLI argument handling | 20 |
| Status filtering | 25 |
| Timezone-aware duplicate handling | 25 |
| Independent edge-case test | 30 |
| **Total** | **100** |

## Local Verifier Results

| Implementation | Score |
|---|---:|
| Original broken program | 0/100 |
| Hardcoded cheating implementation | 70/100 |
| Correct solution | 100/100 |

The cheating implementation passes the first three predictable checks but fails the independent edge-case test. This demonstrates the importance of verifier diversity.

## Harbor Agent Evaluation

A Groq smoke test was attempted using `terminus-2` and `openai/gpt-oss-120b`.

The run did not complete because the provider returned a tokens-per-minute rate-limit error. No successful baseline or ablation trial results are claimed.

## Reinforcement Learning Concepts

### 1. Binary vs Dense Rewards
A binary reward gives only success or failure. A dense reward provides partial credit for individual requirements, helping distinguish partial progress from complete failure.

### 2. Advantage
Advantage measures how much better an outcome is than the average outcome in its comparison group:

`A = R - mean(R_group)`

### 3. Ablation
An ablation study changes or removes one component while keeping other conditions consistent, allowing its effect to be evaluated.

### 4. Reward Hacking
Reward hacking occurs when an agent exploits weaknesses in the reward function instead of genuinely completing the intended task. Independent tests help reduce this risk.

## Demo Video

Loom URL: TO BE ADDED
