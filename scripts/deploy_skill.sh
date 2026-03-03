#!/bin/bash
# deploy_skill.sh - 部署 Skill 并同步到 GitHub

SKILL_NAME="ubuntu-ai-assistant"
SOURCE_DIR="/home/imovation/ubuntu-ai-assistant"
TARGET_DIR="/home/imovation/.config/opencode/skills/$SKILL_NAME"
MODEL_NAME="antigravity-gemini-3-flash"

echo "[PROCESS] Starting deployment and sync..."

# 1. 部署到本地 OpenCode
mkdir -p "$TARGET_DIR"
cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
echo "[SUCCESS] Local skill deployed to $TARGET_DIR"

# 2. Git 同步
cd "$SOURCE_DIR"
git add .
COMMIT_MSG="Evolution: Updated skill by $MODEL_NAME at $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

# 尝试推送到 GitHub (强制使用 main 分支)
git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo "[SUCCESS] Skill evolution synced to GitHub repository."
else
    echo "[ERROR] GitHub sync failed. Please check network or token."
fi
