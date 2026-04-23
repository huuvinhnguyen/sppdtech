#!/bin/bash

# Deploy script for Hostinger (sppdtech.com)
# Usage: ./deploy-hostinger.sh [branch]
#   - No args: create chore/dd_mm_yyyy_hh_ss, create PR, push, deploy
#   - With args: deploy that branch

HOST="ssh -p 65002 u200682234@185.187.241.39"
DIR="/home/u200682234/domains/sppdtech.com/public_html"

if [ -z "$1" ]; then
    # Auto create chore branch with current date
    BRANCH="chore/$(date '+%d_%m_%Y_%H_%M_%S')"
    echo "📝 Creating new chore branch: $BRANCH"
    git checkout -b "$BRANCH"
    git push -u origin "$BRANCH"
    
    echo "🔄 Creating PR..."
    gh pr create --base main --head "$BRANCH" --title "deploy: $BRANCH" --body "## Deploy Test

**Branch:** \`$BRANCH\`

### Trên Hostinger
\`\`\`bash
./deploy-hostinger.sh $BRANCH
\`\`\`"
else
    BRANCH=$1
fi

echo "🚀 Deploying $BRANCH to sppdtech.com..."

$HOST "cd $DIR && git fetch origin && git checkout $BRANCH && git pull origin $BRANCH && git log --oneline -3"

echo "🧹 Clearing LiteSpeed cache..."
$HOST "cd $DIR && rm -rf wp-content/cache/litespeed/* 2>/dev/null; wp option set litespeed.conf.cache-mobile 'false' 2>/dev/null || true"
$HOST "cd $DIR && wp option set litespeed.conf.cache-mobile_rules '[]' 2>/dev/null || true"

echo "✅ Done!"
echo "   PR: https://github.com/huuvinhnguyen/sppdtech/pull/new/$BRANCH"
echo "   Site: https://sppdtech.com"
