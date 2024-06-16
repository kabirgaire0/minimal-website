#!/bin/bash

# Source the .env file to load environment variables like $IP_ADDRESS and $PROJECT_NAME
source "$(dirname "$0")/.env"  # Adjust path if necessary

# Determine the directory where deploy.sh is located
script_dir="$(cd "$(dirname "$0")" && pwd)"
local_dir="$script_dir/project-files"  # Path to local directory containing files to deploy
remote_base_dir="/root"
remote_project_dir="$remote_base_dir/$PROJECT_NAME"
max_versions=3  # Maximum number of versions to keep on the remote server
http_server_port=8081  # Port on which http-server will serve the latest version

# Function to find the next available version number on the remote server
get_next_version() {
    local i=1
    while true; do
        # Check if the directory $remote_project_dir/$i exists on the remote server
        if ! ssh "root@$IP_ADDRESS" "[ -d \"$remote_project_dir/$i\" ]"; then
            echo "$i"  # Print the first available $i as the next version number
            return
        fi
        ((i++))
    done
}

# Function to delete older versions except the last max_versions
delete_old_versions() {
    # List all versions, sort by name (numeric), and skip the last max_versions
    local versions=$(ssh "root@$IP_ADDRESS" "ls -1d \"$remote_project_dir\"/*/ 2>/dev/null | sort -n | head -n -${max_versions}")
    for version in $versions; do
        # Delete each older version
        ssh "root@$IP_ADDRESS" "rm -rf \"$version\""
        echo "Deleted older version: $version"
    done
}

# Function to start http-server for the latest version
serve_latest_version() {
    local latest_version=$(ssh "root@$IP_ADDRESS" "ls -1d \"$remote_project_dir\"/*/ | sort -n | tail -n 1")
    echo "Starting http-server for the latest version: $latest_version"
    ssh "root@$IP_ADDRESS" "nohup http-server \"$latest_version\" -p $http_server_port >/dev/null 2>&1 & disown"
    echo "http-server started for version $latest_version. Access it at http://$IP_ADDRESS:$http_server_port"
}

# Check if local directory exists and has files
if [ ! -d "$local_dir" ] || [ -z "$(ls -A "$local_dir")" ]; then
    echo "Error: Local directory $local_dir does not exist or is empty."
    exit 1
fi

echo "Starting deployment..."

# Check if project directory exists on the remote server
if ssh "root@$IP_ADDRESS" "[ ! -d \"$remote_project_dir\" ]"; then
    echo "Creating project directory on the remote server: $remote_project_dir"
    ssh "root@$IP_ADDRESS" "mkdir -p \"$remote_project_dir\""
fi

# Determine the next available version number
next_version=$(get_next_version)
remote_version_dir="$remote_project_dir/$next_version"

# Ensure the version directory exists on the remote server
if ! ssh "root@$IP_ADDRESS" "[ -d \"$remote_version_dir\" ]"; then
    echo "Creating version directory on the remote server: $remote_version_dir"
    ssh "root@$IP_ADDRESS" "mkdir -p \"$remote_version_dir\""
fi

# Deploy all files and directories from local directory to remote server with versioning
echo "Copying files to remote server..."
scp -r "$local_dir"/* "root@$IP_ADDRESS:\"$remote_version_dir\"/"

# Check if files were copied successfully
scp_exit_code=$?
if [ $scp_exit_code -ne 0 ]; then
    echo "Error: Failed to copy files to remote server."
    exit 1
else
    echo "Files copied to: $remote_version_dir"
fi

echo "Deployment version $next_version complete."

# Delete older versions if there are more than max_versions
delete_old_versions

echo "Deleted older versions exceeding last $max_versions versions."

echo "Deployment complete."

# Start http-server for the latest version
serve_latest_version
