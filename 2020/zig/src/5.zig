const std = @import("std");

fn parse(line: []u8) u10 {
    var d: u10 = 0;
    var i: u4 = 10;
    for (line) |c| {
        i -= 1;
        if (c == 'B' or c == 'R') {
            d += (@as(u10, 1) << i);
        }
    }
    return d;
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    
    var map = std.AutoHashMap(u10, u10).init(allocator);
    var id: u10 = undefined;
    var na: u10 = 0;

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        id = parse(line);
        try map.put(id, id);

        // Part A
        if (id > na) {
            na = id;
        }
    }

    // Part B
    var nb: u10 = undefined;
    id = 1;
    while (id < 1023) : (id += 1) {
        if (map.get(id - 1) != null and
            map.get(id + 1) != null and
            map.get(id) == null) {
            nb = id;
        }
    }

    std.debug.print("A) the highest seat id is {d}\n", .{na});
    std.debug.print("B) the missing seat id is {d}\n", .{nb});
}
