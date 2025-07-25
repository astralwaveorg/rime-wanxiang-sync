#!/bin/bash

# ==============================================================================
# Git 历史重建脚本
# 警告：此脚本会自动删除所有旧备份，并强制推送覆盖远程历史，风险极高。
# ==============================================================================

# --- 全局配置 ---
# 请将此路径修改为您需要操作的 Git 仓库的根目录
GIT_REPO_PATH="$HOME/Library/Rime"

# --- 脚本核心 ---
set -e # 任何错误立即退出

# 定义颜色输出
print_green() { echo -e "\033[0;32m$1\033[0m"; }
print_red() { echo -e "\033[0;31m$1\033[0m"; }
print_blue() { echo -e "\033[0;34m$1\033[0m"; }
print_yellow() { echo -e "\033[0;33m$1\033[0m"; }

# 切换到仓库目录
cd "$GIT_REPO_PATH" || {
    print_red "❌ 错误：无法进入仓库目录: $GIT_REPO_PATH"
    exit 1
}

# 动态变量
BACKUP_BRANCH_PREFIX="backup/"
TEMP_BRANCH_NAME="temp_orphan_branch_$$"
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
BACKUP_BRANCH_NAME="${BACKUP_BRANCH_PREFIX}$CURRENT_BRANCH-$(date +%Y%m%d-%H%M%S)"

# 错误回滚函数
rollback() {
    print_red "\n💥 脚本执行失败！正在从本次备份回滚..."
    if git rev-parse --verify "$BACKUP_BRANCH_NAME" >/dev/null 2>&1; then
        git checkout "$BACKUP_BRANCH_NAME"
        git branch -f "$CURRENT_BRANCH" "$BACKUP_BRANCH_NAME"
        git checkout "$CURRENT_BRANCH"
        print_green "✅ 已从备份 '$BACKUP_BRANCH_NAME' 恢复。"
    else
        print_red "❌ 未找到本次备份，回滚失败！请手动检查。"
    fi
}
trap rollback ERR

# --- 主流程开始 ---

print_blue "▶️ [1/7] 检查仓库状态..."
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print_red "❌ 错误：'$GIT_REPO_PATH' 不是一个 Git 仓库。"
    exit 1
fi
print_green "✅ 仓库检查通过。"

print_blue "▶️ [2/7] 清理所有旧的备份分支..."
OLD_BACKUPS=$(git branch --list "${BACKUP_BRANCH_PREFIX}*")
if [ -n "$OLD_BACKUPS" ]; then
    print_yellow "   发现并删除以下旧备份:"
    echo "$OLD_BACKUPS" | sed 's/..//' | xargs -I {} echo "     - {}"
    echo "$OLD_BACKUPS" | xargs git branch -D
    print_green "✅ 所有旧备份已删除。"
else
    print_green "✅ 未发现旧的备份分支。"
fi

print_blue "▶️ [3/7] 创建新的本地备份..."
git branch "$BACKUP_BRANCH_NAME"
print_green "✅ 成功创建新备份: $BACKUP_BRANCH_NAME"

print_blue "▶️ [4/7] 检查并自动提交未暂存的更改..."
if ! git diff-index --quiet HEAD --; then
    git add -A
    git commit -m "chore(autocommit): 自动提交未暂存的更改"
    print_green "✅ 检测到更改并已自动提交。"
else
    print_green "✅ 工作区干净，无需提交。"
fi

print_blue "▶️ [5/7] 重建本地分支历史..."
git checkout --orphan "$TEMP_BRANCH_NAME" >/dev/null 2>&1
git add -A
git commit -m "chore(build): Rebuild branch '$CURRENT_BRANCH'" >/dev/null 2>&1
git branch -D "$CURRENT_BRANCH" >/dev/null 2>&1
git branch -m "$CURRENT_BRANCH"
print_green "✅ 本地分支 '$CURRENT_BRANCH' 已重建。"

print_blue "▶️ [6/7] 强制推送到远程仓库..."
git push --force origin "$CURRENT_BRANCH"
print_green "✅ 强制推送完成。"

trap - ERR # 成功完成，解除陷阱

print_blue "\n🎉 [7/7] 所有操作成功完成！"
print_yellow "   为安全起见，本次备份 '$BACKUP_BRANCH_NAME' 已在本地保留。"
print_yellow "   它将在下次运行时被自动清理。"

exit 0

