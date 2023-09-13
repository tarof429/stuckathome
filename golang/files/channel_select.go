package main

import (
	"fmt"
	"time"
)

func main() {
	status := make(chan string)
	message := make(chan string)

	statusFunc := func() {
		status <- "ready"
	}

	messageFunc := func() {
		message <- "All actions done"
	}

	go statusFunc()
	go messageFunc()

	go func(ch1 chan string, ch2 chan string) {
		for {
			select {
			case v := <- ch1:
				fmt.Printf("Received status: %s\n", v)
			case v:= <- ch2:
				fmt.Printf("Received message: %s\n", v)
			}
		}
	}(status, message)

	time.Sleep(1 * time.Second)
}