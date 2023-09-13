package main

import (
	"fmt"
	"sort"
)

func main() {
	drinks := map[string]string{
		"beer": "bière",
		"wine": "vin",
		"water": "eau",
		"coffee": "café",
		"thea": "thé"}
	sdrinks := make([]string, len(drinks))
	ix := 0
	for eng := range drinks {
		sdrinks[ix] = eng
		ix++
	}
	// 0 beer
	// 1 wine
	// 2 water
	// 3 coffee
	// 4 thea

	sort.Strings(sdrinks)
	for _, eng := range sdrinks {
			fmt.Println(eng,":",drinks[eng])
	}

	
}