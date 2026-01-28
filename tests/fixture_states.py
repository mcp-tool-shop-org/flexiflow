"""Fixture states for testing dotted path imports."""

from flexiflow.state_machine import State


class FixtureInitial(State):
    """A simple fixture state for testing custom state loading."""

    async def handle_message(self, message, component):
        # Always stays in same state, just for testing import works
        return False, self


class AnotherFixtureState(State):
    """Another fixture state to test multiple imports."""

    async def handle_message(self, message, component):
        if message.get("type") == "advance":
            return True, FixtureInitial()
        return False, self


# Not a State subclass - for error testing
class NotAState:
    """This is not a State subclass, used for error testing."""
    pass
