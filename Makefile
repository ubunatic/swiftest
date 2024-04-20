.PHONY: ⚙️

SWIFT       ?= $(shell find /opt/homebrew/Cellar/swift/*/bin -name swift 2>/dev/null | head -n 1)
SOURCES      = $(shell find Sources -name '*.swift') Package.swift
VERSION      = v1.0.0
NAME         = Swiftest
DEBUG       ?=
BUILD        = debug
BINARY       = .build/$(BUILD)/$(NAME)
RELEASE_TAG  = swiftest-$(VERSION)

export DEBUG

all: ⚙️ test build

clean: ⚙️
	rm -rf .build

test: ⚙️
	$(SWIFT) run -c $(BUILD) TestMain

build: ⚙️ $(SOURCES)
	rm -f $(BINARY)
	$(SWIFT) build -c $(BUILD) --target TestSuites
	$(SWIFT) build -c $(BUILD) --target $(NAME)

release: BUILD=release
release: ⚙️ build
