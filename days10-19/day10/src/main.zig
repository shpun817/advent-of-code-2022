const std = @import("std");

const ArrayList = std.ArrayList;
const io = std.io;
const fmt = std.fmt;
const fs = std.fs;

const print = std.debug.print;

fn solveP1(x_deltas: ArrayList(i32)) i32 {
    var x_val: i32 = 1;
    var cycle_idx: u16 = 0;
    var acc: i32 = 0;
    while (cycle_idx <= 220) {
        // Start cycle

        // During cycle
        if (cycle_idx >= 20 and (cycle_idx - 20) % 40 == 0) {
            acc += cycle_idx * x_val;
        }

        // End of cycle
        x_val += x_deltas.items[cycle_idx];

        cycle_idx += 1;
    }
    return acc;
}

fn solveP2(x_deltas: ArrayList(i32)) void {
    const WIDTH = 40;
    const HEIGHT = 6;

    var sprite_middle_pos: i32 = 1;
    var row_idx: u16 = 0;
    while (row_idx < HEIGHT) {
        var col_idx: u16 = 0;
        while (col_idx < WIDTH) {
            // Start cycle

            // During cycle
            if (sprite_middle_pos - 1 <= col_idx and col_idx <= sprite_middle_pos + 1) {
                print("#", .{});
            } else {
                print(".", .{});
            }

            // End of cycle
            sprite_middle_pos += x_deltas.items[1 + row_idx * WIDTH + col_idx];
            
            col_idx += 1;
        }
        print("\n", .{});
        row_idx += 1;
    }
}

pub fn main() !void {
    // const filename = "dummy_input.txt";
    const filename = "input.txt";
    
    const file: fs.File = try fs.cwd().openFile(filename, .{});
    defer file.close();
    
    var x_deltas = ArrayList(i32).init(std.heap.page_allocator); // i-th elem to be applied at the END of the i-th cycle
    defer x_deltas.deinit();
    try x_deltas.append(0); // No changes in the 0-th cycle
    
    var buf_reader = io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [20]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line[0] == 'a') {
            const delta = try fmt.parseInt(i32, line[5..], 10);
            try x_deltas.append(0); // wait 1 cycle
            try x_deltas.append(delta);
        } else if (line[0] == 'n') {
            try x_deltas.append(0); // wait 1 cycle
        }
    }
    
    print("Part 1: {d}\n", .{solveP1(x_deltas)});
    print("Part 2:\n", .{});
    solveP2(x_deltas);
}
