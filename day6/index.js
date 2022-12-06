const fs = require("fs");

const CircularBuffer = require("mnemonist/circular-buffer");

function findPosOfFirstStartOfPacketMarker(datastream, sequenceLength = 4) {
    const buffer = new CircularBuffer(Array, sequenceLength);
    let i = 0;
    for (i = 0; i < datastream.length; ++i) {
        buffer.push(datastream[i]);
        if (buffer.size < sequenceLength) {
            continue;
        }
        if (containsUniqueElements(buffer)) {
            break;
        }
    }
    if (i === datastream.length) {
        return null;
    }
    return i + 1;
}

function containsUniqueElements(buffer) {
    const uniqueElements = new Set(buffer);
    return uniqueElements.size === buffer.size;
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
            const pos = findPosOfFirstStartOfPacketMarker(ds);
            if (pos === null) {
                console.error("No packet found");
                return;
            }
            console.log("Packet found after", pos, "characters are processed.");
        });
    });
}

main();
