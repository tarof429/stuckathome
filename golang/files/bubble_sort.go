package main

import "fmt"

func bubbleSort(sl []int) []int{
	// passes through the slice:
	for pass:=1; pass < len(sl); pass++ {
		// one pass:
		for i:=0; i < len(sl) - pass; i++ {		// the bigger value 'bubbles up' to the last position 
			if sl[i] > sl[i+1] {
				sl[i], sl[i+1] = sl[i+1], sl[i]
			}
		}
	}

	return sl
}

func main() {
	ret := bubbleSort([]int{1,2,3,1})

	for _, val := range ret {
		fmt.Println(val)
	}
}