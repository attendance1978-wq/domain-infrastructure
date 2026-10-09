# ADR 0001: Use Terraform

**Status:** Accepted

## Context
We need reproducible, reviewable infrastructure across three environments.

## Decision
Use Terraform with remote S3 state, modules, and per-environment roots.

## Consequences
Plan/apply in CI, state locking via DynamoDB, provider version pinning required.
