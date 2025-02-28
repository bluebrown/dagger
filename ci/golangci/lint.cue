package golangci

import (
	"dagger.io/dagger"

	"universe.dagger.io/docker"
	"universe.dagger.io/go"

	"github.com/dagger/dagger/ci/git"
)

// Lint using golangci-lint
#Lint: {
	// Source code
	source: dagger.#FS

	// golangci-lint version
	version: *"1.45" | string

	// timeout
	timeout: *"5m" | string

	_image: docker.#Pull & {
		source: "golangci/golangci-lint:v\(version)"
	}

	// update git worktree source
	_source: git.#Worktree & {"source": source}

	run: go.#Container & {
		source: _source.output
		image:  _image.output
		command: {
			name: "golangci-lint"
			flags: {
				run:         true
				"-v":        true
				"--timeout": timeout
			}
		}
	}
}
