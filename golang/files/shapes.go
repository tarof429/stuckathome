package main

import "fmt"

type Square struct {
	side float32
}

type Triangle struct {	// implement this struct
	base, height float32	
}


type AreaInterface interface {
	Area() float32
}

type PeriInterface interface { // implement this interface 
	Perimeter() float32
}

func main() {
	var areaIntf AreaInterface
	var periIntf PeriInterface

	sq1 := new(Square)
	sq1.side = 5
	tr1 := new(Triangle)
	tr1.base = 3
	tr1.height = 5

	areaIntf = sq1
	fmt.Printf("The square has area: %f\n", areaIntf.Area())

	periIntf = sq1
	fmt.Printf("The square has perimeter: %f\n", periIntf.Perimeter())

	areaIntf = tr1
	fmt.Printf("The triangle has area: %f\n", areaIntf.Area())
}

func (sq *Square) Area() float32 {
	return sq.side * sq.side
}

func (sq *Square) Perimeter() float32 { // implement method called on square to calculate its perimeter
	return sq.side * 4
}

func (tr *Triangle) Area() float32 { // implement method called on triangle to calculate its area
	return 0.5 * (tr.base * tr.height)
}