package main

import (
	"fmt"
	"sort"
)

func main() {
	ips := make(map[string]string)
	ips["gorilla"] = "host1"
	ips["monkey"] = "host2"
	ips["pen"] = "host3"
	ips["apple"] = "host4"

	// fmt.Println(ips)
	// delete(ips, "192.168.2.1")

	keys := make([]string, len(ips))
	i := 0

	for ip := range ips {
		keys[i] = ip
		i++
	}

	sort.Strings(keys)

	for i := range keys {
		fmt.Println(ips[keys[i]])
	}

}
