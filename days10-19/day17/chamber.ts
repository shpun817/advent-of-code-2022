import RockBuffer from "./rockbuffer.ts";
import Rock, { RockFactory } from "./rock.ts";
import Vector, { Direction } from "./vector.ts";

import ManyKeysMap from "npm:many-keys-map";

type HistoryEntry = [
    number, // Rock type
    number, // Starting at which jet index
    number, // End origin.x - Start origin.x
    number, // End origin.y - Start origin.y
];

interface DependentVariables {
    numRocks: number,
    towerHeight: number,
}

class Chamber {
    rockBuffer: RockBuffer;
    jetPattern: string;
    jetIndex: number;
    numRocks: number;
    towerHeight: number;
    history: ManyKeysMap<HistoryEntry, DependentVariables[]>;
    deltaNumRocks: number;
    deltaTowerHeight: number;
    numRocksToTowerHeight: Map<number, number>;

    constructor(rocksToStore: number, jetPattern: string) {
        this.rockBuffer = new RockBuffer(rocksToStore);
        this.jetPattern = jetPattern;
        this.jetIndex = 0;
        this.numRocks = 0;
        this.towerHeight = 0;
        this.history = new ManyKeysMap();
        this.deltaNumRocks = 0;
        this.deltaTowerHeight = 0;
        this.numRocksToTowerHeight = new Map();
    }

    // interface
    addNewRock(rockFactory: RockFactory, rockType: number): void {
        const startOrigin = this.getRockPlacementOrigin();
        const startJetIndex = this.jetIndex;

        let rock = rockFactory(startOrigin);

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

        const originDelta = rock.origin.minus(startOrigin);
        const historyEntry: HistoryEntry = [
            rockType,
            startJetIndex,
            originDelta.x,
            originDelta.y,
        ];

        this.rockBuffer.push(rock);
        this.numRocks += 1;
        this.towerHeight = Math.max(this.towerHeight, rock.highestYCoord());

        this.numRocksToTowerHeight.set(this.numRocks, this.towerHeight);

        const dependentVariables: DependentVariables = {
            numRocks: this.numRocks,
            towerHeight: this.towerHeight,
        };
        if (!this.history.has(historyEntry)) {
            this.history.set(historyEntry, []);
        }
        const results = this.history.get(historyEntry);
        results?.push(dependentVariables);
        if (results !== undefined && results.length > 1) {
            this.deltaNumRocks = results[1].numRocks - results[0].numRocks;
            this.deltaTowerHeight = results[1].towerHeight - results[0].towerHeight;
        }
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
