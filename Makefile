# Flexiflow - Makefile for Development
# Simplifies common development tasks

.PHONY: help venv dev install test test-cov lint format typecheck security clean verify

help:  ## Show this help message
	@echo "Flexiflow Development Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

venv:  ## Create virtual environment
	python -m venv .venv
	@echo "Virtual environment created. Activate with:"
	@echo "  source .venv/bin/activate  (Linux/Mac)"
	@echo "  .venv\\Scripts\\activate     (Windows)"

dev: venv  ## Set up development environment
	. .venv/bin/activate && pip install --upgrade pip
	. .venv/bin/activate && pip install -e ".[dev]"
	. .venv/bin/activate && pre-commit install
	@echo "Development environment ready!"

install:  ## Install package with dev dependencies
	pip install -e ".[dev]"

test:  ## Run all tests
	pytest -v

test-cov:  ## Run tests with coverage report
	pytest -v --cov=flexiflow --cov-report=html --cov-report=term-missing
	@echo "Coverage report: htmlcov/index.html"

lint:  ## Run linting checks
	ruff check .

format:  ## Format code with ruff
	ruff format .
	ruff check . --fix

typecheck:  ## Run type checking
	mypy flexiflow

security:  ## Run security checks
	pip-audit

pre-commit:  ## Run all pre-commit hooks
	pre-commit run --all-files

clean:  ## Clean build artifacts
	rm -rf build/ dist/ *.egg-info/ .pytest_cache/ .mypy_cache/ .ruff_cache/ htmlcov/ .coverage
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

verify:  ## Run all verification steps
	@echo "Running linting..."
	@$(MAKE) lint
	@echo "Running type checking..."
	@$(MAKE) typecheck
	@echo "Running tests..."
	@$(MAKE) test-cov
	@echo "All checks passed!"

cli-help:  ## Test CLI help command
	python -m flexiflow --help

cli-test:  ## Run example workflow
	@echo "Testing CLI with example config..."
	@echo "Set FLEXIFLOW_CONFIG to test with your config"
