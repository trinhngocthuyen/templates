import click


@click.group()
@click.version_option(package_name='{{name}}')
def main():
    pass


if __name__ == '__main__':
    main()
