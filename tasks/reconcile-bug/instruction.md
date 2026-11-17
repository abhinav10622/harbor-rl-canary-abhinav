# Transaction Reconciliation

You are given a Python CLI program at `/app/reconcile.py` that processes a CSV file containing transaction records.

Your task is to debug and correct the program so that it produces an accurate JSON summary.

## Input

The input CSV contains the following columns:

- `tx_id`: Unique transaction identifier.
- `timestamp`: Transaction timestamp, including timezone information.
- `amount`: Transaction amount.
- `status`: Transaction status.

The program must accept the CSV file path as a command-line argument.

## Business Rules

1. A transaction is valid only when its status is SUCCESS. Status matching is case-insensitive, and surrounding whitespace should be ignored.
2. Transactions that are unsuccessful or invalid must be counted as failed.
3. If multiple records contain the same transaction ID, only the record with the latest timestamp should be considered.
4. Timestamps may contain different timezone offsets and must be compared correctly.
5. The program must handle empty files and malformed records without crashing.

## Output

The program must print a JSON object containing exactly these fields:

- `total_valid_amount`: Sum of the amounts of valid transactions.
- `valid_count`: Number of valid transactions.
- `failed_count`: Number of failed transactions.

The output must be valid JSON and must not contain additional explanatory text.

## Requirements

- Keep the program executable from the command line.
- Handle input and data errors gracefully.
- Preserve accurate transaction counts and totals.
- Do not change the required output field names.
