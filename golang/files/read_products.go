package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type Book struct {
	title string
	price float64
	quantity int
}

func (b * Book) String() {
	fmt.Printf("%s %f %d", b.title, b.price, b.quantity)
}

func main() {
	fName := "products.txt"

	var books []Book

    f, err := os.Open(fName)
    
	if err != nil {
        fmt.Fprintf(os.Stderr, "%v, Can't open %s: error: %s\n", os.Args[0], fName, err)
        os.Exit(1)
    }

	defer f.Close()

	reader := bufio.NewReader(f)

    for {
        line, err := reader.ReadString('\n')
        
		if err == io.EOF {
            break
        }

		// Remember to remove trailing newline which ReadString() will include!
		line = line[:len(line) -1]

		fields := strings.Split(line, ";")

		//fmt.Printf("Fields: %s\n", fields)
		
		title := fields[0]
		
		var price float64
		var quantity int

		if price, err = strconv.ParseFloat(fields[1], 64); err != nil {
			fmt.Println("Error parsing price")
		}

		if quantity, err = strconv.Atoi(fields[2]); err != nil {
			fmt.Println("Error parsing quantity")
		}

		book := Book{
			title: title,
			price: price,
			quantity: quantity,
		}
		books = append(books, book)

	}

	for _, book := range books {
		fmt.Println(book)
	}


}