package main

import (
	"fmt"
	"strconv"
)

const LIMIT = 4 // DONOT CHANGE IT!

type Stack struct {
	ix   int // first free position, so data[ix] == 0
	data [LIMIT]int
}

func (st *Stack) Push(n int) {

	if st.ix < LIMIT {
		fmt.Printf("Pushing %d\n", n)
		st.data[st.ix] = n
		st.ix += 1
	}
	
	return 
}

func (st *Stack) Pop() int {

	if st.ix > 0 {
		st.ix -= 1
		element := st.data[st.ix]

		return element

	} 
	return -1
}

func (st Stack) String() string {
	var ret string
	
	for i := 0; i < st.ix; i++ {
		ret += "[" + strconv.Itoa(i) + ":" + strconv.Itoa(st.data[i]) + "]"
	}
	return ret
}

func main() {
	var stack Stack

	stack.Push(1)
	stack.Push(2)
	stack.Push(0)
	fmt.Println(stack)

	stack.Pop()
	fmt.Println(stack)

	stack.Pop()
	fmt.Println(stack)

	stack.Pop()
	fmt.Println(stack)

}