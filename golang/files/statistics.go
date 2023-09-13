package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"sort"
	"strconv"
	"strings"
)

type statistics struct {
	numbers []float64
	mean float64
	median float64
}

const form = `<html><body><form action="/" method="POST">
<h1>Statistics</h1>
<h5>Compute base statistics for a given list of numbers</h5>
<label for="numbers">Numbers (comma or space-separated):</label><br>
<input type="text" name="numbers" size="30"><br />
<input type="submit" value="Calculate">
</form></html></body>`

const error = `<p class="error">%s</p>`
var pageTop = ""
var pageBottom = ""

// Define a root handler for requests to function homePage, and start the webserver combined with error-handling
func main() {
	logger := log.New(os.Stdout, "logger ", log.LstdFlags|log.Lshortfile)
	
	http.HandleFunc("/", homePage)

	logger.Fatal(http.ListenAndServe(":3000", nil))
}

// Write an HTML header, parse the form, write form to writer and make request for numbers
func homePage(writer http.ResponseWriter, request *http.Request) {

	// write your code here
	writer.Header().Set("Content-Type", "text/html")

	switch request.Method {
	case "GET":
		fmt.Fprintf(writer, form)
	case "POST":
		ret, message, errorHappened := processRequest(request)

		if errorHappened {
			fmt.Fprintf(writer, message)
		} else {
			stats := getStats(ret)
			fmt.Println(stats)
			
			fmt.Fprintf(writer, formatStats(stats))

		}
	}
}

// Capture the numbers from the request, and format the data and check for errors
func processRequest(request *http.Request) ([]float64, string, bool) {
	// write your code here
	input := request.FormValue("numbers")

	input = strings.ReplaceAll(input, ",", " ")

	anumbers := strings.Split(input, " ")

	var ret []float64

	errorHappened := false
	message := ""

	for _, anum := range anumbers {
		i, err := strconv.Atoi(anum)

		if err != nil {
			errorHappened = true
			message = fmt.Sprintf("An error happened: %v", err.Error())
			break
		} else {
			ret = append(ret, float64(i))
		}
	}

	fmt.Println(ret)

	return ret, message, errorHappened
}

// sort the values to get mean and median
func getStats(numbers []float64) (stats statistics) {
	stats.mean = sum(numbers) / float64(len(numbers))
	stats.numbers = numbers
	stats.median = median(numbers)

	return stats
}

// seperate function to calculate the sum for mean
func sum(numbers []float64) (total float64) {

	for num := range numbers {
		total += float64(num)
	}

	return total
}

// seperate function to calculate the median
func median(numbers []float64) float64 {

	sort.Float64s(numbers) 
	
	return numbers[len(numbers) / 2]
}

func formatStats(stats statistics) string {
	return fmt.Sprintf(`<table border="1">
	<tr><th colspan="2">Results</th></tr>
	<tr><td>Numbers</td><td>%v</td></tr>
	<tr><td>Count</td><td>%d</td></tr>
	<tr><td>Mean</td><td>%f</td></tr>
	<tr><td>Median</td><td>%f</td></tr>
	</table>`, stats.numbers, len(stats.numbers), stats.mean, stats.median)
}
