package main

import (
	"fmt"
)

func main() {
	a := "hippo"
	var p = &a

	fmt.Println(*p)
}
