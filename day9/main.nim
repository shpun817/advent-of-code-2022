import std/sets
import std/strformat
import std/sugar

import strutils

type
  Vec2 = object
    x, y: int

proc toString(self: Vec2): string =
    result = fmt"({self.x}, {self.y})"

proc add(self, other: Vec2): Vec2 =
    result = Vec2(x: self.x + other.x, y: self.y + other.y)
    
proc isTouching(self, other: Vec2): bool =
    result = max(abs(self.x - other.x), abs(self.y - other.y)) <= 1
    
proc sign(n: int): int =
    if n < 0:
        result = -1
    elif n > 0:
        result = 1
    else:
        result = 0
    
proc approach(self, other: Vec2): Vec2 =
    let delta = Vec2(x: sign(other.x - self.x), y: sign(other.y - self.y))
    result = self.add(delta)

# Directions - origin at bottom-left
proc UP(): Vec2 =
    result = Vec2(x: 0, y: 1)

proc DOWN(): Vec2 =
    result = Vec2(x: 0, y: -1)

proc LEFT(): Vec2 =
    result = Vec2(x: -1, y: 0)

proc RIGHT(): Vec2 =
    result = Vec2(x: 1, y: 0)
    
type
  Motion = object
    direction: Vec2
    steps: int
    
proc parseMotion(line: string): Motion =
    let tokens = line.split(" ")
    let steps = parseInt(tokens[1])
    result = case tokens[0]:
        of "U": Motion(direction: UP(), steps: steps)
        of "D": Motion(direction: DOWN(), steps: steps)
        of "L": Motion(direction: LEFT(), steps: steps)
        of "R": Motion(direction: RIGHT(), steps: steps)
        else:
            echo "Invalid motion input: " & line
            Motion()
            
proc solveP1(motions: seq[Motion]): int =
    var head, tail = Vec2()
    var visited = toHashSet([tail.toString()])
    
    for motion in motions:
        for _ in countup(1, motion.steps):
            head = head.add(motion.direction)
            if not tail.isTouching(head):
                tail = tail.approach(head)
                visited.incl(tail.toString())
                
    result = visited.len()

proc main(filename: string) =
    let inputFile = readFile(filename)

    let motions = collect:
        for line in inputFile.split("\n"):
            if line != "": parseMotion(line)

    echo fmt"Part 1: {solveP1(motions)}"

main("dummy_input.txt")
# main("input.txt")
