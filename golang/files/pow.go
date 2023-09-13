package main

import (
	"fmt"
	"math"
)

func Compose(f, g float64) func(x float64) float64 {
    return func(x float64) float64 { // closure
        return math.Pow(math.Pow(f,g),x)
    }
}

func main() {
    fmt.Print(Compose(4,2)(3)) 
}