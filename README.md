# Elastic Scroll

A minimal library for efficient elasticsearch queries

[![CI](https://github.com/departmentofdefense/ElasticScroll/workflows/CI/badge.svg)](https://github.com/departmentofdefense/ElasticScroll/actions)
[![Python Version](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Simple, minimal API for Elasticsearch scroll queries
- Type hints for better IDE support
- Comprehensive error handling and logging
- Compatible with Elasticsearch 7.x and 8.x
- Support for Python 3.7+

## Install

```bash
git clone https://github.com/departmentofdefense/elasticscroll
cd elasticscroll
pip3 install .
```

### Development Installation

For development with all tools and dependencies:

```bash
pip3 install -e ".[dev]"
```

Or use the quick setup script:

```bash
./dev-setup.sh
```

## Upgrade

```bash
cd elasticscroll
git pull origin master
pip3 install --upgrade .
```

## Usage

```python
import elasticscroll

esm = elasticscroll.ElasticMinimal('https://your-es-endpoint')

lookup = {
    'query': {
        'term': {'id_resp_h': '192.83.203.129'}
    }
}

for res in esm.scroll_query('conn', lookup):
    print(res)
```

### Advanced Usage

```python
# Custom scroll size and timeout
for doc in esm.scroll_query('my_index', query, size=100, scroll='5m'):
    process(doc)

# Error handling
try:
    for doc in esm.scroll_query('my_index', query):
        process(doc)
except elasticsearch.exceptions.ElasticsearchException as e:
    print(f"Elasticsearch error: {e}")
```

## Development

### Quick Start

```bash
# Setup development environment
./dev-setup.sh

# Activate virtual environment
source venv/bin/activate

# Run all checks
make all
```

### Available Commands

```bash
make help           # Show all available commands
make test           # Run tests
make test-cov       # Run tests with coverage
make lint           # Run linter
make format         # Format code
make check-types    # Run type checker
```

### Testing

```bash
# Run tests
./run-tests.sh

# Run with coverage
./run-tests.sh --coverage

# Run specific test
./run-tests.sh --test test_scroll_query
```

### Code Quality

```bash
# Format and lint
./lint-and-format.sh

# Check only (don't modify)
./lint-and-format.sh --check
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and how to contribute.

## Requirements

- Python 3.7 or higher
- elasticsearch >= 7.0.0, < 9.0.0

## License

MIT