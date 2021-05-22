const std = @import("std");
const ParseIntError = std.fmt.ParseIntError;
const Vec = struct { x: isize, y: isize };
const Dir = struct { c: u8, a: isize };

const dirs = [4]Dir{
    Dir{ .c = 'N', .a = 0 },
    Dir{ .c = 'E', .a = 90 },
    Dir{ .c = 'S', .a = 180 },
    Dir{ .c = 'W', .a = 270 },
};

fn turn(dir: *Dir, angle: isize) void {
    const i = @divExact(@mod(dir.a + angle, 360), 90);
    dir.* = dirs[@intCast(usize, i)];
}

fn advance(dir: u8, v: *Vec, n: isize) void {
    switch (dir) {
        'N' => {
            v.y += n;
        },
        'S' => {
            v.y -= n;
        },
        'E' => {
            v.x += n;
        },
        'W' => {
            v.x -= n;
        },
        else => {},
    }
}

fn parse(line: []u8, v: *Vec, dir: *Dir) !void {
    const n = try std.fmt.parseInt(isize, line[1..], 10);
    switch (line[0]) {
        'N', 'E', 'S', 'W' => {
            advance(line[0], v, n);
        },
        'L' => {
            turn(dir, -n);
        },
        'R' => {
            turn(dir, n);
        },
        'F' => {
            advance(dir.c, v, n);
        },
        else => {},
    }
}

const unit = [4]isize{ 1, 0, -1, 0 };

fn cos(angle: isize) isize {
    return unit[@intCast(usize, @divExact(angle, 90))];
}

fn sin(angle: isize) isize {
    return unit[@intCast(usize, @divExact(@mod(angle - 90, 360), 90))];
}

fn rotate(v: *Vec, a: isize, s: isize) void {
    const x = v.x * cos(a) + s * v.y * sin(a);
    const y = v.y * cos(a) - s * v.x * sin(a);
    v.x = x;
    v.y = y;
}

fn parseWaypoint(line: []u8, v: *Vec, w: *Vec) !void {
    const n = try std.fmt.parseInt(isize, line[1..], 10);
    switch (line[0]) {
        'N', 'E', 'S', 'W' => {
            advance(line[0], w, n);
        },
        'L' => {
            rotate(w, n, -1);
        },
        'R' => {
            rotate(w, n, 1);
        },
        'F' => {
            v.x += n * w.x;
            v.y += n * w.y;
        },
        else => {},
    }
}

fn abs(x: isize) isize {
    return if (x < 0) -x else x;
}

pub fn main() anyerror!void {
    var a = Vec{ .x = 0, .y = 0 };
    var dir = Dir{ .c = 'E', .a = 90 };
    var b = Vec{ .x = 0, .y = 0 };
    var w = Vec{ .x = 10, .y = 1 };

    // Read and parse puzzle input from stdin
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try parse(line, &a, &dir);
        try parseWaypoint(line, &b, &w);
    }

    std.debug.print("A) {d} + {d} = {d}\n", .{
        abs(a.x),
        abs(a.y),
        abs(a.x) + abs(a.y),
    });
    std.debug.print("B) {d} + {d} = {d}\n", .{
        abs(b.x),
        abs(b.y),
        abs(b.x) + abs(b.y),
    });
}
