# Golang Notes

## Table of Contents

1. [Introduction](#introduction)
2.  [Basics](#basics)
    1. [Packages](#packages)
	2. [Variables](#variables)
	3. [Flow control statements](#flow-control-statements)

		3.1 [For statements](#for-statement)

		3.2 [If statements](#if-statement)

		3.3 [Switch statements](#switch-statement)
		
		3.4 [Defer statements](#defer-statement)
	4. [Pointers](#pointers)
	5. [Structs](#structs)
	6. [Arrays](#arrays)
	7. [Slices](#slices)
	8. [Maps](#maps)
	9. [Functions](#functions)
	10. [Methods](#methods)
	11. [Interfaces](#interfaces)
	11. [Files](#files)
3. [Advanced](#advanced)
    1. [Goroutines](#goroutines)
	2. [Channels](#channels)
    3. [Closures](#closures)
	4. [Web](#web)
	5. [Json](#json)
	6. [Commands](#commands)
	7. [Testing](#testing)
	8. [Error handling](#error-handling)
	9. [Logging](#logging)
	10. [Networking](#networking)
	11. [Times and Dates](#timesanddates)
	12. [Internals](#internals)
	13. [Random](#random)
	14. [Data Structures](#datastructures)
	15. [User Input](#userinput)
	16. [Bytes](#bytes)
	17. [String](#string)
	18. [Gobs](#gobs)
3. [References](#references)

---
## [Introduction](#introduction)

Go:

- Originated at Google in 2007, with version 1.0 releaesd in 2012.

- Ranks as one of the top lanaguages

- Influenced by many popular languages, such as C, Java, C#

- Has fast compilation times

- Promotes rapid development

- Supports modern computing environments, including concurrency and memory management

- Easy to learn and use, and unlike C++, does not have classes

- Is a functional language

- Statically typed, making it a safe language

- Supports cross-compilation

Unlike C++, Go does not have operator overloading. 


## [Basics](#basics)

### [Packages](#packages)

Every Go program is made up of packages. The package that starts running programs is in package *main* and it should have a function called main().

```go
package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello world!")
}
```

To run:

```go
go run hello.go
```

To build:

```go
go install
```

The compiled executable will be placed under GOPATH/bin.

Imports are typically declared within parentheses. This is called a factored import statement.

```go
import (
	"fmt"
	"math"
)

func main() {
	var name = "Taro"
	var age = 37
	var length = 140.1

	fmt.Println(name, "is", age, "and", math.Floor(length), "and", math.Ceil(length))
	fmt.Printf("%T %T %T\n", name, age, length)
}
/*
Taro is 37 and 140 and 141
string int float64
*/
```

The name of methods must be capitalized to be accessible from other packages. Such methods are said to be *exported*.

```go
func main() {
	fmt.Println(math.Pi) // and not math.pi
}
```

To create our own package, create a file under GOPATH (for example, /home/taro/go/src/github.com/tarof429/go_crash_course/03_packages/strutil/reverse.go) and add our code. The function needs to be capitalized.

```go
package strutil

func Reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}
```

Then to use it within our code:

```go
import (
	"fmt"

	"github.com/tarof429/go_crash_course/03_packages/strutil"
)

func main() {
	var greet = "hello"
	fmt.Println(strutil.Reverse(greet))
}
```

Importing a package which is not used results in a build error.

### [Variables](#variables)

The var statement is used to declare variables. The type follows the variable name.

```go
func main() {
	var name string = "Taro"

	fmt.Println(name)
}
```

The go compiler will warn that the type is inferred to be string, so actually we don't need to specify the type in this case. Next we can create a variable of type int.

```go
func main() {
	var name = "Taro"
	var age = 37

	fmt.Println(name, "is", age)
}
// Taro is 37
```

To print the variable type, use %T.

```go
fmt.Printf("%T %T\n", name, age)
// string int
```

The keyword *var* is required only if declaring variables outside of a function.

```go
// From calculate_change.go

var remainder int

func getChange(coin int, value int) (change int, remainder int) {
	var minValue = 1

	if value < minValue {
		fmt.Println("No value!")
		return
	}

	change = coin / value
	remainder = coin % value

	return
}

func calculateChange(quarters int) (dimes int, nickels int, pennies int) {

	// The message that we want to print
	var message string

	// Get the number of dimes
	dimes, remainder = getChange(quarters, 10)

	// Get the number of nickels
	if remainder > 0 {
		nickels, remainder = getChange(remainder, 5)
	}

	// The remainder is the number of pennies that we have
	pennies = remainder

	if dimes > 0 && nickels > 0 && pennies > 0 {
		message = "All three coins!"
	} else {
		message = "Not all three coins!"
	}

	fmt.Println(message)

	return
}

func main() {

	dimes, nickels, pennies := calculateChange(45)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(78)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(7)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)

	dimes, nickels, pennies = calculateChange(0)

	fmt.Println("dimes, nickels, pennies: ", dimes, nickels, pennies)
}
/* 
Output:
Not all three coins!
dimes, nickels, pennies:  4 1 0
All three coins!
dimes, nickels, pennies:  7 1 3
Not all three coins!
dimes, nickels, pennies:  0 1 2
Not all three coins!
dimes, nickels, pennies:  0 0 0
*/
```

Constants are declared with the const keyword. Constants can be character, string, boolean, or numeric values. 

Constants cannot be declared using the `:=` syntax.

Go does not perform implicit type conversion when performing mathematical operations. For example: 

```go
i := 10
f := 3.0

// This will result in an error
fmt.Printf("Sum: %v\n", i + f)
```

To fix this, we must convert the type by calling a function.

```go
var i int = 10
var f float64 := 3.0

fmt.Printf("sum: %v\n", float64(i) + f)
```

You can run into precision issues when performing floating point arithmetic.

```go
f1, f2, f3 := 8.1, 1.3, 9.1356
floatSum := f1 + f2 + f3
fmt.Println("Float sum: ", floatSum) // Prints  18.535600000000002
```

To fix this, use math.Round().

```go
fmt.Println("Float sum: ", math.Round(floatSum)) // Prints 19
// 	fmt.Println("Float sum: ", math.Round(floatSum*10)/10) will give you one digit of precision
```

#### Short variable declaration

Inside a function, *\:\=* can be used in place of using *var* to declare variables. The type is implicit.

```go
func main() {
	var i, j int = 1, 2
	k := 3 // shorthand
	c, python, java, golang := true, false, "no!", "yess!!"

	fmt.Println(i, j, k, c, python, java, golang)
}
```

#### Declaring variables within blocks

Multiple variables can be *factored* into blocks.

```go
var (
	status      bool
	message     string
	exitCode    int
	testsPassed int
	testsFailed int
)

func main() {

	status = true
	message = "All tests passed"
	exitCode = 0
	testsPassed = 30
	testsFailed = 0

	fmt.Println(status, message, exitCode, testsPassed, testsFailed)

	status = false
	message = "Tests failed"
	exitCode = 1
	testsPassed = 29
	testsFailed = 1

	fmt.Println(status, message, exitCode, testsPassed, testsFailed)
}
```

#### Zero Values

Variables have zero values which means a default value if none is assigned to them. That is, ints and floats default to 0, bool defaults to false, and a string defaults to an empty string.

```go
var (
	status      bool
	message     string
	exitCode    int
	testsPassed int
	testsFailed int
)

func main() {

	fmt.Println(status, message, exitCode, testsPassed, testsFailed)

}
// false  0 0 0
```

#### Constants

Constants can be defined using the *const* keyword. Its value cannot be changed and you will get a comple-time error if you attempt to do so.

```go
const pi = 3.14

func main() {
	radius := 7.0

	area := pi * radius * radius

	fmt.Println("Area of cirlce: ", area)

}
```

We can declare multiple constants within () much like import statements.

```go
const (
	Monday = 0
	Tuesday = 1
)
```

Constants cannot be assigned to the return value of functions.


```go
// Build error
const x = getAnswer()
```

#### Global Variables

Go supports global variables, which are variables declared outside of a function. Global variables need to be defined with the `var` keyword instead of the \:\= shortcut.

```go
var message = "Hello"


func main() {
	fmt.Println(message)
}
```

### Interpreted strings vs raw strings

Most of the time, we deal with "interpreted strings", or strings defined with double quotes such as:

```go
var message = "Hello World"
```

There is another type of string called "raw strings". Unlike languages like Python, these are defined not with single quotes but with back quotes or back ticks. Everything within the back ticks will be printed.

```go
var message = `This is a raw message\n` // Returns Hello world!\n
```

### Useful string functions

The `strings` package has several useful functions which are explored in `strings.go`

The are a few functions in the `strconv` package which are also useful; these are explored in `convert.go`.

### [Flow control statements](#flow-control-statements)

#### [For statement](#for-statement)

Go has only one looping construct, the *for* loop. This is in contrast to other languages such as Python, which also has as a *while* loop. 

```go
package main

import "fmt"

func main() {
	for i := 0; i < 10; i++ {
		fmt.Println("Hello world!")
	}
}
```

Breaking down the for statement, we have three parts: init, condition, and post. Of these, only the middle (condition) is required, and semicoons are unnecessary.

```go
	i := 0
	for i < 10 {
		fmt.Println("Hello world!")
		i++
    }
```

Without the conditional statement, we will end up with an infinite loop. It is up to the programmer to break out of the loop.

```go
	i := 0
	for {
		fmt.Println("Hello world!")
		i++

		if i > 10 {
			break
		}
    }
```

Below is an implementation of fizzbuzz, which is described below (courtesy of https://wiki.c2.com/?FizzBuzzTest):

```go
/* 
Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”.
*/
func main() {
	for i := 1; i <= 100; i++ {
		if i%15 == 0 {
			fmt.Println("fizzbuzz")
		} else if i%3 == 0 {
			fmt.Println("fizz")
		} else if i%5 == 0 {
			fmt.Println("buzz")
		} else {
			fmt.Println(i)
		}
	}
}
```

The output of the following:

```go
func main() {
  var out int
  
  for j:=0; j < 20; j++ {
    out=j*j + out
    if out > 12 {
      goto theEnd 
     }  
  }
  theEnd: fmt.Println(out)  
}
```

is

```go
j = 0
out = 0 * 0 * out = 0

j = 1
out = 1 * 1 + 0 = 1

j = 2
out = 2 * 2 + 1 = 5

j = 3
out = 3 * 3 + 5 = 14

// Result is 14
```

In the following example, the result is `0 0 0 0 0` since v is initialized to 0 with each iteration.

```go
	for i := 0; i < 5; i++ {
		var v int
		fmt.Printf("%d ", v)
		v = 5
	  }
```

#### [If statement](#if-statement)

If statements evaluate some condition; unlike some languages, the body needs to be defined inside curly braces.

```go
func main() {
	var x = 10
	var y = 20

	if x < y {
		fmt.Println("x is less than y")
	}
}
```

Below is another example of if statements as used within a function.

```go
func divide(x float64, y float64) string {
	if y != 0 {
		return fmt.Sprint(x / y)
	}
	return "Unable to divide by zero"
}
```

Multiple if else statements can be chained as in other languages.

```go
func menu(choice string) string {
	if choice == "Y" {
		return "You have entered Y"
	} else if choice == "N" {
		return "You have entered N"
	} else if choice == "Q" {
		return "You have entered Q"
	} else {
		return "Invalid choice"
	}
}
```

#### [Switch statement](#switch-statement)

Switch statements can be used to evaluate a variable. The switch statement breaks automatically after the first match. The code below initializes and evaluates the `arch` variable.

```go
func findOS() {
	fmt.Print("Go runs on ")
	switch arch := runtime.GOARCH; arch {
	case "amd64":
		fmt.Println("AMD64.")
	case "sparc64":
		fmt.Println("Sparc64.")
	default:
		// others
		fmt.Printf("%s.\n", arch)
	}
}
```

Another example:

```go

func whenIsFriday() {

	currentday := time.Now().Weekday()

	switch string(currentday) {

	case "Friday":
		fmt.Println("Today is Friday!")
	case "Thursday":
		fmt.Println("Tomorrow is Friday!")
	case "Saturday":
		fmt.Println("Yesterday was Friday!")
	default:
		fmt.Println("Not today!")
	}
}
```

Another variation, where the evaluation is done in each case statement:

```go
func whenIsFriday() {

	currentday := time.Now().Weekday()

	switch {
	case string(currentday) == "Friday":
		fmt.Println("Today is Friday!")
	case string(currentday) == "Thursday":
		fmt.Println("Tomorrow is Friday!")
	case string(currentday) == "Saturday":
		fmt.Println("Yesterday was Friday!")
	default:
		fmt.Println("Not today!")
	}
}
```

There is a `fallthrough` keyword that can be used with the `switch` statement, which tells Go to evaluate the next switch block.

```go
func main() {
	k := 6
	switch k {
	  case 4: fmt.Println("was <= 4"); fallthrough;
	  case 5: fmt.Println("was <= 5"); fallthrough;
	  case 6: fmt.Println("was <= 6"); fallthrough;
	  case 7: fmt.Println("was <= 7"); fallthrough;
	  case 8: fmt.Println("was <= 8"); fallthrough;
	  default: fmt.Println("default case")
	}
// was <= 6
// was <= 7
// was <= 8
// default case

```

#### [Defer Statements](#defer-statement)

A defer is a way to push statements onto a stack. Execution is delayed untill the code outside has completed.

```go
func willIGetAnInterview(day string) string {
	opportunity := "Unknown"

    defer fmt.Println("Checking with the recruiter...")
    
    defer fmt.Println("Checking what day it is...")

	switch day {
	case "Tuesday":
		opportunity = "Probably"
	default:
		opportunity = "Probably not"
	}

	return opportunity
}
/*
Checking what day it is...
Checking with the recruiter...
Probably
*/
```

The defer puts statements onto a stack and is an example of a LIFO. This means that the last statement put on the stack will be evaluated first.

### [Pointers](#pointers)

Pointers in Go are similar to pointers in C. If you want to change the value of a pointer you need to dereferrence it using *\**.

```go
func main() {
	num := 3
	p := &num
	*p = 19
	fmt.Println(num)
}
```

Here's a slight variation:

```go
var x = 13
var p * int
p = &x
*p = 14
fmt.Println(x) // 14
```

Below is an example where we use pointers with a function.

```go
func getMarried(pFirstName *string, pLastName *string, pSpousesLastName *string) {
	fmt.Println(pFirstName, pLastName, pSpousesLastName)

	*pLastName = *pSpousesLastName
}

func main() {
	firstName := "Mary"
	lastName := "Jane"
	spousesLastName := "James"

	getMarried(&firstName, &lastName, &spousesLastName)
	fmt.Println(&firstName, &lastName, &spousesLastName)
	fmt.Println(firstName, lastName)
}
/*
0xc000010210
0xc000010200 0xc000010210 0xc000010220
Mary James
[taro@zaxman golang]$ go run hello.go 
0xc000010200 0xc000010210 0xc000010220
0xc000010200 0xc000010210 0xc000010220
Mary James
*/
```

Below is another example.

```go
func main() {
	a := "hippo"
	var p = &a

	fmt.Println(*p)
}
```

There are two ways to allocate memory. If you use new(), memory is allocated but the space is not initialized. The make() function on the other hand both alocates and initializes memory.

For example:

```go
func main() {
	m := new(map[string]string)
	m["color"] = "red"
	fmt.Println(m)
}
```

This results in a crash. Instead, you want to use the make() function.

```go
func main() {
	m := make(map[string]string)
	m["color"] = "red"
	fmt.Println(m)
}
```

Memory is deallocated automatically by the garbage collector. 


### [Structs](#structs)

A struct is an aggregate data type that groups together zero or more fields. As a simple example, we can consider a struct representing a phone.

```go
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
	price   float64
	DoI     time.Time
}

func main() {
	var iphone Phone
	iphone.ID = 100
	iphone.Brand = "Apple"
	iphone.Model = "IPhone SE"
	iphone.Color = "Silver"
	iphone.Ranking = 29
	iphone.Seller = "Apple"
	iphone.price = 399.0
	iphone.DoI = time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC)

	// Print the value of the iPhone
	fmt.Println(iphone)

	// In December, Apple decided to discount the iPhone to help sales
	iphone.price = 350.0

	// At the same time, the color names were changed to make them more attractive
	// Here, we create a pointer to the iPhone and change its color via pointer.
	pColor := &iphone.Color
	*pColor = "Bright " + *pColor

	// Subsequently, sales increased! We create a pointer to the struct.
	// Accesing fields from the pointer only require the use of dot notation.
	pIphone := &iphone
	pIphone.Ranking = 25

	fmt.Println(iphone)

	// Create another phone from a rival maker
	var samsung = Phone{101, "Sansung", "Galaxy", "Black", 25, "Samsung",
		99.0, time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC)}

	// Compare the iPhone with the Samsung. Comparing structs is supported.
	if iphone == samsung {
		fmt.Println("iPhone and Samsung are the same phone")
	} else if iphone.DoI == samsung.DoI {
		fmt.Println("iPhone and Samsung were released on the same date")
	}

	// Create an instance of a phone but defer assigning values to it
	var unknownBrand = Phone{}

	// Now lets set the brand of our unknown phone
	unknownBrand.Brand = "Unknown"
}
```

Now suppose we want to associate a phone with its owner, so we add some more fields to it.

```go
// Phone represents a cell phone
type Phone struct {
	ID      int
	Brand   string
	Model   string
	Color   string
	Ranking int
	Seller  string
	price   float64
	DoI     time.Time

	// Fields representing a dude
	FirstName string
	LastName  string
	Age       int
}
```

We would access these fields using the dot notation that we've already been using.

But maybe it makes more sense to put these fields in another struct of type *Dude*. This change makes accessing the fields in the Dude struct more verbose.

```go
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
	price   float64
	DoI     time.Time
	Dude    Dude
}

// Fields representing a dude
type Dude struct {
	FirstName string
	LastName  string
	Age       int
}

func main() {
	var iphone Phone
	iphone.ID = 100
	iphone.Brand = "Apple"
	iphone.Model = "IPhone SE"
	iphone.Color = "Silver"
	iphone.Ranking = 29
	iphone.Seller = "Apple"
	iphone.price = 399.0
	iphone.DoI = time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC)
	iphone.Dude.FirstName = "Steve"
	iphone.Dude.LastName = "Jobs"
	iphone.Dude.Age = 41

	// Print the value of the iPhone
	fmt.Println(iphone)

	// In December, Apple decided to discount the iPhone to help sales
	iphone.price = 350.0

	// At the same time, the color names were changed to make them more attractive
	// Here, we create a pointer to the iPhone and change its color via pointer.
	pColor := &iphone.Color
	*pColor = "Bright " + *pColor

	// Subsequently, sales increased! We create a pointer to the struct.
	// Accesing fields from the pointer only require the use of dot notation.
	pIphone := &iphone
	pIphone.Ranking = 25

	fmt.Println(iphone)

	// Create another phone from a rival maker
	var samsung = Phone{101, "Sansung", "Galaxy", "Black", 25, "Samsung",
		99.0, time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC), Dude{"John", "Tesh", 41}}

	// Compare the iPhone with the Samsung. Comparing structs is supported.
	if iphone == samsung {
		fmt.Println("iPhone and Samsung are the same phone")
	} else if iphone.DoI == samsung.DoI {
		fmt.Println("iPhone and Samsung were released on the same date")
	}

	// Create an instance of a phone but defer assigning values to it
	var unknownBrand = Phone{}

	// Now lets set the brand of our unknown phone
	unknownBrand.Brand = "Unknown"
}
```

Go lets us declare a field with no name. Such fields are called *anonymous fields*.

```go
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
	price   float64
	DoI     time.Time
	Dude
}

// Fields representing a dude
type Dude struct {
	FirstName string
	LastName  string
	Age       int
}

func main() {
	var iphone Phone
	iphone.ID = 100
	iphone.Brand = "Apple"
	iphone.Model = "IPhone SE"
	iphone.Color = "Silver"
	iphone.Ranking = 29
	iphone.Seller = "Apple"
	iphone.price = 399.0
	iphone.DoI = time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC)
	iphone.FirstName = "Steve"
	iphone.LastName = "Jobs"
	iphone.Age = 41

	// Print the value of the iPhone
	fmt.Println(iphone)

	// In December, Apple decided to discount the iPhone to help sales
	iphone.price = 350.0

	// At the same time, the color names were changed to make them more attractive
	// Here, we create a pointer to the iPhone and change its color via pointer.
	pColor := &iphone.Color
	*pColor = "Bright " + *pColor

	// Subsequently, sales increased! We create a pointer to the struct.
	// Accesing fields from the pointer only require the use of dot notation.
	pIphone := &iphone
	pIphone.Ranking = 25

	fmt.Println(iphone)

	// Create another phone from a rival maker
	var samsung = Phone{101, "Sansung", "Galaxy", "Black", 25, "Samsung",
		99.0, time.Date(2009, time.November, 10, 23, 0, 0, 0, time.UTC),
		Dude{"John", "Tesh", 41}}

	// Compare the iPhone with the Samsung. Comparing structs is supported.
	if iphone == samsung {
		fmt.Println("iPhone and Samsung are the same phone")
	} else if iphone.DoI == samsung.DoI {
		fmt.Println("iPhone and Samsung were released on the same date")
	}

	// Create an instance of a phone but defer assigning values to it
	var unknownBrand = Phone{}

	// Now lets set the brand of our unknown phone
	unknownBrand.Brand = "Unknown"
}
```

Alternatively we can declare and initialize structs at the same time.

```go
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

// Fields representing a dude
type Dude struct {
	FirstName string
	LastName  string
	Age       int
}

func main() {

	iphone := Phone{
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

	// Print the value of the iPhone
	fmt.Println(iphone)
}
```

Creating a pointer to a struct is useful *if you want to modify the struct*. For example:

```go
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
	fmt.Println(iphone.Color) // Red
}
```

Some people advocate defining factory functions for structs. However, there's no way to enforce this unless the struct is package local.

```go
func NewPhone(id int, brand string, model string, color string, ranking int,
	seller string, price float, doi DoI, dude Dude) {
		return &Phone(...)
	}
```

### [Arrays](#arrays)

An array is a collection of of a type. The size needs to be specified beforehand, and it cannot be changed.

```go
func main() {
	var colors [3]string
	colors[0] = "red"
	colors[1] = "blue"
	colors[2] = "yellow"

	for i := 0; i < len(colors); i++ {
		fmt.Println(colors[i])
	}
}
```
We can use the range function to iterate through an array without computing its length.

```go
	...
	for index, element := range colors {
		fmt.Println(index, element)
	}
```

or more succinctly, if we only care about the value:

```go
	for _, element := range colors {
		fmt.Println(element)
	}
```

We can create an assign values to an array at the same time, in what's called an `array literal`.

```go
func main() {
	var fruit [2]string = [2]string{"apple", "orange"}
	for _, v := range fruit {
		fmt.Println(v)
	}
}
```

We could omit the var keyword and use `:=` instead.
```go
func main() {
	fruit := [2]string{"apple", "orange"}
	fmt.Println(fruit)
}
```

When using this syntax, don't omit the `{}`.

```go
// arr := [15] int // error: type[15] is not an expression
arr := [15] int{} // correct
```

Arrays cannot be changed once created. You can't add elements to it or sort the values. 

Below is an example of how to calucate Fibonacci sequences using an array.

```go
func fibs() [10] int64 {
	fib[0] = 1
	fib[1] = 1

	for i := 2; i < 10; i++ {
		fib[i] = fib[i - 1] + fib[i - 2]
		fmt.Println(fib[i])
	}
	return fib
}
```

#### [Slices](#slices)

A slice is an array without a predefined size and is easier to use. A slice is a reference to an array that is anonymous. 

```go
func main() {
	ids := []int{3, 5, 7, 11, 13}

	for _, v := range ids {
		fmt.Println(v)
	}
}
```

Below is an example where we sum all the elements of the slice.

```go
func main() {
	sum := 0

	ids := []int{3, 5, 7, 11, 13}

	for _, v := range ids {
		sum += v
	}
	fmt.Println(sum)
}
```

Below is another example based on the colors example where we print a subset of the array by creating a slice.

```go
func main() {
	colors := []string{
		"red",
		"blue",
		"yellow",
		"green",
		"orange"}

	top3Colors := colors[0:3]

	for index, element := range top3Colors {
		fmt.Println(index, element)
	}
}
/*
0 red
1 blue
2 yellow
*/
```

There are two parts to the slice: the first is inclusive, the second is exclusive.

Now an interesting thing about slices is that modifing an element in a slice will modify an element in the original array! This is actually a major difference between go and python.

```go
	top3Colors[0] = "purple"

	fmt.Println(colors[0])
/*
purple
*/
```

```python
scores = [10, 20, 30, 40, 50]
top3Scores = scores[0:3]
top3Scores[0] = 90

print(scores[0])
# 10
```

Now if we want an array of elements but don't want to specify the size, we can use a slice literal. The code below *looks* like we're creating an array, and we are. However the actual array is hidden from us; we are accessing it using a slice literal.

```go
func main() {
	colors := []string{
		"red",
		"blue",
		"yellow"}

	for index, element := range colors {
		fmt.Println(index, element)
	}
}
```

We can use structs within slices, making it easy to create "dummy data":

```go
func main() {
	jobs := []struct {
		translator     string
		status         string
		completionDate string
	}{
		{"John Doe", "Completed", "3/1/2019"},
		{"Mary Jane", "Completed", "7/15/2019"},
		{"Harry Potter", "In Progress", ""},
	}
	fmt.Println(jobs)
}
// [{John Doe Completed 3/1/2019} {Mary Jane Completed 7/15/2019} {Harry Potter In Progress }]
```

A *slice default* refers to shortcuts when declaring a slice. For example, we can create a slice of our slice above to only print John's jobs.

```go
	johnsJobs := jobs[:1]

	fmt.Println(johnsJobs)
```

Now we know that slices refer to arrays and changing elements of a slice changes also changes elements of the array. There are two important concepts to know about slices: its length and capacity. A slice's length is the number of elements in the slice. Its capacity refers to the number of elements in the referring array. However, the capacity can only see the elements to the right of its index. 

```go
func main() {
	s := []int{2, 3, 5, 7, 11, 13}
	printSlice(s) // 6, 6, [2, 3, 5, 7, 11, 13]

	// Slice the slice to give it zero length.
	s = s[:0]
	printSlice(s) // 0, 6, []

	// Extend its length.
	s = s[:4]
	printSlice(s) // 4, 6, [2, 3, 5, 7]

	// Drop its first two values.
	s = s[2:]
	printSlice(s)  // 2, 4, [5, 7]
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}

```

Another example:

```go
func printSlice(s []string) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}

func main() {
	days := []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}

	days = days[0:1]
	printSlice(days) // 1, 7, [Monday]

	days = days[1:3]
	printSlice(days) // 2, 6, [Tuesday, Wednesday]

	days = days[1:2]
	printSlice(days) // 1, 5, [Wednesday]
}
```

Just remember, the length is the number of elements in the slice, while capacity refers to the number of elements in the original array based on the *first element* in our slice. 

Another example:

```go
b := []byte{'g', 'o', 'l', 'a', 'n', 'g'}

b[1:4] length: 3 capacity: 5
b[:2] length: 2 capacity: 6
b[2:] length: 4 capacity: 4
b[:] length: 6 capacity: 6
```

If you take a slice of a slice, the content of the slice may have fewer elements than the original array.

```go
s1 := []byte{'p', 'o', 'e', 'm'}
s2 := s1[2:]    // line 2 { 'e', 'm'}
s2[1] = 't'     // line 3 {'e', 't'
```

A *nil slice* is a slice whose length and capacity is 0. What's the use of a nil slice? Well, if you want to remove all the elements in a slice, you can set its value to nil. 

```go
func main() {

	type shoppingCart struct {
		name     string
		price    float64
		quantity int
	}

	s := []shoppingCart{
		{"brocolli", 2.14, 1},
		{"carrots", 1.25, 12},
		{"oranges", 0.35, 8},
	}

	fmt.Println(s)

	s = nil

	if s == nil {
		fmt.Println("Emptied the shopping cart!")
	}
}
```

A slice can be created using *make*. Why use make? The idea is that you want an array, but don't want to fill it up with data immediately. What you want to do is to use `make` to create our slice. The *make* keyword allocates memory for the array.

```go
func main() {
	a := make([]int, 5) // similarily, var a []int = make([]int, 5)
	a[0] = 1
	a[2] = 4
	a[4] = 6

	fmt.Println(a)
}
// [1 0 4 0 6]
```

We can create a two dimensional array by creating what's called slices of slices.

```go

func main() {
	board := [][]string{
		[]string{"_", "e", "_"},
		[]string{"_", "_", "_"},
		[]string{"_", "_", "_"},
		[]string{"_", "c", "_"},
	}

	for i := 0; i < len(board); i++ {
		fmt.Printf("%s\n", strings.Join(board[i], " "))
	}

}

```

Arrays and slices normally do not grow in size. We can, however, use the append() function to add more elements to a slice!

```go
func main() {
	lines := make([]string, 1)
	lines[0] = "Hello world"
	lines[1] = "I love Go!" // This results in a panic

	fmt.Println(lines)
}
```

Instead of using make, use append to dynamically grow a slice.

```go
func main() {
	lines := []string{}
	lines = append(lines, "Hello world")
	lines = append(lines, "I love Go!")
	fmt.Println(lines)
}
// [Hello world I love Go!]
```

Another example:

```go
func main() {
	var colors = []{string{"red", "blue", "yellow"}
	colors = append(colors, "purple")
	colors = append(colors, "green")

	fmt.Println(colors)
}
```

Below is an example of enlarging a slice.

```go
func enlarge(s []int, factor int) []int {
	var dest[] int = make([]int, len(s) * factor)
	
	fmt.Println(dest)

	copy(dest, s)
	return dest
}
```


The append() function can also be used to remove elements from a slice. The code below calls append with only one argument. This effectively removes elements 0 and 1 from the slice.

```go
func main() {
	var ary = []int16{12, 7, 4, 67, 82}
	ary = append(ary[2:len(ary)])
	fmt.Println(ary[2]) // 82
}
```

Earlier we saw an example of using range over a slice of an slice of colors. We can also use range directly on a slice.

```go
func main() {
	colors := []string{
		"red",
		"blue",
		"yellow",
		"green",
		"orange"}

	for index, element := range colors {
		fmt.Println(index, element)
	}
}
```

If we only need the index, we can omit the second variable.

```go
func main() {
	numbers := []int{
		2,
		3,
		4,
		6,
		8}

	for index := range numbers {
		numbers[index] *= 2
		fmt.Println(numbers[index])
	}
}

```

Below is an example of how to generate a Fibonacci sequence using a slice.

```go
func fibarray(term int) []int {
	ret := make([]int, term)

	ret[0] = 0
	ret[1] = 1

	for i := 2; i < term; i++ {
		ret[i] = ret[i - 1] + ret[i - 2]
	}
	return ret
}
```

The following example uses make, copy along with slices to insert a slice into a slice.

```go
func insertSlice(slice, insertion []string, index int) []string {
    
	dest := make([]string, len(slice) + len(insertion))
	
	n := copy(dest, slice[0:index])
	n += copy(dest[n:], insertion)
	copy(dest[n:], slice[index:])

	return dest
}
```

Below is an example of filtering a slice for even numbers. Be very careful about the range keyword; the first value is the index, not the value.

```go
func Filter(s [] int, fn func(int) bool) []int {
	ret := make([]int, 0)

	for _, elem := range s {
		if fn(elem) {
			ret = append(ret, elem)
		}
	}
	return ret
}
```

Here's a trick question: what will be the value of items after the loop? Answer: nothing is changed in the original array, so it will be [10, 20, 30, 40, 50]

```go
items := [...]int{10, 20, 30, 40, 50]

for _, item := range items {
item *= 2
}
```

If the slice values are the same, the length is 0.

```go
s[1:1] -> 0
```

### [Maps](#maps)

Maps are key value pairs. In Go, we use the *make* function to create a map. Below is an example where we do a few operations on maps: adding, finding the size, iterating, and deleting an element.

```go
func main() {
	// Define map
	emails := make(map[string]string)

	emails["Taro"] = "taro@gmail.com"
	emails["Goro"] = "goro@gmail.com"

	for _, v := range emails {
		fmt.Println(v)
	}

	fmt.Println("Total number of emails:", len(emails))

	delete(emails, "Taro")

	fmt.Println("Total number of emails:", len(emails))

	for _, v := range emails {
		fmt.Println(v)
	}
}
```

Use delete to remove an element from a map.

Below is a example where the value is data type struct. Note that we have made a map as a global variable and this requires the var keyword.

```go
type plant struct {
	age      int
	pType    string
	location string
}

var m map[string]plant

func main() {
	m = make(map[string]plant)
	m["oak"] = plant{50, "tree", "backyard"}
	m["sage"] = plant{2, "shrub", "sideyard"}

	fmt.Println(m["oak"])
	fmt.Println(m["sage"])
}

```

We can also create a map and define the elements at the same time in what is called a *map literal*:

```go
func main() {
	// Define map
	emails := map[string]string{"Taro": "taro@gmail.com", "Goro": "goro@gmail.com"}

	for _, v := range emails {
		fmt.Println(v)
	}
}
```

Another example, where the value is a struct.

```go
type plant struct {
	age      int
	pType    string
	location string
}

var m = map[string]plant{
	"oak":  plant{50, "tree", "backyard"},
	"sage": plant{2, "shrub", "sideyard"},
}

func main() {
	fmt.Println(m["oak"])
	fmt.Println(m["sage"])
}
```

Below is a solution for the wordcount problem on go.com. Here we make use of the Fields method which splits a string based on whitespace.

```go
package main

import (
	"golang.org/x/tour/wc"
	"strings"
)

type Frequency map[string]int

func WordCount(s string) map[string]int {

	f := make(Frequency)
	
	fields := strings.Fields(s)
	
	for _, word := range(fields) {
		f[word]++
	}
	
	return f
}

func main() {
	wc.Test(WordCount)
}

```

Below is a solution for a wordcount problem on exercism. We use regexp to split the string based on multiple delimitters.

```go
// Frequency of words
type Frequency map[string]int

// WordCount counts the number of words in phrase and returns a map
func WordCount(phrase string) Frequency {

	// Allocate storage for our map
	f := make(Frequency)

	// Create a regex expression defining our delimiters
	t := regexp.MustCompile(`[ ,\n:!&@$%^:.]`)

	// Return all substrings
	v := t.Split(phrase, -1)

	// Iterate through the array and populate the map
	for _, element := range v {

		// Ignore empty strings
		if len(element) == 0 {
			continue
		}

		element = strings.ToLower(element)
		element = strings.Trim(element, "'")

		// Update the map
		f[element]++

	}

	return f
}
```

Below is a solution to a wordcount problem in *The Go Programming Language*. The problem asks for finding the number of duplicates per file. The solution uses a map which embeds a second map as the values. It sounds cumbersone, but to make it easy for us, we create a map per file and assign it to our primary map.

```go
package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

func main() {
	// Map a file to a map of lines and the number of times it appears in that file.
	counts := make(map[string]map[string]int)

	for _, filename := range os.Args[1:] {
		data, err := ioutil.ReadFile(filename)

		if err != nil {
			fmt.Fprintf(os.Stderr, "dup3: %v\n", err)
			continue
		}

		// Create a map for our file
		fileMap := make(map[string]int)

		for _, line := range strings.Split(string(data), "\n") {
			// Discard whitespaces
			line = strings.TrimSpace(line)

			// Ignore whitespaces
			if len(line) == 0 {
				continue
			}

			// Increment the number of times the line appeared in the file
			fileMap[line]++
		}

		// Remove all entries in the map which are not duplicates
		for k, v := range fileMap {
			if v < 2 {
				delete(fileMap, k)
			}
		}

		// Assign the map to our map
		counts[filename] = fileMap
	}

	// Use the json package to convert the Go struct to JSON (marshalling)
	data, err := json.MarshalIndent(counts, "", "\t")

	if err != nil {
		log.Fatal("JSON marshalling failed: ", err)
	}

	fmt.Printf("%s\n", data)
}

/*
{
        "bar.txt": {
                "green": 3
        },
        "hello.txt": {
                "foo": 2
        }
}
*/
```

To check whether a key exists: you can write:

```go
if _, value := map[key]; value {
	fmt.Println("OK")
}
```

For example: 

```go
var Days = map[int]string{1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday", 7: "Sunday"}

func findDay(n int) string {
	if _, val := Days[n]; val {
		return Days[n]
	}
	return "Wrong Key"
}
```

Maps can be sorted but to do this, you need to sort the keys, then use the key to access the vaule.

```go
func main() {
	ips := make(map[string]string)
	ips["gorilla"] = "host1"
	ips["monkey"] = "host2"
	ips["pen"] = "host3"
	ips["apple"] = "host4"

	// fmt.Println(ips)
	// delete(ips, "192.168.2.1")

	keys := make([]string, len(ips))
	i := 0

	for ip := range ips {
		keys[i] = ip
		i++
	}

	sort.Strings(keys)

	for i := range keys {
		fmt.Println(ips[keys[i]])
	}

}
```

### [Functions](#functions)

Below is an example of a function which takes an argument and returns a string. Notice that the type comes after the name of the variable.

```go
func greet(name string) string {
	return "Hello " + name
}

func main() {
	fmt.Println(greet("Taro"))
}
```

If a function has multiple arguments of the same type, a shortcut can be used to declare the type for both of them.

```go
func add(num1, num2 int) int {
	return num1 + num2
}

func main() {
	fmt.Println(add(3, 4))
}
// 7
```

Functions can return multiple results. Note that the return types need to be specified within parenthesis

```go

func swap(x, y int64) (int64, int64) {
	return y, x
}

func main() {
	x := int64(23)
	y := int64(97)

	x, y = swap(x, y)

	fmt.Println("x and y: ", x, y)
}

```

Return values can be given variable names. This can aid in documentaing the function. A *naked* return can be used in this case but is not recommended for long functions.

```go
func getChange(quarters int64) (dimes int64, nickels int64, pennies int64) {

	// Set initial values
	dimes, nickels, pennies = 0, 0, 0

	// Get the number of dimes
	dimes = quarters / 10
	remainder := quarters % 10

	// Get the number of nickels. If we don't have a remainder, return from this function.

	if remainder > 0 {
		nickels = remainder / 5
		remainder = remainder % 5
	}

	if remainder > 0 {
		pennies = remainder
	}

	return
```

*Variadic functions* are functions that have a varying number of arguments. This is similar to an argument that is a list. 

```go
func sum(vals ...int) int {
	sum := 0

	for _, val := range vals {
		sum += val
	}
	return sum
}

func main() {
	sum := sum(1, 2, 3)
	fmt.Println(sum)
}
```

### [Methods](#methods)

Methods are functions that have been added to structs. The first of these are called *value receivers* because they don't change the original value.

The example below uses a struct. 

```go
import (
	"fmt"
	"strconv"
)

type name struct {
	firstName string
	lastName  string
	age       int
}

func (n name) greet() string {
	return "Hi, my name is " + n.firstName + " " + n.lastName + " and I am " + strconv.Itoa(n.age)
}

func main() {
	p := name{"Mary", "Pierce", 26}
	fmt.Println(p.greet())
}
```

Here, `n` is a receiver object.

If we want to modify the content of a struct, we must use a *pointer receiver*. What happens in this case is that we pass the address of the variable to the function and not simply its values. 

```go
func (n *name) birthday() {
	n.age++
}

func main() {
	p := name{"Mary", "Pierce", 26}
	fmt.Println(p.greet())
	p.birthday()
	fmt.Println(p.greet())
}
```

Below is an example of using pointer receivers in functions to change the value of the arguments.

```go
type elf64Half int64
type elf64Word int64
type elf64Off int64

// A structure to describe an elf32 header
type elf32Hddr struct {
	eIdent   []rune
	eType    elf64Half
	eMachine elf64Half
	eEntry   elf64Word
	ePhoff   elf64Off
}

// A function to swap the type of two elf32 headers
func swap(x *elf32Hddr, y *elf32Hddr) {
	x.eType, y.eType = y.eType, x.eType
}

func main() {
	x := elf32Hddr{[]rune("abcdefg"), 81, 44, 9, 0}
	y := elf32Hddr{[]rune("abcdefg"), 18, 44, 9, 0}

	fmt.Println("Before swap: ", x.eType, y.eType)

	swap(&x, &y)

	fmt.Println("After swap: ", x.eType, y.eType)
}
```

### [Interfaces](#interfaces)

A type is said to implment an interface if it implements its methods. Below, we implement the greet() method on the person interface.

```go
import (
	"fmt"
	"math"
)

import (
	"fmt"
	"math"
)

type shape interface {
	area() float64
}

type circle struct {
	radius float64
}

type rectangle struct {
	x, y float64
}

func (c circle) area() float64 {
	return math.Pi * c.radius * c.radius
}

func (s rectangle) area() float64 {
	return s.x * s.y
}

func getArea(s shape) float64 {
	return s.area()
}

func main() {
	c := circle{7.0}
	fmt.Printf("Area: %f\n", math.Round(getArea(c)))

	s := rectangle{9.0, 3.0}
	fmt.Printf("Area: %f\n", getArea(s))
}


// 154
// 27
```

An "stringer" can be implemented for interfaces to provide a human-friendly string for printing to the console.


```go
type iPAddr [4]byte

func (p iPAddr) String() string {
	return fmt.Sprintf("%d.%d.%d.%d", p[0], p[1],p[2], p[3])
}

func main() {
	hosts := map[string]iPAddr{
		"loopback":  {127, 0, 0, 1},
		"googleDNS": {8, 8, 8, 8},
	}
	for name, ip := range hosts {
		fmt.Printf("%v: %v\n", name, ip)
	}
}
```

Interfaces can embed other interfaces. For example, the File interface below embeds both the ReadWrite and Lock interfaces, and provides a Close() method.

```go
type ReadWrite interface {
  Read(b Buffer) bool
  Write(b Buffer) bool
}

type Lock interface {
  Lock()
  Unlock()
}

type File interface {
  ReadWrite
  Lock
  Close()
}
```

It is possible to detect the interface.

```go
package main

import "fmt"

type Simpler interface { 
	
}

type Simple struct {
	
}

func (p *Simple) Get() int {  
	return 0
}

func (p *Simple) Set(u int) {
	
}

type RSimple struct {
	Simpler
}

func (p *RSimple) Get() int {
	return 0
}

func (p *RSimple) Set(u int) {
	
}

func fI(it Simpler) int { 
	switch t := it.(type) {
		case *Simpler:
		  fmt.Printf("Simpler")
		case *RSimple:
		  fmt.Printf("Rsimpler)")
		default:
		      fmt.Printf("Unexpected type %T", t)
	}
	return 0
}

func main() {
	
}
```

### [Files](#files)

To read a file, use *IOUtil.readFile()*.

```go
package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func main() {
	data, err := ioutil.ReadFile("hello.txt")

	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	}

	// Because data is a byte slice, attempting to just print it will not result in
	// human-readable values.
	// fmt.Println(data)

	// The *split*() method can parse byte arrays
	for _, line := range strings.Split(string(data), "\n") {
		fmt.Println(line)
	}
}
/*
{
  "name": "my_package",
  "version": "1.0.0",
  "dependencies": {
    "my_dep": "^1.0.0",
    "another_dep": "~2.2.0"
  }
}
*/
```

Another way is to use the `os.Open()` method to open a file and use a buffer with `bufio` to read it.

```go
package main
import (
"bufio"
"fmt"
"io"
"os"
)

func main() {
  inputFile, inputError := os.Open("input.dat")
  if inputError != nil {
    fmt.Printf("An error occurred on opening the inputfile\n" +

    "Does the file exist?\n" +
    "Have you got access to it?\n")
    return // exit the function on error
  }
  defer inputFile.Close()
  inputReader := bufio.NewReader(inputFile)
  for {
    inputString, err := inputReader.ReadString('\n')
    if err == io.EOF {
      return
  }
    fmt.Printf("The input was: %s", inputString)
  }
}
```

`ReadFile` is not recommended for big files because everything is read into memory.

`fmt.Fscanln` can be used to read and parse lines in a file with space separated fields.

```go
package main
import (
"fmt"
"os"
)

func main() {
  file, err := os.Open("products2.txt")
  if err != nil {
    panic(err)
  }
  defer file.Close()
  var col1, col2, col3 []string
  for {
    var v1, v2, v3 string
    _, err := fmt.Fscanln(file, &v1, &v2, &v3) // scans until newline
    if err != nil {
      break
    }
    col1 = append(col1, v1)
    col2 = append(col2, v2)
    col3 = append(col3, v3)
  }
  fmt.Println(col1)
  fmt.Println(col2)
  fmt.Println(col3)
}
```

Go has the ability to read compressed files.

```go
package main
import (
"fmt"
"bufio"
"os"
"compress/gzip"
)

func main() {
    fName := "test.txt.gz"
    var r *bufio.Reader
    fi, err := os.Open(fName)
    if err != nil {
        fmt.Fprintf(os.Stderr, "%v, Can't open %s: error: %s\n", os.Args[0], fName, err)
        os.Exit(1)
    }
    fz, err := gzip.NewReader(fi)
    if err != nil {
        r = bufio.NewReader(fi)
    } else {
        r = bufio.NewReader(fz)
    }
    for {
        line, err := r.ReadString('\n')
        if err != nil {
            fmt.Println("Done reading file")
            os.Exit(0)
        }
        fmt.Println(line)
    }
}
```

Here's an example of using `bufio` to write to a file.

```go
package main
import (
  "os"
  "bufio"
  "fmt"
)

func main () {
  outputFile, outputError := os.OpenFile("output/output.dat", os.O_WRONLY|os.O_CREATE, 0666)
  if outputError != nil {
    fmt.Printf("An error occurred with file creation\n")
    return
  }
  defer outputFile.Close()
  outputWriter:= bufio.NewWriter(outputFile)
  outputString := "hello world!\n"
  for i:=0; i<10; i++ {
    outputWriter.WriteString(outputString)
  }
  outputWriter.Flush()
}
```

The `os` package can also be used to write files.

```go
package main
import "os"

func main() {
  os.Stdout.WriteString("hello, world\n")
  f, _ := os.OpenFile("output/test.txt", os.O_CREATE|os.O_WRONLY, 0)
  defer f.Close()

  f.WriteString("hello, world in a file\n")
}
```

So given the choice between using functions in `io` or `os` or even `io.ioutil`, how do we decide when to use which?

It seems that:

- Use ioutil for the simplest cases when the file is small and we don't mind reading/writing everything at once. Note that `ioutil` is being deprecated and shouldn't be the first choice.

- Otherwise, `os` with `bufio` provides buffered reading/writing


## [Advanced](#advanced)

### [Goroutines](#goroutines)

A goroutine is a lightweight thread.

```go
func hello() {
	fmt.Println("Hello world goroutine")
}
func main() {
	go hello()
	fmt.Println("main function")
	time.Sleep(1 * time.Second)
}

/* output
main function
Hello world goroutine
*/
```

Waitgroups let you run goroutines in sthe background and block the program until all are completed.

```go
package main
import (
  "fmt"
  "sync"
)

func HeavyFunction1(wg *sync.WaitGroup) {
  defer wg.Done()
  // Do a lot of stuff
}

func HeavyFunction2(wg *sync.WaitGroup) {
  defer wg.Done()
  // Do a lot of stuff
}

func main() {
  wg := new(sync.WaitGroup)
  wg.Add(2)
  go HeavyFunction1(wg)
  go HeavyFunction2(wg)
  wg.Wait()
  fmt.Printf("All Finished!")
}
```

### [Mutex](#mutex)

A mutex is a tool to lock a region of code from being modified by other threads. 

```go
ype Info struct {
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

//  Locking: mary
// Unlocking
// Locking: mary
// Updating name
// Unlocking
// Locking: george
// Unlocking
// george
```

### [Channels](#channels)

Channels are a typed conduit for messages. The reader will block until the writer has finished writing, so explicit synchronization is not necessary.

```go
// Function to process messages in an array. We stop processing once we
// encounter the string 'stop' even if there are other messages
func processCmd(s []string, c chan int) {

	msgCount := 0

	for _, v := range s {
		if v == "stop" {
			break
		}
		msgCount++
	}
	c <- msgCount // Send msgCount to the channel
}

func main() {
	s := []string{"message a", "message b", "message c", "stop", "message d"}

	c := make(chan int)
	go processCmd(s, c)

	sum := <-c // Receive msgCount from the channel

	fmt.Println("message: ", sum)
}
```

Here's another example:

```go
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
```

If you write to a channel, you must read from the channel or the writer will be deadlocked.

```go
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
```

Buffered channels set the length of the buffer length. Message counts exceeding this buffer length will result in a fatal error (however, goroutines don't seem to suffer this issue). Unbuffered channels will not block because they will wait until the maximum number of elements are reached before synchronization. 

```go
// Function to process messages in an array. We stop processing once we
// encounter the string 'stop' even if there are other messages
func processCmd(s []string, c chan int) {

	msgCount := 0

	for index, v := range s {

		if index == len(s)-1 && v == "stop" {
			// If we've reached the last element and the message is "stop", don't count it
			break
		} else if v == "stop" {
			c <- msgCount // Send msgCount to the channel
			continue
		} else {
			msgCount++
		}
	}

	c <- msgCount // Send msgCount to the channel

	close(c)
}

func main() {
	s := []string{"message a", "message b", "message c", "stop", "message d", "stop", "message e"}

	c := make(chan int, 2)

	processCmd(s, c)
	//go processCmd(s, c) // doesn't have an issue with buffer length

	for v := range c {
		fmt.Println(v)
	}

}
```

We can check if the channel is closed by specifying a second variable when reading from channel. If ok is false, then there are no more values to receive and the channel is closed.

```go
// Function to count the length of a string, excluding blank spaces
func count(s string, c chan int) {

	counter := 0

	for _, r := range s {
		c := string(r)
		if c != " " {
			counter++
		}
	}

	c <- counter

	close(c)
}

func main() {
	s := "hello world"

	c := make(chan int)

	go count(s, c)

	count, ok := <-c // Receive msgCount from the channel

	// Check the channel for values. If there were any, then print the value
	if ok != false {
		fmt.Println(count)
	}
}
```

Below is an example of using a goroutine in a closure.

```go
func main() {
	s := "hello world"

	c := make(chan int)
	
	go func() {
		counter := 0

		for _, r := range s {
			c := string(r)
			if c != " " {
				counter++
			}
		}

		c <- counter
		close(c)
	}()

	count, ok := <-c // Receive msgCount from the channel

	// Check the channel for values. If there were any, then print the value
	if ok != false {
		fmt.Println(count)
	}

}
```

If you have multiple channels, you can use `select` to get values from the channels.

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	status := make(chan string)
	message := make(chan string)

	statusFunc := func() {
		status <- "ready"
	}

	messageFunc := func() {
		message <- "All actions done"
	}

	go statusFunc()
	go messageFunc()

	go func(ch1 chan string, ch2 chan string) {
		for {
			select {
			case v := <- ch1:
				fmt.Printf("Received status: %s\n", v)
			case v:= <- ch2:
				fmt.Printf("Received message: %s\n", v)
			}
		}
	}(status, message)

	time.Sleep(1 * time.Second)
}
```

One important thing to note is that the select statement chooses a claus at random. This can be used to generate random numbers.



This means main.go can be implemented as a channel handler.

### [Closures](#closures)

Functions are first class citizens in go and can be passed and returned by functions like any other type.

```go
func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}

func main() {
	sum := adder()
	for i := 0; i < 10; i++ {
		fmt.Println(sum(i))
	}
}

```

### [Web](#web)

A simple web server:

```go
package main

import (
	"fmt"
	"net/http"
)

func index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func main() {
	http.HandleFunc("/", index)
	fmt.Println("Server startng...")
	http.ListenAndServe(":3000", nil)

}
```

### [JSON](#json)

Go has excellent support for encoding and decoding structs in JSON format. Suppose we want to generate a package.json to be consumed by npm, the package manager for node.js. 

```go
// Package represents the npm package and any dependencies
type Package struct {
	Name         string
	Version      string
	Dependencies []Dependency
}

// Dependency is a package on which a package depends on
type Dependency struct {
	Dependency string
	Version    string
}

func main() {
	var dependencies = []Dependency{{"my-dep", "^1.0.0"}, {"another_dep", "~2.2.0"}}
	p := Package{
		Name:         "my package",
		Version:      "1.0.0",
		Dependencies: dependencies,
	}

	fmt.Println(p)
}
/*
{my package 1.0.0 [{my-dep ^1.0.0}]}
*/
```

To generate JSON from Go, we can use the *Marshall()* method in the *json* package. All exported fields (fields that begin with a capital letter) will be marshalled. Any fields which are not exported will not be marshalled.

```go
import (
	"encoding/json"
	"fmt"
	"log"
)

// Package represents the npm package and any dependencies
type Package struct {
	Name         string
	Version      string
	Dependencies []Dependency
}

// Dependency is a package on which a package depends on
type Dependency struct {
	Dependency string
	Version    string
}

func main() {
	var dependencies = []Dependency{{"my-dep", "^1.0.0"}, {"another_dep", "~2.2.0"}}
	p := Package{
		Name:         "my package",
		Version:      "1.0.0",
		Dependencies: dependencies,
	}

	// Print the Package struct
	fmt.Println(p)

	// Use the json package to convert the Go struct to JSON (marshalling)
	data, err := json.Marshal(p)

	if err != nil {
		log.Fatal("JSON marshalling failed: ", err)
	}

	fmt.Printf("%s\n", data)
}
/*
{"Name":"my package","Version":"1.0.0","Dependencies":[{"Dependency":"my-dep","Version":"^1.0.0"},{"Dependency":"another_dep","Version":"~2.2.0"}]}
*/
```

Go supports the ability to *tag* struct fields to output correct JSON. This is useful if we want to provide an alternative name for the field. We can also use the *json.MarshallIndent()* to print a more human-friendly version of JSON.

```go
import (
	"encoding/json"
	"fmt"
	"log"
)

// Package represents the npm package and any dependencies
// Specify tags for the fields to output the correct json
type Package struct {
	Name         string       `json:"name"`
	Version      string       `json:"version"`
	Dependencies []Dependency `json:"dependencies"`
}

// Dependency is a package on which a package depends on
type Dependency struct {
	Dependency string `json:"dependency"`
	Version    string `json:"version"`
}

func main() {
	var dependencies = []Dependency{{"my-dep", "^1.0.0"}, {"another_dep", "~2.2.0"}}
	p := Package{
		Name:         "my package",
		Version:      "1.0.0",
		Dependencies: dependencies,
	}

	// Print the Package struct
	fmt.Println(p)

	// Use the json package to convert the Go struct to JSON (marshalling)
	data, err := json.MarshalIndent(p, "", "\t")

	if err != nil {
		log.Fatal("JSON marshalling failed: ", err)
	}

	fmt.Printf("%s\n", data)
}
/*
{
	"name": "my package",
	"version": "1.0.0",
	"dependencies": [
			{
					"dependency": "my-dep",
					"version": "^1.0.0"
			},
			{
					"dependency": "another_dep",
					"version": "~2.2.0"
			}
	]
}
*/
```

Below is some code to read package.json, convert it to a struct, then output it as JSON again. Note that we have made some adjustments compared to the previous code. Instead of using *Dependencies []Dependency* we use a map to define dependencies.

```go
package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

// Package represents the npm package and any dependencies
type Package struct {
	Name         string            `json:"name"`
	Version      string            `json:"version"`
	Dependencies map[string]string `json:"dependencies"`
}

func main() {
	data, err := ioutil.ReadFile("hello.json")

	if err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		return
	}

	var p Package

	if err := json.Unmarshal(data, &p); err != nil {
		log.Fatalf("JSON unmarshalling failed: %s\n", err)
	}

	fmt.Println(p) // {my_package 1.0.0 map[another_dep:~2.2.0 my_dep:^1.0.0]}

	// Use the json package to convert the Go struct to JSON (marshalling)
	data, err = json.MarshalIndent(p, "", "\t")

	if err != nil {
		log.Fatal("JSON marshalling failed: ", err)
	}

	// Display the struct as a JSON object
	fmt.Printf("%s\n", data) 

	/*
	{
        "name": "my_package",
        "version": "1.0.0",
        "dependencies": {
                "another_dep": "~2.2.0",
                "my_dep": "^1.0.0"
        }
	}
	*/
}
```

For structs, only exported fields will be encoded/decoded in JSON. Fields must start with capital letters to be exported.

### [Commands](#commands)

The *os* package has functions for executing commands and dealing with their input and output. Note that the *Command()* function takes a variable number of strings as arguments.

```go
package main

import (
	"fmt"
	"os/exec"
	"strings"
)

// ListLogFiles reads from /var/log
func ListLogFiles() (string, error) {

	// Pass a variable number of strings to exec.Command()
	out, err := exec.Command("ls", "-F", "/var/log").Output()

	if err != nil {
		return "", err
	}

	entries := strings.Split(string(out), "\n")

	var ret string

	// List files and skip over directories
	for _, entry := range entries {
		entry = strings.Trim(entry, "")
		if len(entry) > 0 && strings.LastIndex(entry, "/") == -1 {
			ret += entry + "\n"
		}
	}

	// Return the output and trim leading and trailing newlines
	return strings.Trim(ret, "\n"), nil

}

func main() {
	data, err := ListLogFiles()

	if err != nil {
		fmt.Println("Failed to read log file directory!")
	}
	fmt.Println(data)
}
```

### [Testing](#testing)

In Go, tests are written in a file with the _test.go suffix. Each test file contains functions in the form *func TestName(t *testing.T)*.

Below is a test for a function that creates abbreviations.

```go
func Abbreviate(s string) string {
	abbreviation := ""

	// Splits a string around one or more whitespace
	fields := strings.Fields(s)

	for _, element := range fields {
		firstLetter := strings.Split(element, "")[0]
		abbreviation += strings.ToUpper(firstLetter)
	}
	return abbreviation
}

// abbreviate_test.go
...
import (
	"testing"
)

func TestBasic(t *testing.T) {
	output := Abbreviate("Portable Network Graphics")

	if output != "PNG" {
		t.Error(output + ` was not PNG`)
	}
}

func TestLowercaseWords(t *testing.T) {
	output := Abbreviate("Don't communicate by sharing memory, share memory by communicating.")

	if output != "DCBSMSMBC" {
		t.Error(output + ` was not DCBSMSMBC`)
	}
}

func TestPunctuation(t *testing.T) {
	output := Abbreviate("First In, First Out")

	if output != "FIFO" {
		t.Error(output + ` was not FIFO`)
	}
}

func TestAllCapsWord(t *testing.T) {
	output := Abbreviate("GNU Image Manipulation Program")

	if output != "GIMP" {
		t.Error(output + ` was not GIMP`)
	}
}
...
/*
$ go test -v
=== RUN   TestBasic
--- PASS: TestBasic (0.00s)
=== RUN   TestLowercaseWords
--- PASS: TestLowercaseWords (0.00s)
=== RUN   TestPunctuation
--- PASS: TestPunctuation (0.00s)
=== RUN   TestAllCapsWord
--- PASS: TestAllCapsWord (0.00s)
PASS
ok      gopl.io/ch11/word2  0.002s
*/
```

This looks all well, but it fails when the word is surrounded by underscores.

```go
func TestUnderscores(t *testing.T) {
	output := Abbreviate("Go is _not_ Java")

	if output != "GINJ" {
		t.Error(output + ` was not GINJ`)
	}
}
...
=== RUN   TestUnderscores
    TestUnderscores: hello_test.go:43: GI_J was not GINJ
--- FAIL: TestUnderscores (0.00s)
FAIL
```

This prompts us to use the FieldsFunc() function instead so we can implement the function that will be used to parse the string. This example also makes use of function variables.

```go
package word

import (
	"strings"
	"unicode"
)

func Abbreviate(s string) string {
	abbreviation := ""

	// See https://golang.org/pkg/strings/#FieldsFunc for the original example
	f := func(c rune) bool {
		return !unicode.IsLetter(c) && !unicode.IsNumber(c) && c != '\''
	}

	// Splits a string around one or more whitespace
	fields := strings.FieldsFunc(s, f)

	for _, element := range fields {
		firstLetter := strings.Split(element, "")[0]
		abbreviation += strings.ToUpper(firstLetter)
	}
	return abbreviation
}

```

### [Error Handling](#error-handling)

Many functions in the Go ecosystem return an error data type. For example, the code snippet below opens a file. If there was an error, then the function will exit with an error message.

```go
f, err := os.Open("hello.txt")
defer f.Close()

if err != nil {
	fmt.Println("Unable to open hello.txt")
	os.Exit(1)
}
```

Let's refactor this program and move the code that opens the file to a function.

```go
func openConfig(fname string) error {
	f, err := os.Open(fname)
	defer f.Close()
	return err
}

func main() {

	err := openConfig("config.yml")

	if err != nil {
		fmt.Printf("%T\n", err)
		fmt.Println(err.Error())
	}
}

// Outuput 
// $ go run hello.go 
// *os.PathError
// open config.yml: no such file or directory
```

Notice that the error is of type os.PathError. What if we want to return our own error? Go recommends that we use the error.New() method to return our custom error.

```go
func openConfig(fname string) error {
	f, err := os.Open(fname)
	defer f.Close()

	if err != nil {
		return errors.New("Unable to open config file")
	}
	return nil
}
// $ go run hello.go 
// *errors.errorString
// Unable to open config file
```

Note that when we do this, the error is of type *errors.errorString. This may be okay if we are not concerned about the type of error being returned, only the message in the error. How do we implement our own error? 

The answer lies in looking at the sorce code for errors, at https://golang.org/src/errors/errors.go. An implementation is shown below. As you can see, what we essentially did was implement the errorString struct, implemented the Error() method on the struct, and a helper function which reeturns the address of the struct with our customized message.

```go

// ConfigFileOpenError defines a config file open error
type ConfigFileOpenError struct {
	s string
}

// Create a function Error() string and associate it to the struct.
func (error *ConfigFileOpenError) Error() string {
	return error.s
}

// NewConfigFileOpenError returns an error when a config file can't be opened.
func NewConfigFileOpenError(text string) error {
	return &ConfigFileOpenError{text}
}

func openConfig(fname string) error {
	f, err := os.Open(fname)
	defer f.Close()

	if err != nil {
		return NewConfigFileOpenError("Unable to open config file")
	}
	return nil
}

func main() {

	err := openConfig("config.yml")

	if err != nil {
		fmt.Printf("%T\n", err)
		fmt.Println(err.Error())
	}
}
// $ go run hello.go 
// *main.ConfigFileOpenError
// Unable to open config file
```

Called in a loop, `defer` statemnets are pushed onto a stack; when the function exits, each call will be popped from the stack.

```go
func main() {
	for i := 0; i < 5; i++ {
		defer fmt.Printf("%d ", i)
	}
}
// 4 3 2 1 0
```

As a stylistic note, you should handle errors as part of an if statement when possible.

```go
if value, err := f.f1(param); err != nil {
	fmt.Printf("An error happend: %v\n", err.Error())
	return
}
...

```

Instead of using errors, you can also generate a panic. The following code illustrates how to use it.

```go
func main() {
	if err := openConfig("hello.txt"); err != nil {
		panic(err.Error())
	}

	fmt.Println("Never gets here")
}

func openConfig(fname string) error {
	f, err := os.Open(fname)
	defer f.Close()

	if err != nil {
		return errors.New("Unable to open config file")
	}
	return nil
}
```

`Recover` can be used to recover from panics and simulates Java's `try...catch block`. It is only useful when called in the following convention.

```go
func main() {
	numbers := []int{1, 2, 3, 4, 5}
	value := 0

	fmt.Println("Calling test")
	test(numbers, value)
	fmt.Println("Test complete")
}

func calculate(numbers[] int, value int) int {
	var sum int

	fmt.Println("Calculating the sum")
	for num := range numbers {
		ret := divide(num, value)
		sum += ret
	}
	return sum
}

func test(numbers [] int, value int) {
	defer func() {
		if e:= recover(); e != nil {
			fmt.Printf("Panicking %s\r\n", e)
			// or log.Printf("...")
		}
	}()

	sum := calculate(numbers, value)

	fmt.Printf("Sum: %d\n", sum)
}
```

### [Logging](#logging)

Let's go back the previous example and just print the error to the console.

```go
func main() {
	f, err := os.Open("hello.txt")
	defer f.Close()

	if err != nil {
		fmt.Println(err.Error())
	}
}
```

Another way to print the error message is to use the Printf() function in the log package.

```go
func main() {
	f, err := os.Open("hello.txt")
	defer f.Close()

	if err != nil {
		log.Printf(err.Error())
	}
}
// $ go run hello.go 
// 2020/07/25 14:09:28 open hello.txt: no such file or directory
```

But what if we want to redirect the log messages to a file? 

To do this, we can use the *New()* function in the *log* package. The three arguments are: io.Writer, prefix, and flag.

```go
const (
	LOGFILE = "hello.log"
)

func main() {

	f, err := os.OpenFile(LOGFILE, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)

	defer f.Close()

	if err != nil {
		fmt.Printf("Unable to open %s\n", LOGFILE)
		os.Exit(1)
	}

	logger := log.New(f, "logger ", log.Lshortfile)

	logger.Println("Started hello")
}
// $ cat hello.log 
// logger hello.go:26: Started hello
```

According to https://golang.org/pkg/log, log.Lshortfile displays the prefix, filename and line number, and the log message, which is what was printed. Another flag to experiment with is LstdFlags, which prints the date and time.

```go
...
logger := log.New(f, "logger ", log.LstdFlags|log.Lshortfile)
...

// $ cat hello.log
// logger 2020/07/25 17:51:44 hello.go:26: Started hello

```

Incidentally, the order in which the flags are listed does not change the format. 

The logger returned by *New() is not to be confused with more sophisticated loggers. Unlike *log4j*, as it does not have the ability to indicate log level, nor can it be configured using a configuration file. According tot he documentation, it does claim to have the distinction to be safe to use from multiple goroutines. Additionally, the log package has functions including *Fatalf()* which will exit the program after logging a message. Hence, 

```go
logger := log.New(f, "logger ", log.Lshortfile|log.LstdFlags)

logger.Fatalf("Exiting program")

logger.Println("Started hello")

// $ cat hello.log
// logger 2020/07/25 18:03:38 hello.go:26: Exiting program
```

Will generate a line in the log file with the message "Exiting program", but will not log the message "Starting hello".

### [Networking](#networking)

According to https://golang.org/pkg/net/, there are two main functions associated with the *net* package. The first is *Dial()*, which allows Go programs to connect to a server.

First, let's run nginx using docker. We'll configure it to listen to port 80.

```bash
$ docker pull nginx
...
$  docker run -t --name docker-nginx -p 80:80 nginx
```

Point your browser to http://localhost and verify that you are greeted with the default nginx web page.

Next, let's use the Dial() function to connect to this webserver. We will make use of the log package to log messages to the console.

```go
func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	conn, err := net.Dial("tcp", "localhost:80")
	if err != nil {
		logger.Fatalf("Unable to connect to web server")
	}

	fmt.Fprintf(conn, "GET / HTTP/1.0\r\n\r\n")

	defer conn.Close()

	reader := bufio.NewReader(conn)

	for {
		s, err := reader.ReadString('\n')

		if err != nil {
			break
		}
		fmt.Print(s)
	}
}
// Output:
// $ go run hello.go 
// HTTP/1.1 200 OK
// Server: nginx/1.19.1
// Date: Mon, 27 Jul 2020 19:16:08 GMT
// Content-Type: text/html
// Content-Length: 612
// Last-Modified: Tue, 07 Jul 2020 15:52:25 GMT
// Connection: close
// ETag: "5f049a39-264"
// Accept-Ranges: bytes
// 
// <!DOCTYPE html>
// <html>
// <head>
// <title>Welcome to nginx!</title>
// ...
```

As you can see, functions from the net package offers low level networking primitives. A program to create a server also illustrates this.

```go

func handleConnection(conn net.Conn) {
	defer conn.Close()

	var buf [512]byte
	for {
		n, err := conn.Read(buf[0:])
		if err != nil {
			conn.Close()
			return
		}

		s := string(buf[0:n])
		fmt.Println(s)

		tokens := strings.Split(s, "\n")

		for _, token := range tokens {
			if len(token) > 0 {
				fmt.Println("Token: ", token)
			}
		}

	}
}

func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	ln, err := net.Listen("tcp", ":8080")

	if err != nil {
		logger.Fatalf("Unable to create web server")
	}

	for {
		conn, err := ln.Accept()

		if err != nil {
			logger.Fatalf("Unable to listen")
		}
		go handleConnection(conn)
	}

}

// output
// $ go run hello.go 
// GET /hello-world HTTP/1.1
// Host: localhost:8080
// User-Agent: curl/7.71.1
// Accept: */*
```

If we want to be productive with network programming, we may want to look into the http package. To create a server, we will use the ListenAndServe() function to serve HTTP traffic.

```go
func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		logger.Fatalf("Unable to serve: %s\n", err.Error())
	}

}
```

The second argument to *ListenAndServe() is the handler, which is typically nil, in which case the DefaultServeMux is used.  

Alternatively, we could create an instance of an http.Server to serve requests.

```go
s := &http.Server{
	Addr:           ":8080",
	ReadTimeout:    10 * time.Second,
	WriteTimeout:   10 * time.Second,
	MaxHeaderBytes: 1 << 20,
}
logger.Fatal(s.ListenAndServe())
```

However, we are still not able to handle requests. What we need to do is implement our own handlers and invoke the *http.HandleFunc()* function on them.

```go
func handleRoot(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Invoked handleRoot()")
}

func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	s := &http.Server{
		Addr:           ":8080",
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	http.HandleFunc("/", handleRoot)

	logger.Fatal(s.ListenAndServe())

}
```

If we don't need to configure the server, we could just invoke *ListenAndServe()* from the http package directly.

```go
func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	http.HandleFunc("/", handleRoot)

	logger.Fatal(http.ListenAndServe(":8080", nil))
}
```

In our handler, we could return an HTML response using the provided *http.ResponseWriter*.

```go
func handleRoot(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<html><body>Hello world!</body></html>")
}
```

As demonstrated above, the HandleFunc function makes it easy to handle requests. Let's add another handler.

```go

func handleHello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<html><body>Hello, you have contacted the server</body></html>")
}

func main() {
...
  http.HandleFunc("/hello", handleHello)
  logger.Fatal(http.ListenAndServe(":8080", nil))
}
```

So far, our handlers returned HTML directly. But what if we want to server HTML files instead? To do this, we can creaste a FileServer.

```go
func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	http.Handle("/", http.FileServer(http.Dir(".")))

	logger.Fatal(http.ListenAndServe(":8080", nil))
}
```

This is fine if we just want to serve static files. But now what if we want the user to be able to supply paramenters? Go supports this through the use of templates.


```go
// User is a user
type User struct {
	Name string
}

func handleRoot(w http.ResponseWriter, r *http.Request) {

	tmpl, err := template.New("test").Parse("<html><body>Hello my name is {{.Name}}</body></html>")

	if err != nil {
		panic(err)
	}

	name := r.FormValue("name")

	user := User{name}

	err = tmpl.ExecuteTemplate(w, "rootTemplate", user)

}

func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	http.HandleFunc("/hello", handleRoot)

	logger.Fatal(http.ListenAndServe(":8080", nil))
}
// go run hello.go
// curl http://localhost:8080/hello?name=Taro
// <html><body>Hello my name is Taro</body></html>
```

Let's see how we can improve on this. We want to be able to process a template stored on the file system. To do this, we need to change our code to read the file and extract the bytes.

```go
// User is a user
type User struct {
	Name string
	Age  string
}

func handleRoot(w http.ResponseWriter, r *http.Request) {

	b, err := ioutil.ReadFile("index.html")

	if err != nil {
		panic(err)
	}

	t, err := template.New("rootTemplate").Parse(string(b))

	name := r.FormValue("Name")
	age := r.FormValue("Age")

	user := User{name, age}

	fmt.Println(user)

	err = t.ExecuteTemplate(w, "rootTemplate", user)

	if err != nil {
		fmt.Println(err.Error())
	}
}

func main() {

	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)

	http.HandleFunc("/hello", handleRoot)

	logger.Fatal(http.ListenAndServe(":8080", nil))
}
//  curl "http://localhost:8080/hello?Name=Taro&Age=25"
// <!DOCTYPE html>
// <html>
//    <head>
//        <meta charset="UTF-8">
//        <title>Hello</title>
//    </head>
//    <body>
//        Hello Taro I am 25 years old
//    </body>
// </html>
```

If we want to access a URL, Go supports that too.

```go
func main() {
	url := "http://www.google.com"

	resp, err := http.Head(url)

	if err != nil {
		fmt.Println("Error: ", url)
	}

	fmt.Println("Status: ", resp.Status) // Returns 200
}
```

### [Times and Dates](#timesanddates)

Most often when we want to deal with times and dates in Go, we need to find the current time. 

```go
func main() {

	fmt.Println(time.Now())
}
// 2020-07-28 09:33:44.445612865 -0700 PDT m=+0.000062648
```

To format this value, we need to call the *Format()* method. *The Format()* method takes a reference time as an argument. For example, the code below prints the current time and date but excludes timezone and milliseconds.

```go
func main() {

	t := time.Now()

	s := t.Format("15:04:05 Mon Jan 2 2006")

	fmt.Println(s)

}
// 10:14:54 Tue Jul 28 2020
```

One use of the time package is to measure the amount of time that has elapsed. This is achieved by invoking the *Sub()* method on the end time value.

```go

func main() {

	start := time.Now()

	time.Sleep(time.Second)

	end := time.Now()

	duration := end.Sub(start)

	fmt.Printf("%v\n", duration)
}
// 1.000189175s
```

Alternatively, Go provides a shortcut in the form of the *Since()* function which we can invoke on the Duration struct returned from *Now()* at the beginning of the program.

```go
duration := time.Since(start)
```

As seen above, the Duration is a floating point number and is not human friendly. We could try getting just the seconds from this value.

```go
...
fmt.Println(duration.Seconds())
...
// 1.00041425
```

But again we must deal with a floating point number. 

There are two aproaches to convert floating point numbers to a whole number. One is using the *Floor()* function in the math package.

```go
...
fmt.Println(math.Floor(duration.Seconds()))
...
// 1
```

Another approach is to use the FormatFloat() function in the *strconv* package.

```go
...
seconds := strconv.FormatFloat(duration.Seconds(), 'f', 0, 64)
fmt.Println(seconds)
...
// 1
```

Which is better? Maybe neither, but keep in mind that *math.Floor()* returns a float64 value, while *strconv.FormatFloat()* returns a string. 

### [Internals](#internals)

A Go program is compiled to a native executable file. However at runtime, the program is run within a Go runtime. This runtime is responsible for running applications as well as managing resources such as memory.

The Go garbage collector is responsible for managing memory. Specifically, the garbage collector periodically checks whether objects become out of scope and cannot be referenced any more. 

The *GOGC* environment variable controls the aggressiveness of the garbage collector. The default value of GOGC is 100, meaning the garbage collector will run every time the heap grows by 100%. It follows that if we set this value to 200, then the garbage collector will run every time the heap grows by 200%.

When the garbage collector runs, execution of the program is suspended. This adds latency to the program. The algorithm used by the garbage collector is called mark-and-sweep. All objects in the heap are visited and potentially marked for garbage collection.

The official name for the algorithm used in Go is the *tricolor mark-and-sweep algorithm*. The garbage collector runs in a low-latency goroutine to have minimal impact on a program's performance.

### [Random](#random)

Below is an adaptation of a code snipped from https://golang.org/pkg/math/rand/. It shows the use of several techniques in creating random numbers:

- Creating a stable random generator by using *rand.New()*
- Using a tabwriter to generated formattted output

```go
import (
	"fmt"
	"math/rand"
	"os"
	"text/tabwriter"
)

func main() {
	// Create the random seed generator. Using
	// a fixed seed ensures the same output on every run
	r := rand.New(rand.NewSource(99))

	// Create a tabwriter to help us write tabbed output
	w := tabwriter.NewWriter(os.Stdout, 1, 1, 1, ' ', 0)

	defer w.Flush()

	show := func(key string, value interface{}) {
		fmt.Fprintf(w, "%s\t%v\n", key, value)
	}

	show("Node", r.Intn(10))
	show("Count", r.Intn(10))
	show("Processes", r.Intn(10))
}
/*
Node      7
Count     3
Processes 0
*/
```

The random package has a function which can generate permutations of a number between 0 and n. If we are interested in generating a list of unique numbers within a range this can be useful.

```go

func main() {
	// Create the random seed generator. Use the current time
	// as the source to ensure that the generated numbers are different
	// every time the program is run.
	r := rand.New(rand.NewSource(time.Now().UnixNano()))

	// Create a tabwriter to help us write tabbed output
	w := tabwriter.NewWriter(os.Stdout, 1, 1, 1, ' ', 0)

	defer w.Flush()

	show := func(key string, value interface{}) {
		fmt.Fprintf(w, "%s\t%v\n", key, value)
	}

	ids := r.Perm(10)

	for i := range ids {
		show("ID:", ids[i])
	}

}
/*
ID: 4
ID: 2
ID: 7
ID: 3
ID: 6
ID: 5
ID: 1
ID: 8
ID: 0
ID: 9
*/
```

Suppose, however, that we want to generate a random ID consisting of values between 0-9 and the letters a through f. To do this, we should create a slice and populate each element one by one.

```go
func Init() {
	rand.Seed(time.Now().UnixNano())
}

func IDGenerator() string {
	const letters = "abcdef0123456789"

	b := make([]byte, 10)

	for i := range b {
		b[i] = letters[rand.Intn(len(letters))]
	}
	return string(b)

}

func main() {

	// Create a tabwriter to help us write tabbed output
	w := tabwriter.NewWriter(os.Stdout, 1, 1, 1, ' ', 0)

	defer w.Flush()

	show := func(key string, value interface{}) {
		fmt.Fprintf(w, "%s\t%v\n", key, value)
	}

	Init()

	i := 0

	for i < 10 {
		show("ID:", IDGenerator())
		i++
	}

}

```

[Data Structures](#datastructures)

Below is an example of a circular linked list. The factory function returns an empty LinkedList by value. What seems to be important here is that factory fuctions cannot be methods. When adding a node, we make sure that the new node's next value points to the head of the list instead of null. 

```go
type Node struct {
	data int
	next *Node
}

type LinkedList struct {
	head *Node
	tail *Node
}

func NewList() LinkedList {
	var list LinkedList
	return list
}

func (list *LinkedList) Add(data int) {
	node := Node{data: data}

	if list.head == nil {
		list.head = &node
		node.next = &node
		list.tail = &node
	} else {
		node.next = list.head
		list.tail.next = &node
		list.tail = &node

	}
}

func (list *LinkedList) List() {

	cur := list.head

	headAddr := list.head

	for cur != nil {
		fmt.Println(cur.data)
		cur = cur.next

		if cur == headAddr {
			break
		}

	}
}

func (list *LinkedList) Visit() {

	cur := list.head

	for cur != nil {
		fmt.Println(cur.data)
		cur = cur.next
		time.Sleep(100 * time.Millisecond)
	}
}

func main() {
	list := NewList()
	list.Add(2)
	list.Add(3)
	list.Add(4)
	list.Visit()
}
```

[User Input](#userinput)

There are two ways to read user input from the console.

The first way is to use the *bufio* package to read user input into a variable.

```go
import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {


	reader := bufio.NewReader(os.Stdin)

	var trimmedPassword string

	for {
		fmt.Print("Enter passsword: ")

		password, _ := reader.ReadString('\n')

		trimmedPassword = strings.TrimSpace(password)

		if len(trimmedPassword) > 0 {
			break
		}

	}
	fmt.Printf("You entered: %v\n", trimmedPassword)

}
```

Alternatively, `fmt.Scanf` and `fmt.Scanln` can be used to read input into variables.

```go
var (
	firstname, lastname string
)
func main() {
	fmt.Println("Enter your name")
	fmt.Scanln(&firstname, &lastname)

	fmt.Printf("You entered: %s %s\n", firstname, lastname)
}
```

## [Bytes](#bytes)

The bytes package can be used to create a buffer from which to read and write data. It is more memory and CPU-efficent than +=.

```go
var buffer bytes.Buffer
for {
	if s, ok := getNextSrring(); ok {
		buffer.WriteString(s)
	} else {
		break
	}
}
fmt.Print(buffer.String(), "\n")
```

## [String](#string)

You can add a String() method to a struct to provide some information when printing out the string. This is similar to `toString()` in Java.

```go
type Friend struct {
  first, last string
}

func (f *Friend) String() string {
  return f.first + " " + f.last
}

f := Friend{"George", "Clooney"}
fmt.Println(f) // George Clooney
...
```

If you do lots of string concatenation, consider using `bytes.Buffer`.

```go
var b bytes.Buffer

for status == False {
	s = getNextValue()
	b.WriteString(s)
}

return b.String()
```

## [Gobs](#gobs)

A gob is binary data. Gobs can contain any kind of data, but the example shown below represents a struct.

```go
package main
import (
"bytes"
"fmt"
"encoding/gob"
"log"
)

type P struct {
  X, Y, Z int
  Name string
}

type Q struct {
  X, Y *int32
  Name string
}

func main() {
  // Initialize the encoder and decoder. Normally enc and dec would be
  // bound to network connections and the encoder and decoder would
  // run in different processes.
  var network bytes.Buffer // Stand-in for a network connection
  enc := gob.NewEncoder(&network) // Will write to network.
  dec := gob.NewDecoder(&network)// Will read from network.
  // Encode (send) the value.
  err := enc.Encode(P{3, 4, 5, "Pythagoras"})
  if err != nil {
    log.Fatal("encode error:", err)
  }
  // Decode (receive) the value.
  var q Q
  err = dec.Decode(&q)
  if err != nil {
    log.Fatal("decode error:", err)
  }
  fmt.Printf("%q: {%d,%d}\n", q.Name, *q.X, *q.Y)
}
```

## [References](#references)

- https://gobyexample.com

- https://www.educative.io/courses/the-way-to-go

- https://medium.com/backend-habit/setting-golang-plugin-on-vscode-for-autocomplete-and-auto-import-30bf5c58138a