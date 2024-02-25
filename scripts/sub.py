#!/usr/bin/env python3
import json
from argparse import ArgumentParser
from functools import cached_property
import logging
import os
import shutil
from pathlib import Path
import typing as t

import jinja2

logger = logging.getLogger()


def non_empty_input(msg: str) -> str:
    value = ''
    while value == '':
        value = input(msg).strip()
    return value


class Main:
    def __init__(self, **kwargs) -> None:
        self.name: str = kwargs.get('name')
        self.dir: Path = Path(kwargs.get('dir'))
        self.replace: str = kwargs.get('replace')
        self.templated_paths: t.List[t.Tuple[Path, Path]] = []

    @cached_property
    def metadata(self) -> t.Dict[str, t.Any]:
        path = Path(__file__).parent.parent / f'metadata/{self.name}.json'
        return json.loads(path.read_text())

    @cached_property
    def jinja_env(self) -> jinja2.Environment:
        return jinja2.Environment(loader=jinja2.FileSystemLoader(self.dir))

    def jinja_list_templates(self) -> t.List[str]:
        def include_path(p: str) -> bool:
            return \
                not p.startswith('.git/') \
                and not p.startswith('.github/')
        return self.jinja_env.list_templates(filter_func=include_path)

    def load_replace_ctx(self) -> t.Dict[str, str]:
        try:
            ctx: dict = json.loads(self.replace)
        except:
            ctx = {}

        missing = {k: v for k, v in self.metadata.get('replace', {}).items() if k not in ctx }
        for key, desc in missing.items():
            ctx[key] = non_empty_input(
                f'\033[33mReplacing templated contents requires key: "{key}" ({desc})\n'
                f'\033[35mInput the value for "{key}": \033[0m'
            )
        print(f'-> Replace contents with context: {ctx}')
        return ctx

    def apply_rendered(self, content: str, original_path: Path, new_path: Path):
        new_path.parent.mkdir(parents=True, exist_ok=True)
        original_path.write_text(content.strip() + '\n')
        original_path.rename(new_path)

    def clean_up_templated_dir(self):
        for original_path, new_path in self.templated_paths:
            parent = Path(os.path.commonpath([original_path, new_path]))
            try:
                shutil.rmtree(next(p for p in original_path.parents if p.parent == parent))
            except:
                pass

    def log_caveats(self):
        caveats = self.metadata.get('caveats', [])
        for caveat in caveats:
            logger.warning(f'\033[33m{caveat}\033[0m')

    def run(self):
        ctx = self.load_replace_ctx()
        for path in self.jinja_list_templates():
            try:
                original_path: Path = self.dir / path
                new_path: Path = self.dir / jinja2.Template(path).render(ctx)
                if original_path != new_path:
                    self.templated_paths.append((original_path, new_path))
                self.apply_rendered(
                    content=self.jinja_env.get_template(path).render(ctx),
                    original_path=original_path,
                    new_path=new_path
                )
            except:
                pass
        self.clean_up_templated_dir()
        self.log_caveats()


if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('--name', type=str, help='Template name')
    parser.add_argument('--dir', default='.', type=str, help='Dir to sub')
    parser.add_argument('--replace', type=str, help='Content mapping')
    args = parser.parse_args()
    Main(**vars(args)).run()
