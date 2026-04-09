#!/usr/bin/env python3
"""
CSE 512 HW8 - Hadoop MapReduce (Python Streaming)
Distributed Database Systems | Arizona State University
Author: Luna Sbahtu

Word Count implementation using Hadoop Streaming API.
Run with:
  hadoop jar hadoop-streaming.jar \
    -input /input/data.txt \
    -output /output/wordcount \
    -mapper mapper.py \
    -reducer reducer.py
"""

import sys
from collections import defaultdict


# ─────────────────────────────────────────────
# MAPPER
# ─────────────────────────────────────────────
def mapper():
    """
    Reads lines from stdin, emits (word, 1) for each word.
    """
    for line in sys.stdin:
        line = line.strip().lower()
        words = line.split()
        for word in words:
            # Remove punctuation
            word = ''.join(c for c in word if c.isalnum())
            if word:
                print(f"{word}\t1")


# ─────────────────────────────────────────────
# REDUCER
# ─────────────────────────────────────────────
def reducer():
    """
    Reads sorted (word, count) pairs from stdin, sums counts per word.
    """
    current_word = None
    current_count = 0

    for line in sys.stdin:
        line = line.strip()
        try:
            word, count = line.split('\t', 1)
            count = int(count)
        except ValueError:
            continue

        if word == current_word:
            current_count += count
        else:
            if current_word:
                print(f"{current_word}\t{current_count}")
            current_word = word
            current_count = count

    if current_word:
        print(f"{current_word}\t{current_count}")


# ─────────────────────────────────────────────
# LOCAL TEST (without Hadoop)
# ─────────────────────────────────────────────
def local_word_count(text):
    """Run word count locally to verify logic."""
    counts = defaultdict(int)
    for line in text.strip().split('\n'):
        for word in line.lower().split():
            word = ''.join(c for c in word if c.isalnum())
            if word:
                counts[word] += 1
    return sorted(counts.items(), key=lambda x: -x[1])


if __name__ == '__main__':
    sample_text = """
    Distributed databases store data across multiple nodes.
    Hadoop uses MapReduce to process large datasets in parallel.
    MapReduce splits data into chunks and processes them in parallel.
    Hadoop is widely used for big data processing.
    """

    print("=== Local Word Count Test ===")
    results = local_word_count(sample_text)
    for word, count in results[:10]:
        print(f"{word}: {count}")