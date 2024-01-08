# Project Templates

## Usage

To install a given template:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t <TEMPLATE_NAME> -s <SUBSTITUTE_CONTENT>
```

For example, to create a CocoaPods plugin named `cocoapods-foo`:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t cocoapods-plugin -s '{"name": "cocoapods-foo"}'
```

## Available Templates

#### py-package
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t py-package -s '{"name": "foo"}'
```

#### rb-gem
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t rb-gem -s '{"name": "foo"}'
```

#### cocoapods-plugin
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t cocoapods-plugin -s '{"name": "foo"}'
```

### linters
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ -t linters
```