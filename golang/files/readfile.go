package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func Load(file *string) ([]byte, error) {
	data, err := os.ReadFile(*file)

	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return nil, err
	}

  return data, nil
}

func main() {
	file := flag.String("file", "", "JSON file containg systems to import")
	flag.Parse()

	if *file == "" {
		os.Exit(1)
	}

	data, err := Load(file)

	if err != nil {
		os.Exit(1)
	}
	for _, line := range strings.Split(string(data), "\n") {

		fmt.Println(line)

	}



}