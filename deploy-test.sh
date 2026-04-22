#!/bin/bash
# deploy-test.sh - Tạo branch deploy test từ feature branch
# Usage: ./deploy-test.sh <feature-branch>

set -e

FEATURE_BRANCH=${1:-$(git branch --show-current)}

if [ -z "$FEATURE_BRANCH" ]; then
  echo "Error: Không có branch hiện tại. Cung cấp tên branch: ./deploy-test.sh <feature-branch>"
  exit 1
fi

TIMESTAMP=$(date '+%d_%m_%Y_%H_%M')
DEPLOY_BRANCH="chore/$TIMESTAMP"

echo "=== Deploy Test Script ==="
echo "Feature branch: $FEATURE_BRANCH"
echo "Deploy branch: $DEPLOY_BRANCH"
echo ""

# 1. Checkout feature và pull latest
echo "1. Checkout và pull latest feature branch..."
git checkout "$FEATURE_BRANCH"
git pull origin "$FEATURE_BRANCH"

# 2. Tạo branch deploy test
echo "2. Tạo deploy test branch..."
git checkout -b "$DEPLOY_BRANCH"

# 3. Push lên GitHub
echo "3. Push lên GitHub..."
git push -u origin "$DEPLOY_BRANCH"

# 4. Tạo PR (optional - tracking)
echo "4. Tạo PR (optional)..."
gh pr create --base "$FEATURE_BRANCH" --head "$DEPLOY_BRANCH" \
  --title "deploy: test $TIMESTAMP" \
  --body "## Deploy Test

Deploy branch để test trên Hostinger.

**Branch:** \`$DEPLOY_BRANCH\`
**Feature:** \`$FEATURE_BRANCH\`

### Trên Hostinger
\`\`\`bash
git fetch origin
git checkout $DEPLOY_BRANCH
git pull origin $DEPLOY_BRANCH
\`\`\`

### Sau khi test OK
- Merge PR: \`chore/*\` → \`$FEATURE_BRANCH\`
- Tạo PR: \`$FEATURE_BRANCH\` → \`main\`
- Hostinger switch về \`main\`

---
*Script: deploy-test.sh*"

echo ""
echo "=== Hoàn tất ==="
echo "Deploy branch: $DEPLOY_BRANCH"
echo "PR đã tạo: $(gh pr view --json url --jq '.url' 2>/dev/null || echo 'Tạo PR thủ công: gh pr create')"
echo ""
echo "Trên Hostinger:"
echo "  git fetch origin"
echo "  git checkout $DEPLOY_BRANCH"
echo "  git pull origin $DEPLOY_BRANCH"
