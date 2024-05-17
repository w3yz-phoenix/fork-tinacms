#!/usr/bin/env bash

kubectl create secret docker-registry ghcr-secret --dry-run=client \
  --docker-server=ghcr.io \
  --docker-username=yasinuslu \
  --docker-password="$(gh auth token)" \
  --docker-email="nepjua@gmail.com" \
  -o yaml > ./gen/ghcr-secret.yaml
