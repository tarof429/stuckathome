package main

import (
	"encoding/gob"
	"fmt"
	"os"
)
type Address struct {
	Type             string
	City             string
	Country          string
}

type VCard struct {
	FirstName	string
	LastName	string
	Addresses	[]*Address
	Remark		string
}


func main() {
	var vcard VCard

	file, _ := os.Open("vcard.gob")
	
	defer file.Close()

	decoder := gob.NewDecoder(file)

	err := decoder.Decode(&vcard)

	if err != nil {
		fmt.Println(vcard)
	}
}