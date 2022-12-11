require_relative 'monkey'

def setUpDummy()
    group = MonkeyGroup.new()
    group.addMonkey(
        Monkey.new(
          [79, 98],
          lambda { |old| old * 19 },
          lambda { |val| val % 23 == 0 },
          2,
          3
    ))
    group.addMonkey(
        Monkey.new(
          [54, 65, 75, 74],
          lambda { |old| old + 6 },
          lambda { |val| val % 19 == 0 },
          2,
          0
    ))
    group.addMonkey(
        Monkey.new(
          [79, 60, 97],
          lambda { |old| old * old },
          lambda { |val| val % 13 == 0 },
          1,
          3
    ))
    group.addMonkey(
        Monkey.new(
          [74],
          lambda { |old| old + 3 },
          lambda { |val| val % 17 == 0 },
          0,
          1
    ))
    return group
end

def setUp()
    group = MonkeyGroup.new()
    group.addMonkey(
        Monkey.new(
          [77, 69, 76, 77, 50, 58],
          lambda { |old| old * 11 },
          lambda { |val| val % 5 == 0 },
          1,
          5
    ))
    group.addMonkey(
        Monkey.new(
          [75, 70, 82, 83, 96, 64, 62],
          lambda { |old| old + 8 },
          lambda { |val| val % 17 == 0 },
          5,
          6
    ))
    group.addMonkey(
        Monkey.new(
          [53],
          lambda { |old| old * 3 },
          lambda { |val| val % 2 == 0 },
          0,
          7
    ))
    group.addMonkey(
        Monkey.new(
          [85, 64, 93, 64, 99],
          lambda { |old| old + 4 },
          lambda { |val| val % 7 == 0 },
          7,
          2
    ))
    group.addMonkey(
        Monkey.new(
          [61, 92, 71],
          lambda { |old| old * old },
          lambda { |val| val % 3 == 0 },
          2,
          3
    ))
    group.addMonkey(
        Monkey.new(
          [79, 73, 50, 90],
          lambda { |old| old + 2 },
          lambda { |val| val % 11 == 0 },
          4,
          6
    ))
    group.addMonkey(
        Monkey.new(
          [50, 89],
          lambda { |old| old + 3 },
          lambda { |val| val % 13 == 0 },
          4,
          3
    ))
    group.addMonkey(
        Monkey.new(
          [83, 56, 64, 58, 93, 91, 56, 65],
          lambda { |old| old + 5 },
          lambda { |val| val % 19 == 0 },
          1,
          0
    ))
    return group
end
