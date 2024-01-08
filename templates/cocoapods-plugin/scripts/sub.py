#!/usr/bin/env python3
import fnmatch
from argparse import ArgumentParser
from pathlib import Path

import jinja2


def render(context: dict):
    def include_path(p: str) -> bool:
        return any(fnmatch.fnmatch(p, pattern) for pattern in file_patterns)

    file_patterns = [
        'lib/*.rb',
        'spec/*.rb',
        'examples/Podfile',
        '*.gemspec',
        '.rubocop.yml',
        '*.md',
    ]
    env = jinja2.Environment(loader=jinja2.FileSystemLoader('.'))
    for path in env.list_templates(filter_func=include_path):
        rendered = env.get_template(path).render(context)
        new_path = jinja2.Template(path).render(context)
        path, new_path = Path(path), Path(new_path)
        new_path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(rendered.strip() + '\n')
        path.rename(new_path)


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--name', required=True, type=str, help='Name of the plugin')
    args = parser.parse_args()
    render(context={'name': args.name})
