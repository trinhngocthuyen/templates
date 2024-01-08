#!/usr/bin/env python3
import json
from argparse import ArgumentParser
from pathlib import Path

import jinja2


def sub_content(dir: str, context: dict):
    print(f'-> Substitute content with context: {context}')
    def include_path(p: str) -> bool:
        return not p.startswith('.git')

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(dir))
    for path in env.list_templates(filter_func=include_path):
        try:
            rendered = env.get_template(path).render(context)
            new_path = jinja2.Template(path).render(context)
            path = Path(dir) / path
            new_path = Path(dir) / new_path
            new_path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(rendered.strip() + '\n')
            path.rename(new_path)
        except:
            pass


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--dir', default='.', type=str, help='Dir to sub')
    parser.add_argument('--map', required=True, type=str, help='Content mapping')
    args = parser.parse_args()
    sub_content(dir=args.dir, context=json.loads(args.map))