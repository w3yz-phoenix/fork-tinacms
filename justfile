monorepo-root := {{justfile_directory()}}
bun := "bun --bun"
bun-apps := "bun --bun --filter=@w3yz-app/*"
bun-packages := "bun --bun --filter=@w3yz/*"

default:
    echo 'Hello, world!'

build: ## Build the app
    # {{bun-apps}} run build
    @echo "{{monorepo-root}}"

collect target="dist":
    mkdir -p "{{target}}"
    bun --bun --filter="@w3yz-app/*" x mv .next/ 
