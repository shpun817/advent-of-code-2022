import Rock from "./rock.ts";

class RockBuffer {
    capacity: number;
    buffer: Rock[];

    constructor(capacity: number) {
        this.capacity = capacity;
        this.buffer = [];
    }

    size() {
        return this.buffer.length;
    }

    push(elem: Rock) {
        if (this.buffer.length === this.capacity) {
            this.buffer.shift();
        }
        this.buffer.push(elem);
    }

    rocks() {
        return this.buffer;
    }
}

export default RockBuffer;
