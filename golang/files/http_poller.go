package main

import (
	"fmt"
	"net/http"
)


func main() {
	url := "http://www.google.com"

	resp, err := http.Head(url)

	if err != nil {
		fmt.Println("Error: ", url)
	}

	fmt.Println("Status: ", resp.Status)
}