#!/bin/bash

# Set the path to the parent directory containing all the repositories
PARENT_DIR="/repos"

# Define an associative array for repositories with non-default branches
declare -A REPO_BRANCHES
REPO_BRANCHES=(
    #["repo1"]="develop"
    #["repo2"]="feature-branch"
)

# Loop through each subdirectory in the parent directory
for REPO_DIR in "$PARENT_DIR"/*/; do
    REPO_PATH="${REPO_DIR%/}"  # Remove trailing slash
    REPO_NAME=$(basename "$REPO_PATH")
    
    # Determine the branch for this repository
    BRANCH="${REPO_BRANCHES[$REPO_NAME]:-main}"

    echo "Checking repository at $REPO_PATH on branch $BRANCH"

    # Navigate to the repository directory
    cd "$REPO_PATH" || { echo "Directory $REPO_PATH not found"; continue; }

    # Ensure the local branch is the one to be checked/pulled
    git checkout "$BRANCH"

    # Fetch the latest changes from the repository
    git fetch origin

    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "origin/$BRANCH")
    BASE=$(git merge-base @ "origin/$BRANCH")

    # Check for uncommitted changes
    if [[ -n $(git status -s) ]]; then
        echo "Local changes detected. Committing changes..."
        git add .
        git commit -m "Deployment"
    fi

    # Determine the relationship between local and remote
    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "Repository at $REPO_PATH is up to date."
    elif [ "$LOCAL" = "$BASE" ]; then
        echo "Local repository is behind. Force pulling changes..."
        git reset --hard "origin/$BRANCH"
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "Local repository is ahead. Pushing changes..."
        git push origin "$BRANCH"
    else
        echo "Local and remote repositories have diverged. Force synchronizing..."
        # Overwrite local changes with remote
        git reset --hard "origin/$BRANCH"
        # Push the latest version back to remote
        git push --force origin "$BRANCH"
    fi
done