---
title: For Beginners
description: New to FlexiFlow? Start here for a gentle introduction.
sidebar:
  order: 99
---

## What Is This Tool?

FlexiFlow is a lightweight Python library for building async workflows with components, events, and state machines. You define components with rules, wire them together through an event bus, and FlexiFlow manages state transitions, persistence, and structured logging.

Unlike heavyweight workflow engines, FlexiFlow is small (under 2,000 lines), has no heavy dependencies, and doesn't force you into a DAG model. Components communicate through events and follow state machines you define.

## Who Is This For?

- **Python developers** building async applications that need structured state management
- **Backend engineers** who want a lightweight alternative to heavy workflow engines like Airflow or Prefect
- **Prototypers** who need quick component wiring with events and state machines
- **Teams** that want explainable, config-driven workflows with built-in persistence

## Prerequisites

1. **Python 3.10+** — Check with `python --version`. Install from [python.org](https://www.python.org/downloads/)
2. **pip** — Python's package manager (comes with Python)
3. **Basic async Python knowledge** — FlexiFlow uses `asyncio` throughout

No API keys, no cloud services, no databases required (SQLite is optional for production persistence).

## Your First 5 Minutes

**Minute 1: Install**
```bash
pip install flexiflow
```

**Minute 2: Register a component via CLI**
```bash
flexiflow register --config examples/config.yaml --start
```
This creates a component from the YAML config and starts it running.

**Minute 3: Send events**
```bash
flexiflow handle --config examples/config.yaml confirm --content confirmed
flexiflow handle --config examples/config.yaml complete
```
These send events through the state machine, triggering transitions.

**Minute 4: Try it in Python**
```python
import asyncio
from flexiflow import Engine, Component

async def main():
    engine = Engine()
    comp = Component(name="greeter", rules={"on_start": "say_hello"})
    engine.register(comp)
    await engine.start()

asyncio.run(main())
```

**Minute 5: Inspect configuration**
```bash
flexiflow explain --config examples/config.yaml
```
This validates the config and shows you what FlexiFlow will do before you run it.

## Common Mistakes

1. **Forgetting async** — FlexiFlow is async throughout. Use `await` when calling engine methods, and run everything inside `asyncio.run()` or an async context
2. **Expecting a DAG runner** — FlexiFlow is not Airflow. Components communicate through events and state machines, not directed acyclic graphs. State transitions are event-driven, not schedule-driven
3. **Skipping `explain()`** — Before running a workflow, use `explain()` or `flexiflow explain` to validate your configuration. It catches misconfigurations before runtime
4. **Not choosing a persistence backend** — By default, FlexiFlow uses JSON files for state. For production, use SQLite persistence (`flexiflow[reload]` extra) to get snapshot history and pruning
5. **Overcomplicating state machines** — Start with simple states (idle → active → done) before adding complex transitions. FlexiFlow's state machines are declarative — define transitions in config, not code

## Next Steps

- Follow the full [Getting Started](../getting-started/) guide for detailed setup
- Learn about [State Machines](../state-machines/) and how to define transitions
- Understand the [Event Bus](../event-bus/) for component communication
- See the [Reference](../reference/) for all CLI commands and configuration options

## Glossary

- **Component** — A named unit of work with rules and a state machine. Components are registered with the engine and respond to events
- **Engine** — The core runtime that manages components, dispatches events, and handles persistence
- **Event bus** — The communication channel between components. Events have priority, can be filtered, and are delivered sequentially or concurrently
- **State machine** — A declarative definition of valid states and transitions for a component. Defined in config, not code
- **Rules** — Declarative configuration that maps events to actions within a component
- **Persistence** — Saving component state to disk. JSON for development, SQLite for production. Supports snapshot history and pruning
- **Correlation ID** — A unique identifier attached to log entries so you can trace an event through the entire system
- **Hot-swap** — Updating component rules at runtime without restarting the engine. Use `flexiflow update_rules` or the API
- **Config introspection** — The `explain()` method that validates configuration and shows what FlexiFlow will do before you run it
