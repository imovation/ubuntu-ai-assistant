#!/bin/bash
# deploy_skill.sh - 部署 Skill 并同步到双 GitHub 仓库 (ubuntu-ai-assistant 和 skills)

SKILL_NAME="ubuntu-ai-assistant"
SOURCE_DIR="/home/imovation/ubuntu-ai-assistant"
SKILLS_REPO_DIR="/home/imovation/skills_repo"
OPENCORD_SKILLS_DIR="/home/imovation/.config/opencode/skills/$SKILL_NAME"
MODEL_NAME="antigravity-gemini-3-flash"

echo "[PROCESS] Starting deployment and dual-sync..."

# 1. 部署到本地 OpenCode 生产环境
mkdir -p "$OPENCORD_SKILLS_DIR"
cp "$SOURCE_DIR/SKILL.md" "$OPENCORD_SKILLS_DIR/SKILL.md"
echo "[SUCCESS] Local production skill updated: $OPENCORD_SKILLS_DIR"

# 2. 同步到项目仓库 (ubuntu-ai-assistant)
echo "[PROCESS] Syncing to project repository..."
cd "$SOURCE_DIR"
git add .
COMMIT_MSG="Evolution: Updated skill by $MODEL_NAME at $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"
git branch -M main
git push -u origin main
echo "[SUCCESS] Project repository synced."

# 3. 同步到正式 Skills 仓库 (skills)
echo "[PROCESS] Syncing to formal skills repository..."
if [ -d "$SKILLS_REPO_DIR" ]; then
    # 确保目标子目录存在
    mkdir -p "$SKILLS_REPO_DIR/$SKILL_NAME"
    cp "$SOURCE_DIR/SKILL.md" "$SKILLS_REPO_DIR/$SKILL_NAME/SKILL.md"
    
    cd "$SKILLS_REPO_DIR"
    git add .
    git commit -m "Update $SKILL_NAME skill from $MODEL_NAME"
    git branch -M main
    git push -u origin main
    echo "[SUCCESS] Formal skills repository synced."
else
    echo "[ERROR] Skills repository directory not found at $SKILLS_REPO_DIR"
fi

echo "[FINISH] All deployments and syncs completed."
