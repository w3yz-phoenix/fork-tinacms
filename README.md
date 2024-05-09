# W3YZ

## Pre-requisites

You will need to have nix installed in your system.

A more detailed installation guide can be found [here](https://zero-to-nix.com/concepts/nix-installer).

Or if you want a more automated installation process, you can use [this nix-config](https://github.com/yasinuslu/nepjua)

You can do this by running the following command:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Development

Clone the repository:

```bash
git clone git@github.com:w3yz-phoenix/w3yz.git
```

Enter the project directory:

```bash
cd w3yz
```

Once you're in the project directory, nix will automatically install all the dependencies you need node, bun, etc...

Then you can run the following command to start the development server:

```bash
bun install
task watch dev
```

## TODOS

- [ ] Remove path alias for #shadcn and actually use the package
- [ ] Remove path alias for #web and make sure noone depends on web package
- [ ] Remove path alias for #ui and actually use the package
