.PHONY: ⚙️

SDK          = $(shell ls -d /opt/homebrew/Cellar/swift/* | head -n 1)
SWIFT        = $(shell find $(SDK) -name swift 2>/dev/null | head -n 1 || echo swift)
SOURCES      = $(shell find Sources -name '*.swift') Package.swift
VERSION      = v0.0.1
NAME         = Swiftest
DEBUG       ?=
BUILD        = debug
BINARY       = .build/$(BUILD)/$(NAME)
RELEASE_TAG  = swiftest-$(VERSION)

export DEBUG

all: ⚙️ test build

clean: ⚙️
	rm -rf .build

test: ⚙️ build
	$(SWIFT) run swiftest
	$(SWIFT) run TestMain

build: ⚙️ $(SOURCES)
	rm -f $(BINARY)
	$(SWIFT) build -c $(BUILD) --disable-sandbox

release: BUILD=release
release: ⚙️ build
