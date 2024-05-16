#!/usr/bin/env bash

bun install
bun "--filter=@w3yz-app/tinacms" run build
task cms:generate
bun "--filter=@w3yz-app/tinacms" run start -p 3200
