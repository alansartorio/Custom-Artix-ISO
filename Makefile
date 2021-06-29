.PHONY: build

build: FORCE
	./Bash-Bundler/compile.sh -i install.sh -o installLive.sh

FORCE:
