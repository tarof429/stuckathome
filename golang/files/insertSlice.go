package main

import "fmt"

func insertSlice(slice, insertion []string, index int) []string {
    
	dest := make([]string, len(slice) + len(insertion))
	
	n := copy(dest, slice[0:index])
	n += copy(dest[n:], insertion)
	copy(dest[n:], slice[index:])

	return dest
}

func main() {
	slice := []string{"a", "b", "c"}
	insertion := []string{"x", "y"}
	ret := insertSlice(slice, insertion, 1)

	fmt.Println(ret)
}