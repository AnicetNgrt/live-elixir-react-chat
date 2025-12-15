#!/bin/bash

set -e

echo "==================================="
echo "My Super Live Chat - Setup Script"
echo "==================================="
echo ""

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 is not installed"
        echo "Please install $1 and try again"
        exit 1
    fi
}

echo "Checking dependencies..."
check_command docker
check_command mix
check_command node
check_command npm

echo "All dependencies found!"
echo ""

echo "Starting Docker services (PostgreSQL & Redis)..."
docker compose up -d

echo "Waiting for services to be healthy..."
sleep 5

until docker compose ps | grep -q "healthy"; do
    echo "Waiting for Docker services..."
    sleep 2
done

echo "Docker services are ready!"
echo ""

echo "Installing Elixir build tools..."
mix local.hex --force
mix local.rebar --force

echo ""
echo "Installing backend dependencies..."
cd backend
mix deps.get
mix compile

echo ""
echo "Setting up database..."
mix ecto.create
mix ecto.migrate

echo ""
echo "Installing frontend dependencies..."
cd ../frontend
npm install

echo ""
echo "==================================="
echo "Setup completed successfully!"
echo "==================================="
echo ""
echo "To start the application:"
echo "  Backend:  cd backend && mix phx.server"
echo "  Frontend: cd frontend && npm run dev"
echo ""
echo "Or use the launch script: ./launch.sh"
echo ""
