package main

import (
    "day4/assignment"
    "day4/input"
    "fmt"
    "strings"
)


func splitByComma(line string) (string, string) {
    tokens := strings.Split(line, ",")
    return tokens[0], tokens[1]
}

func main() {
    // lines := input.ReadFileAsStringSlice("dummy_input.txt")
    lines := input.ReadFileAsStringSlice("input.txt")
    p1Count := 0
    p2Count := 0

    for _, line := range lines {
        asm1_str, asm2_str := splitByComma(line)

        asm1 := assignment.NewFromString(asm1_str)
        asm2 := assignment.NewFromString(asm2_str)

        if asm1.IsFullyContainedIn(asm2) ||
           asm2.IsFullyContainedIn(asm1) {
            p1Count += 1
        }

        if asm1.OverlapsWith(asm2) {
            p2Count += 1
        }
    }
    fmt.Printf("Part 1: %d\n", p1Count)
    fmt.Printf("Part 2: %d\n", p2Count)
}
