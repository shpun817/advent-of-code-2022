import Vector from "./vector.ts";

abstract class Rock {
    origin: Vector;

    constructor(origin: Vector) {
        this.origin = origin;
    }

    isValid(): boolean {
        return this.pointOffsets().every(p =>
            this.origin.plus(p).isValid()
        );
    }

    collidesWith(other: Rock): boolean {
        const points = this.pointOffsets().map(p => this.origin.plus(p));
        const otherPoints = other.pointOffsets().map(p => other.origin.plus(p));

        return points.some(p =>
            otherPoints.some(op => p.equals(op))
        );
    }

    highestYCoord(): number {
        const highestYOffset = Math.max(...this.pointOffsets().map(p => p.y)) + 1;
        return this.origin.y + highestYOffset;
    }

    abstract pointOffsets(): Vector[];
    abstract move(direction: Vector): Rock;
}

class HorizontalRock extends Rock {
    static PointOffsets: Vector[] = [
        new Vector(0, 0),
        new Vector(1, 0),
        new Vector(2, 0),
        new Vector(3, 0),
    ];

    pointOffsets(): Vector[] {
        return HorizontalRock.PointOffsets;
    }

    move(direction: Vector): Rock {
        return new HorizontalRock(this.origin.plus(direction));
    }
}

class CrossRock extends Rock {
    static PointOffsets: Vector[] = [
        new Vector(1, 0),
        new Vector(0, 1),
        new Vector(1, 1),
        new Vector(2, 1),
        new Vector(1, 2),
    ];

    pointOffsets(): Vector[] {
        return CrossRock.PointOffsets;
    }

    move(direction: Vector): Rock {
        return new CrossRock(this.origin.plus(direction));
    }
}

class LShapedRock extends Rock {
    static PointOffsets: Vector[] = [
        new Vector(0, 0),
        new Vector(1, 0),
        new Vector(2, 0),
        new Vector(2, 1),
        new Vector(2, 2),
    ];

    pointOffsets(): Vector[] {
        return LShapedRock.PointOffsets;
    }

    move(direction: Vector): Rock {
        return new LShapedRock(this.origin.plus(direction));
    }
}

class VerticalRock extends Rock {
    static PointOffsets: Vector[] = [
        new Vector(0, 0),
        new Vector(0, 1),
        new Vector(0, 2),
        new Vector(0, 3),
    ];

    pointOffsets(): Vector[] {
        return VerticalRock.PointOffsets;
    }

    move(direction: Vector): Rock {
        return new VerticalRock(this.origin.plus(direction));
    }
}

class BlockRock extends Rock {
    static PointOffsets: Vector[] = [
        new Vector(0, 0),
        new Vector(1, 0),
        new Vector(0, 1),
        new Vector(1, 1),
    ];

    pointOffsets(): Vector[] {
        return BlockRock.PointOffsets;
    }

    move(direction: Vector): Rock {
        return new BlockRock(this.origin.plus(direction));
    }
}

interface RockFactory {
    (origin: Vector): Rock,
}

const RockFactories: RockFactory[] = [
    (o) => new HorizontalRock(o),
    (o) => new CrossRock(o),
    (o) => new LShapedRock(o),
    (o) => new VerticalRock(o),
    (o) => new BlockRock(o),
];

export default Rock;
export type { RockFactory };
export { RockFactories };
