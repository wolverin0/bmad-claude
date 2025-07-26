#!/bin/bash

echo "Enhanced BMAD Method - GitHub Push Helper"
echo "========================================"
echo ""
echo "First, create a new repository on GitHub:"
echo "1. Go to https://github.com/new"
echo "2. Name it (e.g., 'enhanced-bmad-method')"
echo "3. Keep it empty (no README, .gitignore, or license)"
echo ""
read -p "Have you created the repository? (y/n): " created

if [ "$created" != "y" ]; then
    echo "Please create the repository first, then run this script again."
    exit 1
fi

echo ""
read -p "Enter your GitHub username: " username
read -p "Enter the repository name: " reponame
echo ""
echo "Choose connection method:"
echo "1) HTTPS"
echo "2) SSH"
read -p "Enter choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
    remote_url="https://github.com/$username/$reponame.git"
else
    remote_url="git@github.com:$username/$reponame.git"
fi

echo ""
echo "Adding remote origin: $remote_url"
git remote add origin "$remote_url"

echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "Done! Your repository should now be available at:"
echo "https://github.com/$username/$reponame"