require_relative 'itemqueue'

class Monkey
    attr_reader :inspectCount

    def initialize(startItems, operationFunc, testFunc, throwToTrue, throwToFalse)
        @items = ItemQueue.new(startItems)
        @operationFunc = operationFunc
        @testFunc = testFunc
        @throwToTrue = throwToTrue
        @throwToFalse = throwToFalse
        
        @inspectCount = 0
    end
    
    def hasItem
        return !@items.isEmpty()
    end
    
    def inspectNextItem(mitigation, part1 = true, verbose = false)
        @inspectCount += 1

        item = @items.dequeue()
        if verbose
            puts "Monkey inspects an item with a worry level of %d." % [item]
        end
        item = @operationFunc.call(item) # Feeling worried!
        if verbose
            puts "\tWorry level is ... to %d." % [item]
        end
        if part1
            item = item / 3 # Phew, it's not damaged
        else
            item = item % mitigation # Just so that the number doesn't get too large, does not affect the tests of divisibility
        end
        if verbose
            puts "\tMonkey gets bored with item. Worry level is divided by 3 to %d." % [item]
        end
        throwTarget = @testFunc.call(item) ? @throwToTrue : @throwToFalse
        if verbose
            puts "\tItem with worry level %d is thrown to monkey %d." % [item, throwTarget]
        end
        return InspectionResult.new(item, throwTarget)
    end
    
    def receiveItem(item)
        @items.enqueue(item)
    end
    
    def printAllItems
        @items.printReversed()
    end
end

class InspectionResult
    attr_reader :item
    attr_reader :throwTarget

    def initialize(item, throwTarget)
        @item = item
        @throwTarget = throwTarget
    end
end

class MonkeyGroup
    def initialize(mitigation)
        @monkeys = []
        @mitigation = mitigation
    end
    
    def numMonkeys
        return @monkeys.length
    end
    
    def addMonkey(monkey)
        @monkeys.push(monkey)
    end
    
    def startRound(part1, verbose = false)
        for monkey in @monkeys do
            while monkey.hasItem do
                result = monkey.inspectNextItem(@mitigation, part1)
                @monkeys[result.throwTarget].receiveItem(result.item)
            end
        end
        if verbose
            self.printAllMonkeysItems()
        end
    end
    
    def printAllMonkeysItems
        for monkey, i in @monkeys.each_with_index do
            puts "Monkey %d:" % [i]
            monkey.printAllItems()
            puts ""
        end
        puts ""
    end
    
    def getMonkeyBusiness
        inspectCounts = @monkeys.map { |m| m.inspectCount }
        inspectCounts = inspectCounts.sort().reverse()
        return inspectCounts[0] * inspectCounts[1]
    end
end
