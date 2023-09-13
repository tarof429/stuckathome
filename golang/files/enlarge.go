package main

import "fmt"

func enlarge(s []int, factor int) []int {
	var dest[] int = make([]int, len(s) * factor)
	
	fmt.Println(dest)

	copy(dest, s)
	return dest
}

func main() {
	ret := enlarge([]int{1, 2, 3}, 5)

	fmt.Println(ret)
}