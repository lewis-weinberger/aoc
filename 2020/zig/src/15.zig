const std = @import("std");
const parseInt = std.fmt.parseInt;
const Number = struct { a: isize, b: ?isize };
const ArrayHashMap = std.AutoArrayHashMap(isize, Number);
const tokenize = std.mem.tokenize;
const max_turn: isize = 30_000_000;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var record = ArrayHashMap.init(allocator);
    try record.ensureTotalCapacity(max_turn);

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    const line = (try in.readUntilDelimiterOrEof(&buf, '\n')).?;
    var iter = tokenize(line, ",");
    var i: isize = 1;
    var n: isize = undefined;
    while (iter.next()) |num| : (i += 1) {
        n = try parseInt(isize, num, 10);
        try record.put(n, Number{ .a = i, .b = null });
    }

    var last: isize = n;
    var na: isize = undefined;
    while (i <= max_turn) : (i += 1) {
        const prev = record.get(last).?;
        if (prev.b) |b| {
            last = prev.a - b;
        } else {
            last = 0;
        }

        if (record.getPtr(last)) |next| {
            next.b = next.a;
            next.a = i;
        } else {
            try record.put(last, Number{ .a = i, .b = null });
        }

        // Part A
        if (i == 2020) {
            na = last;
            std.debug.print("A) {d}\n", .{na});
        }
    }

    // Part B
    const nb: isize = last;
    std.debug.print("B) {d}\n", .{nb});
}
