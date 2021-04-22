const std = @import("std");

fn tree(line: []const u8, x: *u32, y: *u32, dx: u32, dy: u32) u32 {
    const xo = x.*;
    const yo = y.*;

    y.* += 1;
    if (yo % dy == 0) {
        x.* += dx;
        if (line[xo % line.len] == '#') {
            return 1;
        }
    }
    return 0;
}

pub fn main() anyerror!void {
    var x = [_]u32{ 0, 0, 0, 0, 0 };
    var y = [_]u32{ 0, 0, 0, 0, 0 };
    var n = [_]u32{ 0, 0, 0, 0, 0 };
    const dx = [_]u32{ 1, 3, 5, 7, 1 };
    const dy = [_]u32{ 1, 1, 1, 1, 2 };

    // Read and parse puzzle input from stdin
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var lbuf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&lbuf, '\n')) |line| {
        for (n) |_, i| {
            n[i] += tree(line, &x[i], &y[i], dx[i], dy[i]);
        }
    }

    std.debug.print("A) {d} trees encountered\n", .{n[1]});
    std.debug.print("B) {d}\n", .{n[0] * n[1] * n[2] * n[3] * n[4]});
}
