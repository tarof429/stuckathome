package main

import "fmt"

type Any interface {}
type Anything struct {}

func main() {
    any := getAny()
	fmt.Printf("%T\n", any)
    if any == nil {
        fmt.Println("any is nil")
    } else {
        fmt.Println("any is not nil")
    }
}

func getAny() Any {
    return getAnything()
}
func getAnything() *Anything {
    return nil
}