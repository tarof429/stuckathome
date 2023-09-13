package main

import "fmt"

func main() {
	value := func (a...int) int {
		if len(a) == 0 {
			return 0
		}
		value := a[0]
		for _, v := range a {
			if v < value {
				value = v
			}
		}
		return value
	}(7,9,3,5,1)

	fmt.Printf("%d\n", value)
}