#!/bin/bash

# Make sure we are in sync-repos directory
cd /repos/sync-repos

# Chmod the "sync_repos.sh" fro execution
chmod +x sync_repos.sh

# Ensure the source and destination directories exist
SOURCE_DIR="/repos/sync-repos/service-config"
DEST_DIR="/etc/systemd/system"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory $SOURCE_DIR does not exist."
  exit 1
fi

# Check if the destination directory exists
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory $DEST_DIR does not exist."
  exit 1
fi

# Copy the contents of the source directory to the destination
cp -r "$SOURCE_DIR"/* "$DEST_DIR/"

# Check if the copy operation was successful
if [ $? -eq 0 ]; then
  echo "Files copied successfully."
else
  echo "An error occurred while copying files."
  exit 1
fi

sudo systemctl enable sync_repos.timer
sudo systemctl start sync_repos.timer
sudo systemctl status sync_repos.timer
sudo systemctl status sync_repos.service
