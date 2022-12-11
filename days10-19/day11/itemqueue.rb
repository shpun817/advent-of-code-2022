class ItemQueue
    def initialize(list = [])
        @items = []
        for item in list do
            self.enqueue(item)
        end
    end
    
    def enqueue(item)
        @items.unshift item
    end
    
    def dequeue
        return @items.pop()
    end
    
    def isEmpty
        return @items.length == 0
    end
    
    def printReversed
        print @items.reverse()
    end
end
