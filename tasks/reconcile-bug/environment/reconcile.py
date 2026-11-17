import csv
import json
import sys
from datetime import datetime


def reconcile(file_path):
    transactions = []

    with open(file_path, "r", newline="") as file:
        reader = csv.DictReader(file)
        for row in reader:
            transactions.append(row)

    latest = {}
    for row in transactions:
        tx_id = row["tx_id"]
        timestamp = row["timestamp"]

        if tx_id not in latest or timestamp > latest[tx_id]["timestamp"]:
            latest[tx_id] = row

    total_valid_amount = 0.0
    valid_count = 0
    failed_count = 0

    for row in latest.values():
        if row["status"] != "FAILED":
            total_valid_amount += float(row["amount"])
            valid_count += 1
        else:
            failed_count += 1

    return {
        "total_valid_amount": round(total_valid_amount, 2),
        "valid_count": valid_count,
        "failed_count": failed_count
    }


if __name__ == "__main__":
    if len(sys.argv) < 1:
        print(json.dumps({"error": "CSV file path required"}))
        sys.exit(1)

    result = reconcile(sys.argv[1])
    print(json.dumps(result))
