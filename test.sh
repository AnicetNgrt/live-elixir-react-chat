#!/bin/bash

set -e

echo "==================================="
echo "My Super Live Chat - Test Script"
echo "==================================="
echo ""

echo "Testing Backend..."
cd backend
mix test

echo ""
echo "==================================="
echo "All tests completed!"
echo "==================================="
