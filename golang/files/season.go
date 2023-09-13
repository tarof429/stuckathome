package main

import (
	"fmt"
)

func season(month int) string {

  switch(month) {
    case 1, 2, 12:
      return "Winter"
    case 3, 4, 5:
      return "Spring"
    case 6, 7, 8:
      return "Summer"
    case 9, 10, 11:
      return "Autumn"
    default: 
      return "Season unknown"
  }

}

func main() {
	fmt.Println(season(0))
}