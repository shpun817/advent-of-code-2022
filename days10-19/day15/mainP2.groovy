import groovy.transform.EqualsAndHashCode

@EqualsAndHashCode
class Point {
    int x
    int y
    
    Point(int x, int y) {
        this.x = x
        this.y = y
    }
    
    Point(int v) {
        this.x = v;
        this.y = v;
    }

    def sign(int x) {
        if (x < 0) return -1
        if (x > 0) return 1
        return 0    
    }
    
    def getDeltaTowards(Point other) {
        def diff = other.minus(this)
        return new Point(sign(diff.x), sign(diff.y))
    }
    
    def plus(Point other) {
        return new Point(this.x + other.x, this.y + other.y)
    }
    
    def minus(Point other) {
        return new Point(this.x - other.x, this.y - other.y)
    }
    
    // Manhattan distance
    def distanceFrom(Point other) {
        return Math.abs(this.x - other.x) + Math.abs(this.y - other.y)
    }

    def tuningFrequency() {
        return (x as long) * 4000000 + y
    }
    
    @Override
    public String toString() {
        return """($x, $y)"""
    }
}

class Sensor {
    Point pos
    Point closestBeaconPos
    
    Sensor(Point pos, Point closestBeaconPos, Set<Point> beaconPosCandidates, int maxPossibleV) {
        this.pos = pos
        this.closestBeaconPos = closestBeaconPos
        
        println """Parsing sensor at $pos (closest beacon at $closestBeaconPos)..."""

        def dist = pos.distanceFrom(closestBeaconPos)

        def corners = [
            new Point(pos.x - (dist + 1), pos.y), // Left
            new Point(pos.x, pos.y + (dist + 1)), // Down
            new Point(pos.x + (dist + 1), pos.y), // Right
            new Point(pos.x, pos.y - (dist + 1)), // Up
        ]
        
        def isInRange = { p ->
            0 <= p.x && p.x <= maxPossibleV &&
            0 <= p.y && p.y <= maxPossibleV
        }

        for (int from = 0; from < 4; ++from) {
            def to = (from + 1) % 4;
            def delta = corners[from].getDeltaTowards(corners[to])
            def until = corners[to].plus(delta)
            for (Point p = corners[from]; p != until; p = p.plus(delta)) {
                if (isInRange(p)) {
                    beaconPosCandidates.add(p)
                }
            }
        }
    }
    
    def canHaveBeaconAt(Point p) {
        if (p == closestBeaconPos) return true
        return pos.distanceFrom(p) > pos.distanceFrom(closestBeaconPos)
    }
}

// A crude parser class to avoid having to look up regex docs
class Parser {
    ArrayList<Sensor> sensors
    Set<Point> beacons
    
    Parser(String filename, Set<Point> beaconPosCandidates, int maxPossibleV) {
        this.sensors = []
        this.beacons = []

        File file = new File(filename)
        file.readLines().each { this.parseLine(it, beaconPosCandidates, maxPossibleV) }
    }

    // "Sensor at x=2, y=18: closest beacon is at x=-2, y=15"
    private def parseLine(String line, Set<Point> beaconPosCandidates, int maxPossibleV) {
        def (sensorStmt, beaconStmt) = line.split(':')
        def sensorPos = parseStmt(sensorStmt)
        def closestBeaconPos = parseStmt(beaconStmt)

        this.beacons.add(closestBeaconPos)
        this.sensors.add(new Sensor(sensorPos, closestBeaconPos, beaconPosCandidates, maxPossibleV))
    }
    
    // "Sensor at x=2, y=18"
    private def parseStmt(String stmt) {
        def (_, pointPart) = stmt.split("at ")
        return parsePoint(pointPart)
    }

    // "x=2, y=18"
    private def parsePoint(String point) {
        def (xPart, yPart) = point.split(", ")
        return new Point(parseInt(xPart), parseInt(yPart))
    }
    
    // "x=2"
    private def parseInt(String s) {
        def (_, i) = s.split('=')
        return i as int
    }
}

def main() {
    // def filename = "dummy_input.txt"
    // def maxPossibleV = 20
    def filename = "input.txt"
    def maxPossibleV = 4000000

    Set<Point> beaconPosCandidates = []
    def parser = new Parser(filename, beaconPosCandidates, maxPossibleV)
    def sensors = parser.sensors
    beaconPosCandidates.removeAll(parser.beacons)
    
    def total = beaconPosCandidates.size()
    println """Parse complete. # Beacon position candidates: $total"""

    def sanCheck = new Point(14, 11).tuningFrequency()
    println """Sanity Check: $sanCheck, should be 56000011 (${sanCheck == 56000011})"""
    
    def count = 0
    for (point in beaconPosCandidates) {
        count += 1
        println """$count / $total candidates checked"""
        if (sensors.every { it.canHaveBeaconAt(point) }) {
            println ""
            println point
            println """Part 2: ${point.tuningFrequency()}"""
            break
        }
    }
}

main()
