---
id: d8mmh59fnm4mzuc6fjtm8pi
title: File Structure
desc: ""
updated: 1716033647430
created: 1715849599864
---

# File Structure

```
.
├── Dockerfile
├── LICENSE
├── README.md
├── Taskfile.yaml # Run tasks from here
├── apps
│   └── storefront
│       ├── README.md
│       ├── Taskfile.yaml
│       ├── next.config.mjs
│       ├── package.json
│       ├── postcss.config.mjs
│       ├── public -> ../../packages/cms/public/
│       ├── src
│       ├── tailwind.config.ts
│       └── tsconfig.json
├── bun.lockb
├── bunfig.toml
├── compose.yaml
├── docs
│   └── intro.md
├── flake.lock
├── flake.nix
├── graphql.config.ts
├── nix
│   └── default.nix
├── package.json
├── packages
│   ├── _template
│   │   ├── README.md
│   │   ├── Taskfile.yaml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── cms
│   │   ├── README.md
│   │   ├── Taskfile.yaml
│   │   ├── content
│   │   ├── exports
│   │   ├── package.json
│   │   ├── public
│   │   ├── server.ts
│   │   ├── src
│   │   ├── tina
│   │   └── tsconfig.json
│   ├── ecom
│   │   ├── README.md
│   │   ├── Taskfile.yaml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── eslint-config-eslint
│   │   ├── README.md
│   │   ├── config
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── shadcn
│   │   ├── README.md
│   │   ├── Taskfile.yaml
│   │   ├── components.json
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── tools
│   │   ├── README.md
│   │   ├── Taskfile.yaml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   └── ui
│       ├── README.md
│       ├── Taskfile.yaml
│       ├── exports
│       ├── package.json
│       ├── src
│       └── tsconfig.json
└── workspaces
    └── 001-w3yz.code-workspace
```
