install:
	which pre-commit &> /dev/null || pip3 install pre-commit
	pre-commit install
	bundle install
	bundle exec pod install

format:
	pre-commit run --all-files
