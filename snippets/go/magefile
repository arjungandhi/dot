//go:build mage

package main

import (
	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
)

func Test() error {
	mg.Deps(Install)
	mg.Deps(Proto)
	// ideally we would use variadic args here, but mage doesn't support it.
	// see https://github.com/magefile/mage/issues/340 for disccusion
	return sh.RunV("go", "test", "-v", "./...")
}

func Install() error {
	return sh.RunV("go", "mod", "tidy")
}

func Proto() error {
	return sh.RunV("protoc", "--go_out=.", "--go_opt=paths=source_relative", "--go-grpc_out=.", "--go-grpc_opt=paths=source_relative", "proto/magellan.proto")
}

func Run(what string) error {
	mg.Deps(Install)
	mg.Deps(Proto)
	return sh.RunV("go", "run", what)
}
