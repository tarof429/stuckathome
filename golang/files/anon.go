package main

import "fmt"

// make struct here
type A struct {
  f float64
  int
  string 
}

func main(){
  // create struct using struct literal and print its field using fmt package
  a := A{11.0, 1, "hello"}
  fmt.Printf("%f %d %s", a.f, a.int, a.string)

}