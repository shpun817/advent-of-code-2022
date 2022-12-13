# How to run

```bash

$ clang main1.c && ./a.out
$ clang main2.c && ./a.out

```

# Pseudocode

## Construct the graph

Read file into 2d array of char.

Convert 2d array of char into 2d array of `Node { elevation: int, outNeighbors: Node*[], parent: Node*, seen: bool }`.

For each node in the 2d array, consider the 4-neighbors of the node, and add the neighbor to `node.outNeighbors` if reachable (determined by `node.elevation`)

## Find length of shortest path from S to E

Shortest path can be found with BFS.

```

countPath(node) {

    if node.parent == NULL {
        return 0
    }
    return 1 + countPath(node.parent)

}


BFS(graph, source, destination) {

    queue = Queue<Node*>([source])
    source.seen = true

    while (!queue.isEmpty()) {
        current = queue.dequeue()
        for neighbor in current.outNeighbors {
            if neighbor.seen {
                continue
            }
            neighbor.seen = true
            neighbor.parent = current
            if neighbor == destination {
                return countPath(destination)
            }
            queue.enqueue(neighbor)
        }
    }

}
```
