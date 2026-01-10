#!/usr/bin/env bash
# run-tests.sh - Test runner script with various options

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Default values
COVERAGE=false
VERBOSE=false
SPECIFIC_TEST=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--coverage)
            COVERAGE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -t|--test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -c, --coverage     Run with coverage report"
            echo "  -v, --verbose      Verbose output"
            echo "  -t, --test NAME    Run specific test"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Build pytest command
PYTEST_CMD="pytest"

if [ "$VERBOSE" = true ]; then
    PYTEST_CMD="$PYTEST_CMD -v"
fi

if [ "$COVERAGE" = true ]; then
    PYTEST_CMD="$PYTEST_CMD --cov=elasticscroll --cov-report=term-missing --cov-report=html"
fi

if [ -n "$SPECIFIC_TEST" ]; then
    PYTEST_CMD="$PYTEST_CMD -k $SPECIFIC_TEST"
fi

# Check if tests directory exists
if [ ! -d "tests" ]; then
    echo "Warning: tests directory not found. Creating placeholder..."
    mkdir -p tests
    echo "# Placeholder for tests" > tests/__init__.py
    echo "def test_placeholder():"  > tests/test_example.py
    echo "    assert True" >> tests/test_example.py
    echo "Created basic test structure. Please add real tests."
fi

# Run tests
echo "Running tests with command: $PYTEST_CMD"
echo "=========================================="
$PYTEST_CMD

if [ "$COVERAGE" = true ]; then
    echo ""
    echo "Coverage report generated in htmlcov/index.html"
fi
