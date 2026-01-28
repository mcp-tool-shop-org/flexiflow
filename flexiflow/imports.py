"""Dynamic symbol loading from dotted paths."""

from __future__ import annotations

import importlib
from typing import Any


def load_symbol(dotted: str) -> Any:
    """
    Load a symbol from 'package.module:SymbolName'.

    Args:
        dotted: A string in the format 'module.path:SymbolName'

    Returns:
        The loaded symbol (class, function, etc.)

    Raises:
        ValueError: If the format is invalid, module can't be imported,
                    or symbol doesn't exist in the module.
    """
    if ":" not in dotted:
        raise ValueError(
            f"Invalid dotted path '{dotted}'. Expected format 'module.path:SymbolName'."
        )

    module_path, symbol_name = dotted.split(":", 1)
    module_path = module_path.strip()
    symbol_name = symbol_name.strip()

    if not module_path or not symbol_name:
        raise ValueError(
            f"Invalid dotted path '{dotted}'. Expected format 'module.path:SymbolName'."
        )

    try:
        module = importlib.import_module(module_path)
    except Exception as e:
        raise ValueError(
            f"Failed to import module '{module_path}' from '{dotted}': {e}"
        ) from None

    try:
        return getattr(module, symbol_name)
    except AttributeError:
        raise ValueError(
            f"Module '{module_path}' has no symbol '{symbol_name}' (from '{dotted}')."
        ) from None
