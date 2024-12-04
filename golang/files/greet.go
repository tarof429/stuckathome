package main

import (
	"fmt"
	"strconv"
)

type name struct {
	firstName string
	lastName  string
	age       int
}

func (n name) greet() string {
	return "Hi, my name is " + n.firstName + " " + n.lastName + " and I am " + strconv.Itoa(n.age)
}

func main() {
	p := name{"Mary", "Pierce", 26}
	fmt.Println(p.greet())
}
