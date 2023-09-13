package main

import (
	"fmt"
	"strconv"
)


func main() {
	// nameAndAge := "george: " + 30

	nameAndAge := "george: " + strconv.Itoa(30)

	fmt.Println(nameAndAge)

}
