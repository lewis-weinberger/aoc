const std = @import("std");

fn parse(allocator: *std.mem.Allocator, str: []u8, na: *u32, nb: *u32) !void {
    var map = std.AutoHashMap(u32, u32).init(allocator);
    defer map.deinit();

    var answers = std.mem.tokenize(str, "\n");
    var n: u32 = 0;
    while (answers.next()) |ans| {
        for (ans) |c| {
            if (map.get(c)) |p| {
                try map.put(c, p + 1);
            } else {
                try map.put(c, 1);
                na.* += 1;
            }
        }
        n += 1;
    }

    var c: u8 = 'a';
    while (c <= 'z') : (c += 1) {
        if (map.get(c)) |p| {
            if (p == n) {
                nb.* += 1;
            }
        }
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var p: u8 = undefined;
    var na: u32 = 0;
    var nb: u32 = 0;
    var group = std.ArrayList(u8).init(allocator);
    defer group.deinit();

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    while (in.readByte() catch null) |c| {
        // Group entries delimited by blank lines
        if (c == '\n' and p == '\n') {
            try parse(allocator, group.items, &na, &nb);
            group.shrinkRetainingCapacity(0);
        } else {
            try group.append(c);
        }
        p = c;
    }
    try parse(allocator, group.items, &na, &nb); // final group before EOF

    std.debug.print("A) the sum of counts is {d}\n", .{na});
    std.debug.print("B) the sum of counts is {d}\n", .{nb});
}
