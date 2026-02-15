---
title: "Example TIL - Git Rebase Onto"
date: 2026-02-08
tags: ["git"]
draft: true
---

**TL;DR**: Use `git rebase --onto` to move a branch to a new base.

## The Problem

Sometimes you start a feature branch from the wrong commit, or the base branch changes significantly.

## The Solution

```bash
git rebase --onto new-base old-base feature-branch
```

This takes commits from `old-base..feature-branch` and replays them onto `new-base`.

## Example

```bash
# Move feature branch from develop to main
git rebase --onto main develop feature-branch
```
