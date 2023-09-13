package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan string)
	go func() {
		time.Sleep(5 * time.Second)
		fmt.Printf("Received: %s\n", <-ch)
	}()

	message := "hello"

	fmt.Printf("Sending %s\n", message)
	ch <- message

	fmt.Println("sent")
}