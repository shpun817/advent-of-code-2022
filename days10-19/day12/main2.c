#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Problem-specific constants
#define MAX_NUM_NEIGHBORS 4

// const char* filename = "dummy_input.txt";
// #define WIDTH 8
// #define HEIGHT 5

const char* filename = "input.txt";
#define WIDTH 67
#define HEIGHT 41

// ================================ Node ================================

typedef struct Node_ {
    int elevation;
    struct Node_* outNeighbors[MAX_NUM_NEIGHBORS];
    int numNeighbors;
    struct Node_* parent;
    bool seen;
} Node;

void makeNode(Node* node, int elevation) {
    node->elevation = elevation;
    for (size_t i = 0; i < MAX_NUM_NEIGHBORS; ++i) {
        node->outNeighbors[i] = NULL;
    }
    node->numNeighbors = 0;
    node->parent = NULL;
    node->seen = false;
}

bool canReachNode(Node* self, Node* other) {
    return other->elevation - self->elevation <= 1;
}

void addNeighbor(Node* self, Node* neighbor) {
    self->outNeighbors[self->numNeighbors] = neighbor;

    if (++self->numNeighbors > MAX_NUM_NEIGHBORS) {
        perror("Too many neighbors");
        exit(EXIT_FAILURE);
    }
}

void addNeighborIfReachable(Node* self, Node* other) {
    if (canReachNode(self, other)) {
        addNeighbor(self, other);
    }
}

int countPath(Node* node) {
    if (node->parent == NULL) {
        return 0;
    }
    return 1 + countPath(node->parent);
}

void resetNodes(Node** nodes) {
    for (size_t i = 0; i < HEIGHT; ++i) {
        for (size_t j = 0; j < WIDTH; ++j) {
            Node* node = &nodes[i][j];
            node->parent = NULL;
            node->seen = false;
        }
    }
}

// ================================ Queue ================================

typedef struct {
    Node* nodes[WIDTH * HEIGHT]; // Maximum size necessary
    size_t head; // Push to head
    size_t tail; // Pop from tail
} Queue;

void makeQueue(Queue* queue) {
    for (size_t i = 0; i < WIDTH * HEIGHT; ++i) {
        queue->nodes[i] = NULL;
    }
    queue->head = 0;
    queue->tail = 0;
}

void enqueue(Queue* queue, Node* node) {
    queue->nodes[queue->head] = node;
    ++queue->head;
}

Node* dequeue(Queue* queue) {
    return queue->nodes[queue->tail++];
}

bool isEmpty(Queue* queue) {
    return queue->head == queue->tail;
}

// ================================ BFS  ================================

int findLengthOfShortestPath(Node** nodes, Node* source, Node* destination) {
    if (source == NULL) {
        perror("Source is NULL");
        exit(EXIT_FAILURE);
    }
    if (destination == NULL) {
        perror("Destination is NULL");
        exit(EXIT_FAILURE);
    }
    Queue* queue = malloc(sizeof(Queue));
    makeQueue(queue);
    enqueue(queue, source);
    source->seen = true;
    
    while (!isEmpty(queue)) {
        Node* curr = dequeue(queue);
        for (size_t n = 0; n < curr->numNeighbors; ++n) {
            Node* neighbor = curr->outNeighbors[n];
            if (neighbor->seen) {
                continue;
            }
            neighbor->seen = true;
            neighbor->parent = curr;
            if (neighbor == destination) {
                return countPath(destination);
            }
            enqueue(queue, neighbor);
        }
    }
    
    free(queue);
    
    return WIDTH * HEIGHT;
}

// ================================ Utils ================================

void readFileIntoLines(char** lines, const char* filename) {
    FILE* fp = fopen(filename, "r");
    if (fp == NULL) {
        perror("Cannot open file");
        exit(EXIT_FAILURE);
    }
    for (size_t i = 0; i < HEIGHT; ++i) {
        char* line = NULL;
        size_t len;
        if (getline(&line, &len, fp) != WIDTH + 1) { // newline included
            perror("Detected line with incorrect number of characters");
            exit(EXIT_FAILURE);
        }
        strncpy(lines[i], line, WIDTH);
        lines[i][WIDTH] = '\0';
        free(line);
    }
    fclose(fp);
}

int charToElevation(char c) {
    if (c == 'S') {
        return charToElevation('a');
    }
    if (c == 'E') {
        return charToElevation('z');
    }
    if ('a' <= c && c <= 'z') {
        return c - 'a';
    }
    exit(EXIT_FAILURE);
}

// ================================ Main ================================

int main() {
    char** lines = malloc(sizeof(char*) * HEIGHT);
    for (size_t i = 0; i < HEIGHT; ++i) {
        lines[i] = malloc(sizeof(char) * (WIDTH + 1));
    }
    readFileIntoLines(lines, filename);

    // Initialize nodes
    Queue* sources = malloc(sizeof(Queue));
    Node* destination = NULL;
    Node** nodes = malloc(sizeof(Node*) * HEIGHT);
    for (size_t i = 0; i < HEIGHT; ++i) {
        nodes[i] = malloc(sizeof(Node) * WIDTH);
        for (size_t j = 0; j < WIDTH; ++j) {
            char c = lines[i][j];
            int elevation = charToElevation(c);
            if (elevation == 0) {
                enqueue(sources, &nodes[i][j]);
            } else if (c == 'E') {
                destination = &nodes[i][j];
            }
            makeNode(&nodes[i][j], elevation);
        }
    }

    // Construct graph
    for (size_t i = 0; i < HEIGHT; ++i) {
        for (size_t j = 0; j < WIDTH; ++j) {
            Node* curr = &nodes[i][j];
            if (i > 0) addNeighborIfReachable(curr, &nodes[i-1][j]);
            if (j > 0) addNeighborIfReachable(curr, &nodes[i][j-1]);
            if (i < HEIGHT-1) addNeighborIfReachable(curr, &nodes[i+1][j]);
            if (j < WIDTH-1) addNeighborIfReachable(curr, &nodes[i][j+1]);
        }
    }
    
    int minLength = WIDTH * HEIGHT;
    int i = 0;
    while (!isEmpty(sources)) {
        resetNodes(nodes);
        Node* source = dequeue(sources);
        int length = findLengthOfShortestPath(nodes, source, destination);
        if (length < minLength) {
            minLength = length;
        }
    }
    
    printf("Part 2: %d\n", minLength);
    
    // Clean up
    for (size_t i = 0; i < HEIGHT; ++i) {
        free(nodes[i]);
        free(lines[i]);
    }
    free(nodes);
    free(lines);
    return 0;
}
