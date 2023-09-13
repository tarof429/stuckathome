package main

import (
	"fmt"
)

// This example has two parts: a producer and consumer

func main() {
	const MAX int = 100

	keys := make(chan int)

	// Since the channel is unblocked, we should keep reading from it
	// unti there is nothing left.
	go func() {
		for {
			fmt.Print(<-keys, " ")
		}
	}()

	// The producer takes advantage of the fact that a
	// select statement chooses each clause randomly.
	for i := 0; i < MAX; i++ {
		select {
		case keys <- 0:
		case keys <- 1:
		}
	}
}
