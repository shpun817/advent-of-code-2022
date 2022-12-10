package input

import (
    "bufio"
    "os"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func ReadFileAsStringSlice(filename string) []string {
    file, err := os.Open(filename)
    check(err)
    defer file.Close()

    lines := []string{}

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }
    check(scanner.Err())

    return lines
}
