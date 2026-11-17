#!/bin/bash
set -e

cat > /app/reconcile.py <<'PYTHON'
import csv
import json
import sys
from datetime import datetime


def reconcile(file_path):
    latest = {}

    with open(file_path, "r", newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        for row in reader:
            try:
                tx_id = row["tx_id"].strip()
                timestamp = datetime.fromisoformat(row["timestamp"].strip())
                amount = float(row["amount"])
                status = row["status"].strip().upper()

                if not tx_id or not timestamp.tzinfo:
                    continue

                timestamp_utc = timestamp.timestamp()

                if tx_id not in latest or timestamp_utc > latest[tx_id][0]:
                    latest[tx_id] = (
                        timestamp_utc,
                        amount,
                        status
                    )
            except (KeyError, ValueError, TypeError):
                continue

    total_valid_amount = 0.0
    valid_count = 0
    failed_count = 0

    for _, amount, status in latest.values():
        if status == "SUCCESS":
            total_valid_amount += amount
            valid_count += 1
        else:
            failed_count += 1

    return {
        "total_valid_amount": round(total_valid_amount, 2),
        "valid_count": valid_count,
        "failed_count": failed_count
    }


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(json.dumps({"error": "Usage: reconcile.py <csv_file>"}))
        sys.exit(1)

    try:
        print(json.dumps(reconcile(sys.argv[1])))
    except (OSError, csv.Error):
        print(json.dumps({"error": "Unable to process CSV file"}))
        sys.exit(1)
PYTHON

chmod +x /app/reconcile.py
