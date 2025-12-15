#!/bin/bash

set -e

echo "==================================="
echo "My Super Live Chat - Type Check"
echo "==================================="
echo ""

echo "Type checking frontend..."
cd frontend
npx tsc --noEmit

echo ""
echo "==================================="
echo "Type check passed!"
echo "==================================="
