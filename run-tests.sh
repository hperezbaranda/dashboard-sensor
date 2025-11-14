#!/bin/bash
# run-tests.sh - Helper script to run tests locally

set -e

echo "🧪 Running Dashboard Sensor Tests..."
echo ""

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "❌ pytest not found. Installing test dependencies..."
    pip install pytest pytest-cov pytest-asyncio httpx
    echo ""
fi

# Run tests based on argument
case "${1:-all}" in
    "quick")
        echo "Running quick tests (no coverage)..."
        pytest -v
        ;;
    "coverage")
        echo "Running tests with coverage report..."
        pytest -v --cov=. --cov-report=term-missing --cov-report=html
        echo ""
        echo "📊 Coverage report generated in htmlcov/index.html"
        ;;
    "watch")
        echo "Running tests in watch mode..."
        pytest-watch -v
        ;;
    "app")
        echo "Running app tests only..."
        pytest test_app.py -v
        ;;
    "utils")
        echo "Running utils tests only..."
        pytest test_utils.py -v
        ;;
    *)
        echo "Running all tests with coverage..."
        pytest -v --cov=. --cov-report=term-missing
        ;;
esac

echo ""
echo "✅ Tests complete!"
