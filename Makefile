
CWD=$(shell pwd)
PLATFORM=$(shell "$(CWD)"/scope_env.sh platform)
VERSION=$(shell git describe --abbrev=0 --tags | tr -d v)
$(shell echo -n $(VERSION) > $(CWD)/cli/VERSION)

ifeq ($(PLATFORM),Linux)
	include os/linux/Makefile
	include cli/Makefile
else
	ifeq ($(PLATFORM),macOS)
		include os/macOS/Makefile
	else
$(info ERROR not a valid platform: "$(PLATFORM)")
endif
endif

ifeq ($(PLATFORM),Linux)

.PHONY: clean test all

clean:
	$(MAKE) -f os/linux/Makefile core$@
	$(MAKE) -f cli/Makefile cli$@

test:
	$(MAKE) -f os/linux/Makefile core$@
	$(MAKE) -f cli/Makefile cli$@

all:
	$(MAKE) -f os/linux/Makefile core$@
	$(MAKE) -f cli/Makefile cli$@
endif
