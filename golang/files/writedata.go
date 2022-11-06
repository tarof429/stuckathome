package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
)

func readFile(filename string) []byte {
	data, err := ioutil.ReadFile("hello.txt")

	if err != nil {
		panic("Unable to read file")
	}
	return data
}

func writeFile(fname string, content string) {

	file, err := os.Create(fname)

	if err != nil {
		panic("Unable to write to file")
	}
	_, err = io.WriteString(file, content)

	if err != nil {
		panic("Unable to write to file")
	}

	defer file.Close()
}

func main() {
	fname := "./hello.txt"
	content := "Hello from\ngo!"

	writeFile(fname, content)

	data := readFile(fname)

	// The *split*() method can parse byte arrays
	for _, line := range strings.Split(string(data), "\n") {
		fmt.Println(line)
	}
}
