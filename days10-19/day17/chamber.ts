import RockBuffer from "./rockbuffer.ts";
import Rock, { RockFactory } from "./rock.ts";
import Vector, { Direction } from "./vector.ts";

class Chamber {
    rockBuffer: RockBuffer;
    jetPattern: string;
    jetIndex: number;
    towerHeight: number;

    constructor(rocksToStore: number, jetPattern: string) {
        this.rockBuffer = new RockBuffer(rocksToStore);
        this.jetPattern = jetPattern;
        this.jetIndex = 0;
        this.towerHeight = 0;
    }

    // interface
    addNewRock(rockFactory: RockFactory): void {
        let rock = rockFactory(this.getRockPlacementOrigin());

        let falling = false; // Alternating
        while (true) {
            const dir = falling? Direction.Down : this.getNextJetDirection();
            const movedRock = rock.move(dir);
            if (!movedRock.isValid() || this.isCollidingWithExistingRocks(movedRock)) {
                if (falling) {
                    break; // Finished (settled)
                } else {
                    falling = true;
                    continue; // Movement does not happen
                }
            }
            rock = movedRock;
            falling = !falling;
        }

        this.rockBuffer.push(rock);
        this.towerHeight = Math.max(this.towerHeight, rock.highestYCoord());
    }

    // helpers
    getRockPlacementOrigin(): Vector {
        return new Vector(2, this.towerHeight + 3);
    }

    getNextJetDirection(): Vector {
        const jet = this.jetPattern.charAt(this.jetIndex);
        this.jetIndex = (++this.jetIndex) % this.jetPattern.length;
        if (jet === '<') {
            return Direction.Left;
        } else if (jet === '>') {
            return Direction.Right;
        } else {
            console.error("Unknown jet:", jet);
            return new Vector(0, 0);
        }
    }

    isCollidingWithExistingRocks(rock: Rock): boolean {
        return this.rockBuffer.rocks().some(r => rock.collidesWith(r));
    }
}

export default Chamber;
