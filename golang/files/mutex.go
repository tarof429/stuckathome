package main

import (
	"fmt"
	"sync"
	"time"
)

type Info struct {
	mu sync.Mutex
	name string
}

func (i * Info) Update(name string) {
	i.mu.Lock()
	fmt.Printf("Locking: %s\n", name)
	time.Sleep(time.Second * 1)
	i.name = name
	fmt.Println("Unlocking")
	i.mu.Unlock()
}

func (i * Info)GetName() string {
	return i.name
}

func main() {
	var i Info

	i.Update("mary")
	go func() {
		fmt.Println("Updating name")
		i.Update("george")
	}()
	i.Update("mary")
	time.Sleep(time.Second * 1)

	fmt.Println(i.GetName())
}