package main

import "fmt"

type TZ int

const (
    HOUR TZ = 60 * 60
    UTC  TZ = 0 * HOUR
    EST  TZ = -5 * HOUR
    CST  TZ = -6 * HOUR  
)

var timeZones = map[TZ]string { 
                                    UTC:"Universal Greenwich time", 
                                EST:"Eastern Standard time",
                                    CST:"Central Standard time", 
                                }

func (tz TZ) String() string { 
    for name, zone := range timeZones {
        if tz == name {
            return zone
        }
    }
    return ""
}

func main() {

	fmt.Println(EST)       // Easter Standard time   // Print knows about method String() of type TZ
    fmt.Println(0 * HOUR) // 0 * 60 * 60 = 0, so Universal Greewich time
    fmt.Println(-6 * HOUR)  // Central Standard time
}