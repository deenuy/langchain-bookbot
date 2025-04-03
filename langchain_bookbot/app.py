import os


def sum(a: float, b: float) -> float:
    """
    Returns the sum of a and b.
    """
    return a + b


def subtract(a: float, b: float) -> float:
    """
    Returns the difference of a and b.
    """
    return a - b


def do_some_math():
    """
    Do some math.
    """
    a = 1.0
    b = 2.0
    c = sum(a, b)
    d = subtract(a, b)
    print(f"Sum: {c}, Difference: {d}")
