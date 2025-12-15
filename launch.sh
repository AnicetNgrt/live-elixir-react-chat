#!/bin/bash

echo "==================================="
echo "My Super Live Chat - Launch Script"
echo "==================================="
echo ""

if ! docker compose ps | grep -q "healthy"; then
    echo "Docker services not running. Starting them..."
    docker compose up -d
    echo "Waiting for services to be healthy..."
    sleep 5
fi

echo "Launching backend server..."
cd backend
mix phx.server &
BACKEND_PID=$!

echo "Waiting for backend to start..."
sleep 5

echo "Launching frontend server..."
cd ../frontend
npm run dev &
FRONTEND_PID=$!

echo ""
echo "==================================="
echo "Application is running!"
echo "==================================="
echo ""
echo "Backend:  http://localhost:4000"
echo "Frontend: http://localhost:5173"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

trap "echo 'Stopping servers...'; kill $BACKEND_PID $FRONTEND_PID; exit" INT TERM

wait
