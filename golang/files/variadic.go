package main

import (
	"fmt"
	"math"
)

func main() {
	ret := task1([]int{78, 34, 643, 12, 90, 492, 13, 2})
	fmt.Println(ret)
	ret = task2([]int{78, 34, 643, 12, 90, 492, 13, 2})
	fmt.Println(ret)

}

func task1(sl []int) (n int) {
    n = math.MinInt32
    for _, v := range sl {
        if v > n {
            n = v
        }
    }
    return 
}

func task2(sl [] int) (n int) { 
    n = math.MaxInt32  
    for _, v := range sl {
        if v < n {
            n = v
        }
    }
    return 
}