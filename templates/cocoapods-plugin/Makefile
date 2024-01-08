install:
	which pre-commit &> /dev/null || pip3 install pre-commit
	pre-commit install
	bundle install

format:
	pre-commit run --all-files

test:
	bundle exec rspec

ex.install:
	cd examples && make install

sub:
	pip3 show jinja2 &> /dev/null || pip3 install jinja2
	python3 scripts/sub.py --name ${NAME}
