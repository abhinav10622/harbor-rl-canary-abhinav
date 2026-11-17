#!/bin/bash
set -u
P=/app/reconcile.py
CSV=/tmp/reconcile_test.csv
score=0

# Test 1: CLI handling (20 points)
set +e
OUT=$(python "$P" 2>/dev/null)
CODE=$?
set -e
if [ "$CODE" -ne 0 ] && echo "$OUT" | python -c 'import json,sys; assert "error" in json.load(sys.stdin)' 2>/dev/null; then
    score=$((score + 20))
fi

# Test 2: Status filtering (25 points)
cat > "$CSV" <<'CSVEOF'
tx_id,timestamp,amount,status
a,2024-01-01T10:00:00+00:00,10,SUCCESS
b,2024-01-01T10:00:00+00:00,5,PENDING
c,2024-01-01T10:00:00+00:00,7,FAILED
CSVEOF
if python "$P" "$CSV" 2>/dev/null | python -c '
import json,sys
d=json.load(sys.stdin)
assert d == {"total_valid_amount":10.0,"valid_count":1,"failed_count":2}
' 2>/dev/null; then
    score=$((score + 25))
fi

# Test 3: Timezone-aware duplicate handling (25 points)
cat > "$CSV" <<'CSVEOF'
tx_id,timestamp,amount,status
x,2024-01-01T10:00:00+02:00,100,SUCCESS
x,2024-01-01T08:30:00+00:00,200,FAILED
CSVEOF
if python "$P" "$CSV" 2>/dev/null | python -c '
import json,sys
d=json.load(sys.stdin)
assert d == {"total_valid_amount":0.0,"valid_count":0,"failed_count":1}
' 2>/dev/null; then
    score=$((score + 25))
fi

# Test 4: Independent data, whitespace and case handling (30 points)
cat > "$CSV" <<'CSVEOF'
tx_id,timestamp,amount,status
p,2024-02-01T10:00:00+02:00,100,SUCCESS
p,2024-02-01T08:30:00+00:00,200,FAILED
q,2024-02-01T11:00:00+00:00,3.5, success
r,not-a-date,99,SUCCESS
CSVEOF
if python "$P" "$CSV" 2>/dev/null | python -c '
import json,sys
d=json.load(sys.stdin)
assert d == {"total_valid_amount":3.5,"valid_count":1,"failed_count":1}
' 2>/dev/null; then
    score=$((score + 30))
fi

echo "$score"
