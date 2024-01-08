# Project Templates

## Usage

To install a given template:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t <TEMPLATE_NAME> -s <SUBSTITUTE_CONTENT>
```

For example, to create a CocoaPods plugin named `cocoapods-foo`:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t cocoapods-plugin -s '{"name": "cocoapods-foo"}'
```

## Available Templates

#### cocoapods-plugin
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t cocoapods-plugin -s '{"name": "cocoapods-foo"}'
```

### linters
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t linters
```