package main

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
