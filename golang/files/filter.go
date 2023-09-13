package main

import "fmt"

func Filter(s [] int, fn func(int) bool) []int {
	ret := make([]int, 0)

	for _, elem := range s {
		if fn(elem) {
			ret = append(ret, elem)
		}
	}
	return ret
}

func even(n int) bool {
	if n % 2 == 0 {
		return true
	}
	return false
}

func main() {
	ret := Filter([]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, even)

	for _, elem := range(ret) {
		fmt.Println(elem)
	}
}