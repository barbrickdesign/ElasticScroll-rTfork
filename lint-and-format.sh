#!/usr/bin/env bash
# lint-and-format.sh - Code quality check and formatting script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
CHECK_ONLY=false
if [[ "$1" == "--check" ]]; then
    CHECK_ONLY=true
fi

echo "=========================================="
echo "Code Quality Check and Formatting"
echo "=========================================="
echo ""

# Check if tools are installed
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}Warning: $1 not found. Install with: pip install $1${NC}"
        return 1
    fi
    return 0
}

# Run black
if check_tool black; then
    echo "Running Black (Python formatter)..."
    if [ "$CHECK_ONLY" = true ]; then
        if black --check elasticscroll/; then
            echo -e "${GREEN}✓ Black: Code is formatted correctly${NC}"
        else
            echo -e "${RED}✗ Black: Code needs formatting${NC}"
            echo "  Run: make format or ./lint-and-format.sh"
        fi
    else
        black elasticscroll/
        echo -e "${GREEN}✓ Black: Code formatted${NC}"
    fi
    echo ""
fi

# Run isort
if check_tool isort; then
    echo "Running isort (Import sorter)..."
    if [ "$CHECK_ONLY" = true ]; then
        if isort --check-only elasticscroll/; then
            echo -e "${GREEN}✓ isort: Imports are sorted correctly${NC}"
        else
            echo -e "${RED}✗ isort: Imports need sorting${NC}"
            echo "  Run: make format or ./lint-and-format.sh"
        fi
    else
        isort elasticscroll/
        echo -e "${GREEN}✓ isort: Imports sorted${NC}"
    fi
    echo ""
fi

# Run flake8
if check_tool flake8; then
    echo "Running flake8 (Linter)..."
    if flake8 elasticscroll/; then
        echo -e "${GREEN}✓ flake8: No linting errors${NC}"
    else
        echo -e "${RED}✗ flake8: Linting errors found${NC}"
    fi
    echo ""
fi

# Run mypy
if check_tool mypy; then
    echo "Running mypy (Type checker)..."
    if mypy elasticscroll/; then
        echo -e "${GREEN}✓ mypy: No type errors${NC}"
    else
        echo -e "${YELLOW}⚠ mypy: Type errors found${NC}"
    fi
    echo ""
fi

echo "=========================================="
if [ "$CHECK_ONLY" = true ]; then
    echo "Check complete!"
else
    echo "Formatting complete!"
fi
echo "=========================================="
