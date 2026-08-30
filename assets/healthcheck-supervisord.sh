#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# SupervisorD Health Check
# -----------------------------------------------------------------------------
# Healthy when:
#   - supervisord is responsive
#   - zero programs are configured, OR
#   - all configured programs are RUNNING
#
# Exit codes:
#   0 = healthy
#   1 = unhealthy
# -----------------------------------------------------------------------------

SUPERVISOR_CONFIG="/etc/supervisord.conf"

# Ensure supervisorctl exists
if ! command -v supervisorctl >/dev/null 2>&1; then
    echo "ERROR: supervisorctl not found"
    exit 1
fi

# Ensure supervisord itself is responsive
if ! supervisorctl -c "${SUPERVISOR_CONFIG}" pid >/dev/null 2>&1; then
    echo "ERROR: supervisord is not responding"
    exit 1
fi

# Get configured program status.
# supervisorctl may return non-zero when a program is not RUNNING,
# so don't use its exit code here.
STATUS_OUTPUT="$(
    supervisorctl -c "${SUPERVISOR_CONFIG}" status 2>/dev/null || true
)"

# No configured programs is valid
if [[ -z "${STATUS_OUTPUT}" ]]; then
    exit 0
fi

# Every configured program must be RUNNING
if echo "${STATUS_OUTPUT}" | grep -vqE '^[^[:space:]]+[[:space:]]+RUNNING[[:space:]]'; then
    echo "ERROR: One or more supervised processes are not RUNNING"
    echo "${STATUS_OUTPUT}"
    exit 1
fi

exit 0
