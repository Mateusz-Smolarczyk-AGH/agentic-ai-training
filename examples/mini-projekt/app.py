#!/usr/bin/env python3
"""Workshop mini-project: a small set of statistical tools."""

import sys


def average(values):
    if not values:
        return 0.0
    return sum(values) / len(values)


def median(values):
    if not values:
        return 0.0
    ordered = sorted(values)
    return ordered[len(ordered) // 2]


def mode(values):
    if not values:
        return None
    counts = {}
    for value in values:
        counts[value] = counts.get(value, 0) + 1
    best = None
    for value in sorted(counts):
        if best is None or counts[value] > counts[best]:
            best = value
    return best


def word_counts(text):
    counts = {}
    for word in text.split():
        counts[word] = counts.get(word, 0) + 1
    return counts


def to_floats(args):
    try:
        return [float(a) for a in args]
    except ValueError as exc:
        raise ValueError(f"expected numbers, got: {' '.join(args)}") from exc


def main(argv):
    if not argv:
        print("Usage: python app.py <command> [arguments]")
        print("Commands: average, median, mode, count")
        return 1

    command, *args = argv

    try:
        if command == "average":
            print(average(to_floats(args)))
            return 0

        if command == "median":
            print(median(to_floats(args)))
            return 0

        if command == "mode":
            print(mode(to_floats(args)))
            return 0

        if command == "count":
            for word, n in word_counts(" ".join(args)).items():
                print(f"{word}: {n}")
            return 0
    except ValueError as exc:
        print(f"Error: {exc}")
        return 2

    print(f"Unknown command: {command}")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
