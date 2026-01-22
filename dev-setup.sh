#!/usr/bin/env bash
# dev-setup.sh - Quick development environment setup script

set -e

echo "=========================================="
echo "ElasticScroll Development Setup"
echo "=========================================="
echo ""

# Check Python version
echo "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
required_version="3.7"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "Error: Python $required_version or higher is required. Found: $python_version"
    exit 1
fi
echo "✓ Python $python_version detected"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi
echo ""

# Activate virtual environment
echo "To activate the virtual environment, run:"
echo "  source venv/bin/activate"
echo ""

# Install dependencies
read -p "Install development dependencies now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing development dependencies..."
    source venv/bin/activate
    pip install --upgrade pip
    pip install -e ".[dev]"
    echo "✓ Development dependencies installed"
    echo ""
    echo "Setup complete! You can now:"
    echo "  - Run tests: make test"
    echo "  - Format code: make format"
    echo "  - Run linter: make lint"
    echo "  - Type check: make check-types"
    echo "  - See all commands: make help"
else
    echo "Skipping dependency installation."
    echo "To install later, activate venv and run: pip install -e \".[dev]\""
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
