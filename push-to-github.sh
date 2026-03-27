#!/bin/bash
# -------------------------------------------------------
# Push gtm-pixel-slave to GitHub under org/user: tagslave
# Run this from inside the gtm-pixel-slave/ folder
# -------------------------------------------------------

REPO="tagslave/gtm-pixel-slave"

echo "Initialising git repo..."
git init
git add .
git commit -m "feat: initial folder structure for gtm-pixel-slave knowledge base"

echo ""
echo "Creating GitHub repo and pushing..."
echo "Make sure you're authenticated: run 'gh auth login' first if needed."
echo ""

gh repo create "$REPO" --public --source=. --remote=origin --push

echo ""
echo "Done! Repo live at: https://github.com/$REPO"
