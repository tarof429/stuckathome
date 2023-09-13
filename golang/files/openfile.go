package main

import (
	"errors"
	"fmt"
	"os"
)

func main() {
	if err := openConfig("hello.txt"); err != nil {
		panic(err.Error())
	}

	fmt.Println("Never gets here")
}

func openConfig(fname string) error {
	f, err := os.Open(fname)
	defer f.Close()

	if err != nil {
		return errors.New("Unable to open config file")
	}
	return nil
}