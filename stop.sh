#!/bin/bash

# ManagingTasks Docker Demo Stopper
# This script stops and removes the running Docker container.

echo "========================================="
echo "   ManagingTasks Docker Stop Script"
echo "========================================="

stopped=false

# 1. Stop and remove the Docker container
if docker ps -a --format '{{.Names}}' | grep -q "^managingtasks-app$"; then
    echo "Stopping Docker container 'managingtasks-app'..."
    docker stop managingtasks-app &>/dev/null
    echo "Removing Docker container 'managingtasks-app'..."
    docker rm managingtasks-app &>/dev/null
    echo "✔️ Stopped and removed container 'managingtasks-app'."
    stopped=true
else
    echo "⚠️ Docker container 'managingtasks-app' is not running."
fi

# 2. Clean up any residual local PIDs if present
if [ -f "dotnet.pid" ]; then
    PID=$(cat dotnet.pid)
    echo "Cleaning up local PID file and process $PID if active..."
    kill -9 $PID 2>/dev/null
    rm -f dotnet.pid
fi

if [ "$stopped" = true ]; then
    echo "🎉 Docker application stopped successfully."
else
    echo "ℹ️  No running Docker instances found."
fi
echo "========================================="
