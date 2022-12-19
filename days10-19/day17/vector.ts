class Vector {
    x: number;
    y: number;

    constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }

    isValid(): boolean {
        return (
            0 <= this.x && this.x <= 6 &&
            0 <= this.y
        );
    }

    plus(other: Vector): Vector {
        return new Vector(this.x + other.x, this.y + other.y);
    }
    
    minus(other: Vector): Vector {
        return new Vector(this.x - other.x, this.y - other.y);
    }

    equals(other: Vector): boolean {
        return this.x === other.x && this.y === other.y;
    }
}

const Direction = {
    Up: new Vector(0, 1),
    Down: new Vector(0, -1),
    Left: new Vector(-1, 0),
    Right: new Vector(1, 0),
};

export default Vector;
export { Direction };
