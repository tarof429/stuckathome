package main

import (
	"fmt"
)

// Second example that puts things in a buffered channel. Because the channel is buffered,
// We the channel is blocked only when the buffer is full.
func main() {
	const MAX int = 100

	keys := make(chan int, MAX)

	for i := 0; i < MAX; i++ {
		select {
		case keys <- 0:
		case keys <- 1:
		}
	}

	// Buffer is full, now print
	for i := 0; i < MAX; i++ {
		fmt.Print(<-keys, " ")
	}
}
