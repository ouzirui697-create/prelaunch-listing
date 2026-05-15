#!/usr/bin/env bash
# prelaunch-listing skill installer

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="prelaunch-listing"

# 默认安装到用户级别；传入 --project 安装到当前项目
TARGET_BASE="${HOME}/.claude/skills"
SCOPE="user"

if [[ "${1:-}" == "--project" ]]; then
  TARGET_BASE=".claude/skills"
  SCOPE="project"
fi

TARGET_DIR="${TARGET_BASE}/${SKILL_NAME}"

echo "==> Installing ${SKILL_NAME} skill (${SCOPE} scope)"
echo "    Target: ${TARGET_DIR}"

if [[ -d "${TARGET_DIR}" ]]; then
  echo "    Existing install found — backing up to ${TARGET_DIR}.bak"
  rm -rf "${TARGET_DIR}.bak"
  mv "${TARGET_DIR}" "${TARGET_DIR}.bak"
fi

mkdir -p "${TARGET_DIR}"
cp "${SCRIPT_DIR}/SKILL.md" "${TARGET_DIR}/SKILL.md"
cp -r "${SCRIPT_DIR}/references" "${TARGET_DIR}/references"

echo "==> Done."
echo ""
echo "Use it in Claude Code:"
echo "    /${SKILL_NAME}"
