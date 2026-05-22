#!/bin/bash

# ManagingTasks Docker Demo Runner
# This script builds the Docker image, runs migrations inside an SDK container, and starts the app container.

echo "========================================="
echo "   ManagingTasks Docker Run Script"
echo "========================================="

# 1. Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed."
    echo "Please install Docker on Ubuntu using:"
    echo "   sudo apt-get update && sudo apt-get install -y docker.io"
    exit 1
fi

# 2. Prepare database file to avoid Docker mounting it as a folder
if [ ! -f "app.db" ]; then
    echo "📝 Creating empty 'app.db' file to prepare for volume mount..."
    touch app.db
fi

# 3. Run migrations using a temporary .NET SDK Docker container (Zero-install host migrations!)
echo "📦 Running database migrations in .NET SDK container..."
docker run --rm \
  -v "$(pwd):/src" \
  -w "/src" \
  mcr.microsoft.com/dotnet/sdk:8.0 \
  bash -c "dotnet tool install --global dotnet-ef && export PATH=\$PATH:\$HOME/.dotnet/tools && dotnet restore && dotnet ef database update"

if [ $? -ne 0 ]; then
    echo "❌ Database migration failed. Checking output..."
    exit 1
fi
echo "✔️ Database migrations applied successfully."

# 4. Stop any existing running container
if docker ps -a --format '{{.Names}}' | grep -q "^managingtasks-app$"; then
    echo "⚠️ Stopping and removing existing 'managingtasks-app' container..."
    docker stop managingtasks-app &>/dev/null
    docker rm managingtasks-app &>/dev/null
fi

# 5. Build the Docker image
echo "🛠️ Building Docker image..."
docker build -t managingtasks:latest .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed."
    exit 1
fi
echo "✔️ Docker image built successfully."

# 6. Start the container
echo "🚀 Launching 'managingtasks-app' container..."
docker run -d \
  --name managingtasks-app \
  -p 5182:5182 \
  -v "$(pwd)/app.db:/app/app.db" \
  managingtasks:latest

if [ $? -eq 0 ]; then
    echo "========================================="
    echo "🎉 Application started successfully in Docker!"
    echo "💻 URL: http://localhost:5182"
    echo "📝 View logs: docker logs -f managingtasks-app"
    echo "ℹ️  To stop the application, run: ./stop.sh"
    echo "========================================="
else
    echo "❌ Error: Failed to start Docker container."
    exit 1
fi
