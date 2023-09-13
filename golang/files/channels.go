package main

import (
	"fmt"
	"time"
)

func main() {
  ch := make(chan string)
  go sendData(ch) // calling goroutine to send the data
  go getData(ch)  // calling goroutine to receive the data
  time.Sleep(time.Second * 1)
  close(ch)
}

func sendData(ch chan string) { // sending data to ch channel
  ch <- "Hello"
  ch <- "my"
  ch <- "name"
  ch <- "is"
  ch <- "Tokyo"
}

func getData(ch chan string) {
  var input string
  for {
    input = <-ch
    fmt.Printf("%s ", input)
  }
}