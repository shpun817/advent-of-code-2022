require_relative 'monkey'
require_relative 'setup'

def main()
    # monkeys = setUpDummy()
    monkeys = setUp()

    puts "We are dealing with %d monkeys here!" % [monkeys.numMonkeys()]
    for i in 1..20
        monkeys.startRound()
    end
    
    puts "Part 1: %d" % [monkeys.solveP1()]
end

main()
