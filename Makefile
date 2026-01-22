# Makefile - Build and development automation

.PHONY: help install install-dev clean lint format test test-cov build upload check-types all

help:
	@echo "ElasticScroll Development Commands"
	@echo "===================================="
	@echo "install        - Install the package"
	@echo "install-dev    - Install package with development dependencies"
	@echo "clean          - Remove build artifacts and cache files"
	@echo "lint           - Run flake8 linter"
	@echo "format         - Format code with black and isort"
	@echo "format-check   - Check code formatting without changes"
	@echo "test           - Run tests"
	@echo "test-cov       - Run tests with coverage report"
	@echo "check-types    - Run mypy type checker"
	@echo "build          - Build distribution packages"
	@echo "upload         - Upload package to PyPI (requires credentials)"
	@echo "all            - Run format, lint, type check, and tests"

install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

lint:
	flake8 elasticscroll/

format:
	black elasticscroll/
	isort elasticscroll/

format-check:
	black --check elasticscroll/
	isort --check-only elasticscroll/

test:
	pytest

test-cov:
	pytest --cov=elasticscroll --cov-report=html --cov-report=term

check-types:
	mypy elasticscroll/

build: clean
	python -m pip install --upgrade build
	python -m build

upload: build
	python -m pip install --upgrade twine
	python -m twine upload dist/*

all: format lint check-types test
