# ADR 0002: DNS provider

**Status:** Accepted

## Decision
Use Route53 managed via Terraform; keep BIND zone files in `dns/` as a portable reference.

## Consequences
Health checks and alias records are available; vendor lock-in is mitigated by the zone files.
