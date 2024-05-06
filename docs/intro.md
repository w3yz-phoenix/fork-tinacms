# Intro

## Repository

- Old one: https://github.com/w3yz-phoenix/w3yz-legacy
- New one: https://github.com/w3yz-phoenix/w3yz

## File Structure:

```
.
├── Dockerfile
├── LICENSE
├── README.md
├── Taskfile.yml
├── apps
│   ├── storefront
│   │   ├── next-env.d.ts
│   │   └── public
│   └── web
│       ├── README.md
│       ├── Taskfile.yml
│       ├── next.config.mjs
│       ├── package.json
│       ├── postcss.config.mjs
│       ├── public -> ../../packages/cms/public/
│       ├── src
│       ├── tailwind.config.ts
│       └── tsconfig.json
├── bun.lockb
├── bunfig.toml
├── compose.yml
├── docs
│   └── intro.md
├── flake.lock
├── flake.nix
├── graphql.config.ts
├── nix
│   └── default.nix
├── package.json
├── packages
│   ├── _template
│   │   ├── README.md
│   │   ├── Taskfile.yml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── cms
│   │   ├── README.md
│   │   ├── Taskfile.yml
│   │   ├── content
│   │   ├── exports
│   │   ├── package.json
│   │   ├── public
│   │   ├── server.ts
│   │   ├── src
│   │   ├── tina
│   │   └── tsconfig.json
│   ├── ecom
│   │   ├── README.md
│   │   ├── Taskfile.yml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── eslint-config-eslint
│   │   ├── README.md
│   │   ├── config
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── shadcn
│   │   ├── README.md
│   │   ├── Taskfile.yml
│   │   ├── components.json
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   ├── tools
│   │   ├── README.md
│   │   ├── Taskfile.yml
│   │   ├── exports
│   │   ├── package.json
│   │   ├── src
│   │   └── tsconfig.json
│   └── ui
│       ├── README.md
│       ├── Taskfile.yml
│       ├── exports
│       ├── package.json
│       ├── src
│       └── tsconfig.json
└── workspaces
    └── 001-w3yz.code-workspace
```
