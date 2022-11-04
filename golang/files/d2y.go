package main

import (
	"fmt"
)

func main() {

	exchange_rate := 150.27

	dollar := 249

	fmt.Printf("%v dollars is %v yen\n", dollar, float64(dollar)*exchange_rate)

}
