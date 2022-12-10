import java.util.ArrayDeque
import java.io.File

typealias Stack<T> = ArrayDeque<T>

class CrateStacks(val numStacks: Int) {
    // Array of Char stacks
    private val stacks = Array(numStacks) { _ -> Stack<Char>() }
    
    private fun moveElements(from: Stack<Char>, to: Stack<Char>, quantity: Int) {
        if (quantity > from.size) {
            System.err.println("Trying to move $quantity elements from stack with only $from elements")
            return
        }
        for (i in 1..quantity) {
            to.push(from.pop())
        }
    }
    
    fun insertCrateRow(crateRowStr: String) {
        for (i in 0 until numStacks) {
            val crate = crateRowStr[1 + i * 4]
            if (crate != ' ') {
                stacks[i].push(crate)
            }
        }
    }
    
    fun applyMovementP1(movement: Movement) {
        val from = movement.from - 1;
        val to = movement.to - 1;
        moveElements(stacks[from], stacks[to], movement.quantity)
    }

    fun applyMovementP2(movement: Movement) {
        val from = movement.from - 1;
        val to = movement.to - 1;
        val tempStack = Stack<Char>();
        moveElements(stacks[from], tempStack, movement.quantity)
        moveElements(tempStack, stacks[to], movement.quantity)
    }
    
    fun getTops(): String {
        val tops = StringBuilder()
        for (stack in stacks) {
            if (!stack.isEmpty()) {
                tops.append(stack.peek())
            }
        }
        return tops.toString()
    }
}

class Movement(
    val quantity: Int,
    val from: Int, // Counts from 1
    val to: Int, // Counts from 1
) {}

class CrateStacksBuilder() {
    // Stack of raw strings that are crate rows. Must be inserted from top to bottom.
    private val crateRowsStack = Stack<String>()

    // Must be set to a positive number before building
    private var numStacks = 0
    
    // Will be applied to built object. Must be inserted in chronological order.
    private val movements = mutableListOf<Movement>()
    
    fun parse(line: String) {
        if (line == "") {
            return
        }
        val firstChar = line.trim()[0]
        if (firstChar == '[') {
            parseCrateRow(line)
            return
        }
        if (firstChar.isDigit()) {
            parseNumStacks(line)
            return
        }
        if (firstChar.lowercaseChar() == 'm') {
            parseMovement(line)
            return
        }
        System.err.println("Invalid line: " + line)
    }

    fun parseCrateRow(line: String) {
        crateRowsStack.push(line)
    }
    
    fun parseNumStacks(line: String) {
        numStacks = line.trim().split(" ").last().toInt();
    }
    
    fun parseMovement(line: String) {
        val tokens = line.split(" ")
        val quantity = tokens[1].toInt()
        val from = tokens[3].toInt()
        val to = tokens[5].toInt()
        movements.add(Movement(quantity, from, to))
    }
    
    fun build(part: Int): CrateStacks? {
        if (numStacks <= 0) {
            System.err.println("Invalid numStacks: " + numStacks)
            return null
        }
        val crateStacks = CrateStacks(numStacks)
        for (crateRowStr in crateRowsStack) {
            crateStacks.insertCrateRow(crateRowStr)
        }
        for (movement in movements) {
            if (part == 1) {
                crateStacks.applyMovementP1(movement)
            } else { // Part 2
                crateStacks.applyMovementP2(movement)
            }
        }
        return crateStacks
    }
}

fun main() {
    // val inputFileName = "dummy_input.txt"
    val inputFileName = "input.txt"

    val crateStacksBuilder = CrateStacksBuilder()
    
    File(inputFileName).forEachLine() { crateStacksBuilder.parse(it) }
    
    val crateStacksP1 = crateStacksBuilder.build(1)
    println("Part 1: " + crateStacksP1?.getTops())
    
    val crateStacksP2 = crateStacksBuilder.build(2)
    println("Part 2: " + crateStacksP2?.getTops())
}
