const std = @import("std");

pub fn main() anyerror!void {
    // Allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    // ArrayList to store input for ordered access
    var input = std.ArrayList(i32).init(allocator);

    // HashMap to store input for fast look-up
    var map = std.AutoHashMap(i32, i32).init(allocator);

    // Read and parse puzzle input from stdin
    var stdin = std.io.bufferedReader(std.io.getStdIn().reader()).reader();
    var lbuf: [256]u8 = undefined;
    while (try stdin.readUntilDelimiterOrEof(&lbuf, '\n')) |line| {
        const n = try std.fmt.parseInt(i32, line, 10);
        try input.append(n);
        try map.put(n, n);
    }

    // Part A
    var x: i32 = undefined;
    for (input.items) |in, i| {
        x = 2020 - in;
        if (map.get(x) != null) {
            std.debug.print("A) {d} * {d} = {d}\n", .{ in, x, in * x });
            break;
        }
    }

    // Part B
    outer: for (input.items) |ini, i| {
        for (input.items) |inj, j| {
            x = 2020 - ini - inj;
            if (map.get(x) != null) {
                std.debug.print("B) {d} * {d} * {d} = {d}\n", .{ ini, inj, x, ini * inj * x });
                break :outer;
            }
        }
    }
}
