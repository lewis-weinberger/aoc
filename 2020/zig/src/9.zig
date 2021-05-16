const std = @import("std");
const Allocator = std.mem.Allocator;
const Series = std.ArrayList(usize);
const parseUnsigned = std.fmt.parseUnsigned;

fn valid(preamble: []usize, next: usize) bool {
    for (preamble) |x| {
        for (preamble) |y| {
            if (x + y == next) {
                return true;
            }
        }
    }
    return false;
}

fn sum(slice: []usize) usize {
    var acc: usize = 0;
    for (slice) |item| {
        acc += item;
    }
    return acc;
}

fn minmax(slice: []usize, min: *usize, max: *usize) void {
    for (slice) |item| {
        if (item < min.*) {
            min.* = item;
        } else if (item > max.*) {
            max.* = item;
        }
    }
}

fn weakness(list: []usize, invalid: usize, start: *usize, end: *usize) void {
    while (sum(list[start.*..end.*]) != invalid) {
        if (end.* == list.len) {
            start.* += 1;
            end.* = start.* + 2;
        } else {
            end.* += 1;
        }
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var series = Series.init(allocator);
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try series.append(try parseUnsigned(usize, line, 10));
    }

    // Part A
    var i: usize = 25;
    while (valid(series.items[(i - 25)..i], series.items[i])) : (i += 1) {}
    std.debug.print("A) first invalid number is {d}\n", .{series.items[i]});

    // Part B
    var start: usize = 0;
    var end: usize = 2;
    weakness(series.items, series.items[i], &start, &end);
    var min: usize = series.items[start];
    var max: usize = series.items[start];
    minmax(series.items[start..end], &min, &max);
    std.debug.print("B) encryption weakness is {d}\n", .{min + max});
}
