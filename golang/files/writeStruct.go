package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

const (
	DATA_FILE = "students.json"
)

type Students struct {
	Students   []Student `json:"Students"`
	cpuUsed    int
	memoryUsed int
}

type Student struct {
	FirstName string
	LastName  string
}

func (m *Students) add(student Student) {
	m.Students = append(m.Students, student)
}

func (m *Students) write() bool {
	data, err := json.MarshalIndent(m, "", "\t")

	if err != nil {
		fmt.Println("Error when writing data")
		return false
	}

	err = os.WriteFile(
		filepath.Join(".", DATA_FILE), data, 0644)

	if err != nil {
		fmt.Println(err.Error())
	}

	return err != nil
}

// func (m *Students) load() bool {
// 	data, err := os.ReadFile(
// 		filepath.Join(".", DATA_FILE))

// 	if err != nil {
// 		fmt.Println("Error while loading file")
// 		return false
// 	}

// 	err = json.Unmarshal(data, &m)

// 	return err != nil
// }

func main() {
	m := Students{}
	var vm Student

	vm = Student{FirstName: "John", LastName: "Doe"}
	// data, err := json.MarshalIndent(vm, "", "\t")
	// if err != nil {
	// 	fmt.Println("Error when marshalling")
	// }
	// err = os.WriteFile(
	// 	filepath.Join(".", "john.json"), data, 0644)
	m.add(vm)

	vm = Student{FirstName: "Mary", LastName: "Jane"}
	// data, err = json.MarshalIndent(vm, "", "\t")
	// if err != nil {
	// 	fmt.Println("Error when marshalling")
	// }
	// err = os.WriteFile(
	// 	filepath.Join(".", "mary.json"), data, 0644)
	m.add(vm)

	vm = Student{FirstName: "Adam", LastName: "Apple"}
	// data, err = json.MarshalIndent(vm, "", "\t")
	// if err != nil {
	// 	fmt.Println("Error when marshalling")
	// }
	// err = os.WriteFile(
	// 	filepath.Join(".", "adam.json"), data, 0644)
	m.add(vm)

	// for _, student := range m.Students {
	// 	fmt.Println(student)
	// }

	m.write()

}
