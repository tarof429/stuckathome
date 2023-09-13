package main

import "fmt"

var Days = map[int]string{1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"} // do initialization here

func findDay(n int) string {
	if _, val := Days[n]; val {
		return Days[n]
	}
	return "Wrong Key"
}

func main() {
	
	fmt.Println(findDay(0))	
}