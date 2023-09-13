package main

import (
	"fmt"
	"time"
)

// Phone represents a cell phone
type Phone struct {
	ID      int
	Brand   string
	Model   string
	Color   string
	Ranking int
	Seller  string
	Price   float64
	DoI     time.Time
	Dude
}

func setColorOfPhone(phone * Phone, Color string) {
	phone.Color = Color
}

// Fields representing a dude
type Dude struct {
	FirstName string
	LastName  string
	Age       int
}

func main() {
	iphone := &Phone{
		ID:      100,
		Brand:   "Apple",
		Model:   "IPhone SE",
		Color:   "Silver",
		Ranking: 29,
		Seller:  "Apple",
		Price:   399.0,
		DoI:     time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC),
		Dude:    Dude{FirstName: "Steve", LastName: "Jobs", Age: 41},
	}

	setColorOfPhone(iphone, "Red")


	// Print the value of the iPhone
	fmt.Println(iphone.Color)
}