SHELL := /bin/bash

.PHONY: status-all branch-all pull-all origins-all commit-all

status-all:
	@./scripts/status-all.sh

branch-all:
	@./scripts/branch-all.sh

pull-all:
	@./scripts/pull-all.sh

origins-all:
	@./scripts/origins-all.sh

commit-all:
	@test -n "$(MSG)" || (echo 'Usage: make commit-all MSG="your commit message"' && exit 1)
	@./scripts/commit-all.sh "$(MSG)"
