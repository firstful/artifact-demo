package main

import (
	"fmt"
	"os"
)

// version is injected at build time via -ldflags "-X main.version=<sha8>".
var version = "dev"

func main() {
	msg := fmt.Sprintf("hello from gitea artifact %s", version)
	if len(os.Args) > 1 && os.Args[1] == "--version" {
		fmt.Println(version)
		return
	}
	fmt.Println(msg)
}
