# Project Templates

## Installation

Run the following script and follow the prompted instructions.
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/main/scripts/install.sh)"
```
Note: You will be asked to source the ~/.zshrc file to load the CLI. Kindly do so.\
Then, you can use the `templates` CLI (see [the next section](#using-the-cli))

## Using the CLI

| CLI   | Description |
|------------|-------------|
| `templates help` | Print the usage |
| `templates list` | List available templates |
| `templates use <template>` | Use a template |
| `templates update` | Update templates |
| `templates reload` | Reload the CLI |

## Available Templates

| Template   | Description |
|------------|-------------|
| py-package | Create a Python package |
| rb-gem     | Create a Ruby gem |
| cocoapods-plugin | Create a Create a CocoaPods plugin |
| linters    | Set up some linters for your project |
| ios-app    | Create an iOS app project |
