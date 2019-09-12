.PHONY: build

HASH        := $(shell git rev-parse --short=10 HEAD)
MSG         := $(shell git log --format=%B -n 1 HEAD)

# updates public dir with latest source files. pushes commits to remote
build:
	hugo
	cd public && git add -u && git commit -m 'update build with $(MSG) ($(HASH))' && git push
	git add public && git commit -m 'update public submodule' && git push
