#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.local.yml"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TIMESTAMP="$(date +%F-%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/sub2api-backup-${TIMESTAMP}.tar.gz"

if ! command -v docker >/dev/null 2>&1; then
  echo "[ERROR] docker is not installed"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "[ERROR] docker compose is not available"
  exit 1
fi

if [ ! -f "${SCRIPT_DIR}/.env" ]; then
  echo "[ERROR] ${SCRIPT_DIR}/.env not found"
  exit 1
fi

echo "[INFO] Repository root: ${REPO_ROOT}"
echo "[INFO] Deploy dir: ${SCRIPT_DIR}"

if [ "${SKIP_BACKUP:-0}" != "1" ]; then
  mkdir -p "${BACKUP_DIR}"
  echo "[INFO] Creating backup: ${BACKUP_FILE}"
  tar czf "${BACKUP_FILE}" \
    --ignore-failed-read \
    -C "${SCRIPT_DIR}" \
    .env \
    data \
    postgres_data \
    redis_data
  echo "[INFO] Backup completed"
else
  echo "[INFO] Backup skipped because SKIP_BACKUP=1"
fi

cd "${REPO_ROOT}"

CURRENT_BRANCH="$(git branch --show-current)"
echo "[INFO] Current branch: ${CURRENT_BRANCH}"

echo "[INFO] Pulling latest code from origin/${CURRENT_BRANCH}..."
git pull origin "${CURRENT_BRANCH}"

cd "${SCRIPT_DIR}"

echo "[INFO] Rebuilding and restarting sub2api stack..."
docker compose -f "${COMPOSE_FILE}" up -d --build

echo "[INFO] Current sub2api image:"
docker inspect sub2api --format '{{.Config.Image}}'

echo "[INFO] Container status:"
docker ps | grep sub2api || true

echo "[INFO] Recent sub2api logs:"
docker compose -f "${COMPOSE_FILE}" logs --tail=50 sub2api

echo "[SUCCESS] Update completed."
