package main

import "fmt"

func getCmd(c chan string) {
	fmt.Println(<-c)
}

func main() {
	c := make(chan string)
	// c <- "hello" // This will result in a deadluck - must use goroutines!

	go func() {
		c <- "hello"
	}()

	getCmd(c)
	// msg := <-c
	// fmt.Println(msg)
}
