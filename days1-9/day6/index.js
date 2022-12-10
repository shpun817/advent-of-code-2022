const fs = require("fs");

class CircularBuffer {
    constructor(capacity) {
        this.capacity = capacity;
        this.buffer = new Array();
    }

    size() {
        return this.buffer.length;
    }

    push(elem) {
        if (this.buffer.length === this.capacity) {
            this.buffer.shift();
        }
        this.buffer.push(elem);
    }

    containsUniqueElements() {
        return new Set(this.buffer).size === this.size();
    }
}

// Return null if not found
function findPosOfUniqueConsecutiveSeq(datastream, sequenceLength) {
    const buffer = new CircularBuffer(sequenceLength);
    let i = 0;
    for (i = 0; i < datastream.length; ++i) {
        buffer.push(datastream[i]);
        if (buffer.size() < sequenceLength) {
            continue;
        }
        if (buffer.containsUniqueElements()) {
            break;
        }
    }
    if (i === datastream.length) {
        return null;
    }
    return i + 1;
}

function main() {
    // const filename = "dummy_input.txt";
    const filename = "input.txt";

    fs.readFile(filename, "ascii", (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        data.split("\n").forEach((ds) => {
            if (ds === "") {
                return;
            }
            const posP1 = findPosOfUniqueConsecutiveSeq(ds, 4);
            if (posP1 === null) {
                console.error("No packet found");
                return;
            }
            console.log(
                "Packet found after",
                posP1,
                "characters are processed.",
            );

            const posP2 = findPosOfUniqueConsecutiveSeq(ds, 14);
            if (posP2 === null) {
                console.error("No message found");
                return;
            }
            console.log(
                "Message found after",
                posP2,
                "characters are processed.",
            );
        });
    });
}

main();
