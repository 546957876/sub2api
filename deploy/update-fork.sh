#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.local.yml"

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

# shellcheck disable=SC1090
set -a
. "${SCRIPT_DIR}/.env"
set +a

echo "[INFO] Repository root: ${REPO_ROOT}"
echo "[INFO] Deploy dir: ${SCRIPT_DIR}"

cd "${REPO_ROOT}"

CURRENT_BRANCH="$(git branch --show-current)"
echo "[INFO] Current branch: ${CURRENT_BRANCH}"

echo "[INFO] Pulling latest code from origin/${CURRENT_BRANCH}..."
git pull origin "${CURRENT_BRANCH}"

cd "${SCRIPT_DIR}"

TARGET_IMAGE="${SUB2API_IMAGE:-ghcr.io/546957876/sub2api:main}"
echo "[INFO] Target image: ${TARGET_IMAGE}"

if [[ "${TARGET_IMAGE}" == ghcr.io/* ]] && [ -n "${GHCR_USERNAME:-}" ] && [ -n "${GHCR_TOKEN:-}" ]; then
  echo "[INFO] Logging into ghcr.io with configured credentials..."
  printf '%s' "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin
fi

echo "[INFO] Pulling latest container images..."
docker compose -f "${COMPOSE_FILE}" pull

echo "[INFO] Restarting sub2api stack without local rebuild..."
docker compose -f "${COMPOSE_FILE}" up -d --no-build --remove-orphans

echo "[INFO] Current sub2api image:"
docker inspect sub2api --format '{{.Config.Image}}'

echo "[INFO] Container status:"
docker ps | grep sub2api || true

echo "[INFO] Recent sub2api logs:"
docker compose -f "${COMPOSE_FILE}" logs --tail=50 sub2api

echo "[SUCCESS] Update completed."
