require_relative 'monkey'
require_relative 'setup'

def main()
    # setUpFunc = lambda { setUpDummy() }
    setUpFunc = lambda { setUp() }

    monkeys = setUpFunc.call()
    puts "We are dealing with %d monkeys here!" % [monkeys.numMonkeys()]
    for i in 1..20
        monkeys.startRound(part1 = true)
    end
    puts "Part 1: %d" % [monkeys.getMonkeyBusiness()]

    monkeys = setUpFunc.call()
    for i in 1..10000
        monkeys.startRound(part1 = false)
    end
    
    puts "Part 2: %d" % [monkeys.getMonkeyBusiness()]
end

main()
