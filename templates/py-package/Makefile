install:
	python3 -m pip install virtualenv
	python3 -m virtualenv .venv
	. .venv/bin/activate && pip install -r requirements.txt

test:
	. .venv/bin/activate && pytest

format:
	. .venv/bin/activate && \
		pre-commit run --all-files

doc:
	. .venv/bin/activate && \
		cd docs && \
		rm -rf api/{{name}}* && \
		sphinx-apidoc \
			--implicit-namespaces \
			--force \
			--module-first \
			--templatedir=_templates/apidoc \
			--output-dir api \
			../src/{{name}} && \
		rm -rf api/modules.rst && \
		make clean html

doc.up: doc
	python3 -m http.server --directory docs/_build/html
