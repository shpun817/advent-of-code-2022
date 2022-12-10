package assignment

import (
    "strconv"
    "strings"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

type assignment struct {
    from int
    to int
}

func NewFromString(s string) *assignment {
    tokens := strings.Split(s, "-")

    from, err := strconv.Atoi(tokens[0])
    check(err)
    to, err := strconv.Atoi(tokens[1])
    check(err)

    if from > to {
        panic("Illegal from/to")
    }
    
    return &assignment{from: from, to: to}
}

func (self *assignment) IsFullyContainedIn(other *assignment) bool {
    return self.from >= other.from && self.to <= other.to
}

func (self *assignment) OverlapsWith(other *assignment) bool {
    return self.from <= other.to && self.to >= other.from
}
