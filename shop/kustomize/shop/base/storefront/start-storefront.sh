#!/usr/bin/env bash

bun install
bun "--filter=@w3yz-app/tinacms" run build
task ecom:generate cms:generate
bun "--filter=@w3yz-app/storefront" run build
bun "--filter=@w3yz-app/storefront" run start
