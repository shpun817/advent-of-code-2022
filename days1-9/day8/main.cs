using System;
using System.Collections.Generic;

class Grid {
    public int Width { get; private set; }
    public int Height { get; private set; }
    int[,] amplitudes { get; }

    public Grid(int width, int height, List<int> amplitudes) {
        this.Width = width;
        this.Height = height;
        this.amplitudes = new int[height, width];
        for (int i = 0; i < this.Height; ++i) {
            for (int j = 0; j < this.Width; ++j) {
                this.amplitudes[i, j] = amplitudes[i * width + j];
            }
        }
    }

    public override string ToString() {
        string res = string.Empty;
        for (int i = 0; i < this.Height; ++i) {
            for (int j = 0; j < this.Width; ++j) {
                res += this.amplitudes[i, j];
                res += " ";
            }
            res += "\n\n";
        }
        return res;
    }

    public int FindNumPointsVisible() {
        int acc = 0;
        for (int i = 0; i < this.Height; ++i) {
            for (int j = 0; j < this.Width; ++j) {
                if (this.isPointVisible(i, j)) {
                    ++acc;
                }
            }
        }
        return acc;
    }

    public int FindHighestScenicScore() {
        int max = 0;
        for (int i = 0; i < this.Height; ++i) {
            for (int j = 0; j < this.Width; ++j) {
                int scenicScore = this.getPointScenicScore(i, j);
                if (scenicScore > max) {
                    max = scenicScore;
                }
            }
        }
        return max;
    }

    int getPointAmplitude(int x, int y) {
        return this.amplitudes[y, x];
    }

    int getPointScenicScore(int x, int y) {
        return
            this.getNumPointsSeenUp(x, y) *
            this.getNumPointsSeenLeft(x, y) *
            this.getNumPointsSeenDown(x, y) *
            this.getNumPointsSeenRight(x, y);
    }

    bool isPointValid(int x, int y) {
        return
            0 <= x && x < this.Height &&
            0 <= y && y < this.Width;
    }

    bool isPointVisible(int x, int y) {
        return
            this.isPointVisibleFromTop(x, y) ||
            this.isPointVisibleFromBottom(x, y) ||
            this.isPointVisibleFromLeft(x, y) ||
            this.isPointVisibleFromRight(x, y);
    }

    bool isPointVisibleFromTop(int x, int y) {
        int pointAmp = this.getPointAmplitude(x, y);
        for (int i = 0; i < y; ++i) {
            if (this.getPointAmplitude(x, i) >= pointAmp) {
                return false;
            }
        }
        return true;
    }

    bool isPointVisibleFromBottom(int x, int y) {
        int pointAmp = this.getPointAmplitude(x, y);
        for (int i = y+1; i < this.Height; ++i) {
            if (this.getPointAmplitude(x, i) >= pointAmp) {
                return false;
            }
        }
        return true;
    }

    bool isPointVisibleFromLeft(int x, int y) {
        int pointAmp = this.getPointAmplitude(x, y);
        for (int j = 0; j < x; ++j) {
            if (this.getPointAmplitude(j, y) >= pointAmp) {
                return false;
            }
        }
        return true;
    }

    bool isPointVisibleFromRight(int x, int y) {
        int pointAmp = this.getPointAmplitude(x, y);
        for (int j = x+1; j < this.Width; ++j) {
            if (this.getPointAmplitude(j, y) >= pointAmp) {
                return false;
            }
        }
        return true;
    }

    int getNumPointsSeenUp(int x, int y) {
        int acc = 0;
        int pointAmp = this.getPointAmplitude(x, y);
        for (int i = y-1; this.isPointValid(x, i); --i) {
            ++acc;
            if (this.getPointAmplitude(x, i) >= pointAmp) {
                break;
            }
        }
        return acc;
    }

    int getNumPointsSeenDown(int x, int y) {
        int acc = 0;
        int pointAmp = this.getPointAmplitude(x, y);
        for (int i = y+1; this.isPointValid(x, i); ++i) {
            ++acc;
            if (this.getPointAmplitude(x, i) >= pointAmp) {
                break;
            }
        }
        return acc;
    }

    int getNumPointsSeenRight(int x, int y) {
        int acc = 0;
        int pointAmp = this.getPointAmplitude(x, y);
        for (int j = x+1; this.isPointValid(j, y); ++j) {
            ++acc;
            if (this.getPointAmplitude(j, y) >= pointAmp) {
                break;
            }
        }
        return acc;
    }

    int getNumPointsSeenLeft(int x, int y) {
        int acc = 0;
        int pointAmp = this.getPointAmplitude(x, y);
        for (int j = x-1; this.isPointValid(j, y); --j) {
            ++acc;
            if (this.getPointAmplitude(j, y) >= pointAmp) {
                break;
            }
        }
        return acc;
    }
}

class GridBuilder {
    int width { get; set; }
    List<string> inputLines { get; set; }

    public GridBuilder() {
        this.width = 1;
        this.inputLines = new List<string>();
    }

    public void FeedLine(string line) {
        this.width = line.Length;
        this.inputLines.Add(line);
    }

    public Grid Build() {
    int height = this.inputLines.Count;
        List<int> amplitudes = new List<int>();
        foreach (string line in this.inputLines) {
            if (line.Length != this.width) {
                throw new Exception("Inconsistent line length");
            }
            foreach (char c in line) {
                amplitudes.Add(c - '0');
            }
        }
        return new Grid(this.width, height, amplitudes);
    }
}

class Solver {         
    static void Main(string[] args)
    {
        // const string filename = "dummy_input.txt";
        const string filename = "input.txt";

        GridBuilder builder = new GridBuilder();
        foreach (string line in System.IO.File.ReadLines(filename)) {
            builder.FeedLine(line);
        }
        Grid grid = builder.Build();

        // System.Console.WriteLine(grid.ToString());
        System.Console.WriteLine("Part 1: " + grid.FindNumPointsVisible());
        System.Console.WriteLine("Part 2: " + grid.FindHighestScenicScore());
    }
}
