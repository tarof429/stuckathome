package main

import "fmt"

func reverse(s string) string {
	// var ret[]byte

	// for i := len(s) - 1; i >= 0; i-- {
	// 	ret = append(ret, byte(s[i]))
	// }

	ret := []byte(s)

	for i, j := 0, len(s) -1; i < j; i, j = i + 1, j - 1 {
		ret[i],ret[j] = ret[j], ret[i]
	}
	
	return string(ret)

}

func main() {
	ret := reverse("hello")

	fmt.Println(ret)

}