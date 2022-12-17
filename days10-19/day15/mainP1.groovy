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
    
    def minus(Point other) {
        return new Point(this.x - other.x, this.y - other.y)
    }
    
    // Manhattan distance
    def distanceFrom(Point other) {
        return Math.abs(this.x - other.x) + Math.abs(this.y - other.y)
    }

    def fourNeighbors() {
        return [
            new Point(x - 1, y),
            new Point(x + 1, y),
            new Point(x, y - 1),
            new Point(x, y + 1),
        ]
    }
    
    @Override
    public String toString() {
        return """($x, $y)"""
    }
}

class Sensor {
    Point pos
    Point closestBeaconPos
    
    Sensor(Point pos, Point closestBeaconPos) {
        this.pos = pos
        this.closestBeaconPos = closestBeaconPos
    }
    
    def canHaveBeaconAt(Point p) {
        if (p == closestBeaconPos) return true
        return pos.distanceFrom(p) > pos.distanceFrom(closestBeaconPos)
    }
}

// A crude parser class to avoid having to look up regex docs
class Parser {
    ArrayList<Sensor> sensors
    Integer minXToSearch
    Integer maxXToSearch
    
    Parser(String filename) {
        this.sensors = []
        this.minXToSearch = null
        this.maxXToSearch = null

        File file = new File(filename)
        file.readLines().each { this.parseLine(it) }
    }

    // "Sensor at x=2, y=18: closest beacon is at x=-2, y=15"
    private def parseLine(String line) {
        def (sensorStmt, beaconStmt) = line.split(':')
        def sensorPos = parseStmt(sensorStmt)
        def closestBeaconPos = parseStmt(beaconStmt)

        def dist = sensorPos.distanceFrom(closestBeaconPos)
        if (this.minXToSearch == null || sensorPos.x - dist < this.minXToSearch) {
            this.minXToSearch = sensorPos.x - dist
        }
        if (this.maxXToSearch == null || sensorPos.x + dist > this.maxXToSearch) {
            this.maxXToSearch = sensorPos.x + dist
        }

        this.sensors.add(new Sensor(sensorPos, closestBeaconPos))
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
    // def interestedY = 10
    def filename = "input.txt"
    def interestedY = 2000000

    def parser = new Parser(filename)
    def sensors = parser.sensors
    def minXToSearch = parser.minXToSearch
    def maxXToSearch = parser.maxXToSearch
    
    println "Parse complete"
    
    def noBeaconPos = (minXToSearch..maxXToSearch)
        .collect {
            return new Point(it, interestedY)
        }.findAll {
            p -> sensors.any { sensor -> !sensor.canHaveBeaconAt(p) }
        }
    // noBeaconPos.sort().each {
    //     println it
    // }
    println """Part 1: ${noBeaconPos.size()}"""
}

main()
