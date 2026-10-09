#!/usr/bin/env bats

DOMAIN="${DOMAIN:-example.com}"

@test "apex domain resolves" {
  run dig +short A "$DOMAIN"
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "www resolves via CNAME" {
  run dig +short CNAME "www.$DOMAIN"
  [ "$status" -eq 0 ]
  [ -n "$output" ]
}

@test "MX record exists" {
  run dig +short MX "$DOMAIN"
  [ -n "$output" ]
}
