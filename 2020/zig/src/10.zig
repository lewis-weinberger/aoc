const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList(usize);
const parseUnsigned = std.fmt.parseUnsigned;

fn chainAdapters(adapters: []usize, dist: []usize, diff: *ArrayList) !void {
    var prev: usize = 0;
    var dx: usize = undefined;
    for (adapters) |adapter| {
        dx = adapter - prev;
        dist[dx - 1] += 1;
        try diff.append(dx);
        prev = adapter;
    }
}

fn permute(n: usize) usize {
    return switch (n) {
        1 => 1,
        2 => 2,
        3 => 4,
        4 => 7,
        else => |x| x,
    };
}

fn combinations(allocator: *Allocator, diffs: []usize) !usize {
    var permutable = ArrayList.init(allocator);
    var n: usize = 0;

    for (diffs) |diff| {
        if (diff == 3 and n > 0) {
            try permutable.append(permute(n));
            n = 0;
        } else if (diff == 1) {
            n += 1;
        }
    }
    if (n > 0) { // catch any trailing 1s
        try permutable.append(permute(n));
    }

    n = 1;
    for (permutable.items) |perm| {
        n *= perm;
    }
    return n;
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var adapters = ArrayList.init(allocator);
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try adapters.append(try parseUnsigned(usize, line, 10));
    }

    std.sort.sort(usize, adapters.items, {}, comptime std.sort.asc(usize));
    var diff = ArrayList.init(allocator);

    // Part A
    var dist = [3]usize{ 0, 0, 1 };
    try chainAdapters(adapters.items, &dist, &diff);
    std.debug.print("A) {d} * {d} = {d}\n", .{ dist[0], dist[2], dist[0] * dist[2] });

    // Part B
    const nb = try combinations(allocator, diff.items);
    std.debug.print("B) {d} combinations\n", .{nb});
}
