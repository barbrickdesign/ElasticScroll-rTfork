# Contributing to ElasticScroll

Thank you for your interest in contributing to ElasticScroll! This document provides guidelines and instructions for contributing.

## Development Setup

### Quick Setup

Run the development setup script:

```bash
./dev-setup.sh
```

This will:
- Check Python version (3.7+ required)
- Create a virtual environment
- Install development dependencies

### Manual Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/departmentofdefense/ElasticScroll
   cd ElasticScroll
   ```

2. **Create and activate virtual environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install development dependencies**
   ```bash
   pip install -e ".[dev]"
   ```

## Development Workflow

### Making Changes

1. Create a new branch for your feature or bugfix
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the code

3. Format your code
   ```bash
   make format
   # or
   ./lint-and-format.sh
   ```

4. Run linting and type checks
   ```bash
   make lint
   make check-types
   ```

5. Run tests
   ```bash
   make test
   # or with coverage
   make test-cov
   # or using the script
   ./run-tests.sh --coverage
   ```

### Code Quality Standards

- **Formatting**: Code must be formatted with Black (line length: 88)
- **Import Sorting**: Imports must be sorted with isort
- **Linting**: Code must pass flake8 checks
- **Type Hints**: Add type hints to all functions and methods
- **Documentation**: Update docstrings for any changed functionality

### Running All Checks

Run all checks at once:

```bash
make all
```

This runs formatting, linting, type checking, and tests.

## Available Commands

### Makefile Commands

- `make help` - Display all available commands
- `make install` - Install the package
- `make install-dev` - Install with development dependencies
- `make clean` - Remove build artifacts
- `make format` - Format code with Black and isort
- `make format-check` - Check formatting without changes
- `make lint` - Run flake8 linter
- `make check-types` - Run mypy type checker
- `make test` - Run tests
- `make test-cov` - Run tests with coverage
- `make build` - Build distribution packages
- `make all` - Run all checks

### Shell Scripts

- `./dev-setup.sh` - Quick development environment setup
- `./run-tests.sh` - Run tests with options:
  - `-c, --coverage` - Run with coverage
  - `-v, --verbose` - Verbose output
  - `-t, --test NAME` - Run specific test
- `./lint-and-format.sh` - Format and lint code
  - `--check` - Check only, don't modify files

## Testing

### Writing Tests

- Place tests in the `tests/` directory
- Name test files with `test_` prefix
- Use pytest fixtures and markers
- Aim for high code coverage

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=elasticscroll --cov-report=html

# Run specific test
pytest tests/test_specific.py

# Run tests matching pattern
pytest -k "test_scroll"
```

## Pull Request Process

1. Ensure all tests pass and code is properly formatted
2. Update documentation if needed
3. Add tests for new functionality
4. Update CHANGELOG.md if applicable
5. Submit pull request with clear description of changes
6. Wait for review and address any feedback

## Code Review Guidelines

- Code should be clean, readable, and well-documented
- All functions should have docstrings
- Type hints should be included
- Tests should cover new functionality
- No decrease in code coverage

## Reporting Issues

When reporting issues, please include:

- Python version
- Elasticsearch version
- Minimal code to reproduce the issue
- Expected vs actual behavior
- Error messages and stack traces

## Questions?

Feel free to open an issue for questions or discussions about contributing.

## License

By contributing to ElasticScroll, you agree that your contributions will be licensed under the MIT License.
