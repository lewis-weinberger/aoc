const std = @import("std");
const Allocator = std.mem.Allocator;
const String = std.ArrayList(u8);
const nearby = fn (a: []u8, b: isize, c: isize, d: usize, e: usize) usize;

fn index(i: isize, j: isize, y: usize, x: usize) ?usize {
    if (i >= 0 and j >= 0 and i < y and j < x) {
        return @intCast(usize, i) * x + @intCast(usize, j);
    } else {
        return null;
    }
}

fn adjacent(seating: []u8, i: isize, j: isize, y: usize, x: usize) usize {
    var n: usize = 0;

    var ii = i - 1;
    while (ii <= i + 1) : (ii += 1) {
        var jj = j - 1;
        while (jj <= j + 1) : (jj += 1) {
            if (ii == i and jj == j) {
                continue;
            }

            if (index(ii, jj, y, x)) |p| {
                if (seating[p] == '#') {
                    n += 1;
                }
            }
        }
    }
    return n;
}

const ydir = [8]isize{ 0, 1, 1, 1, 0, -1, -1, -1 };
const xdir = [8]isize{ 1, 1, 0, -1, -1, -1, 0, 1 };

fn lineOfSight(seating: []u8, i: isize, j: isize, y: usize, x: usize) usize {
    var n: usize = 0;

    var k: usize = 0;
    while (k < 8) : (k += 1) {
        var ii: isize = i + ydir[k];
        var jj: isize = j + xdir[k];
        while (index(ii, jj, y, x)) |p| {
            if (seating[p] == '#') {
                n += 1;
                break;
            } else if (seating[p] == 'L') {
                break;
            }
            ii += ydir[k];
            jj += xdir[k];
        }
    }
    return n;
}

fn evolve(prev: []u8, next: []u8, y: usize, x: usize, f: nearby, adj: usize) bool {
    std.mem.copy(u8, prev, next);

    var i: isize = 0;
    while (i < y) : (i += 1) {
        var j: isize = 0;
        while (j < x) : (j += 1) {
            const p = index(i, j, y, x).?;
            if (prev[p] != '.') {
                const n = f(prev, i, j, y, x);
                if (prev[p] == 'L' and n == 0) {
                    next[p] = '#';
                } else if (prev[p] == '#' and n >= adj) {
                    next[p] = 'L';
                }
            }
        }
    }
    return !std.mem.eql(u8, prev, next);
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var seating = String.init(allocator);
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    var x: usize = 0;
    var y: usize = 0;

    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try seating.appendSlice(line);
        y += 1;
        x += line.len;
    }
    x /= y;
    var previous = String.init(allocator);
    try previous.appendSlice(seating.items);

    // Part A
    while (evolve(previous.items, seating.items, y, x, adjacent, 4)) {}
    const na = std.mem.count(u8, seating.items, "#");
    std.debug.print("A) {d} seats occupied\n", .{na});

    // Reset input
    for (seating.items) |*seat| {
        if (seat.* == '#') {
            seat.* = 'L';
        }
    }

    // Part B
    while (evolve(previous.items, seating.items, y, x, lineOfSight, 5)) {}
    const nb = std.mem.count(u8, seating.items, "#");
    std.debug.print("B) {d} seats occupied\n", .{nb});
}
