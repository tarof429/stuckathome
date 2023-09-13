package main

import (
	"fmt"
	"strings"
)

func main() {
	url := "http://www.foo.com"

	fmt.Println(strings.HasPrefix(url, "http")) // true

	fmt.Println(strings.HasSuffix(url, ".com")) // true

	fmt.Println(strings.Contains(url, "foo")) // true

	fmt.Println(strings.Index(url, "//")) // 5

	fmt.Println(strings.Replace(url, "foo", "goo", 1)) // http://www.goo.com

	fmt.Println(strings.Repeat("-", 50))

	server := "server-Rack-5-Rack-Unit-10"

	fmt.Println(strings.Contains(strings.ToLower(server), "rack-5"))

	ip := " 192.168.1.100 "

	strings.Contains(strings.TrimSpace(ip), "192.168.1")
}