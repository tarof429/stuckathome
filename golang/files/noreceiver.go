package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan int)
	go write(ch1)
	go read(ch1)

	time.Sleep(1e9)
}

func write(ch chan int) {
	for i := 0; i < 10; i++ {
		ch <- i
	}
}

func read(ch chan int) {
	for {
		fmt.Println(<-ch)
	}
}