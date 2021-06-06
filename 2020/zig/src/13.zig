const std = @import("std");
const parseUnsigned = std.fmt.parseUnsigned;
const Id = struct { id: usize, pos: usize };
const ArrayList = std.ArrayList(Id);

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;

    const l1 = (try in.readUntilDelimiterOrEof(&buf, '\n')).?;
    const ts = try parseUnsigned(usize, l1, 10);
    const l2 = (try in.readUntilDelimiterOrEof(&buf, '\n')).?;
    var iter = std.mem.tokenize(l2, ",");
    var ids = ArrayList.init(allocator);

    var i: usize = 0;
    while (iter.next()) |idstr| : (i += 1) {
        if (!std.mem.eql(u8, idstr, "x")) {
            const id = try parseUnsigned(usize, idstr, 10);
            try ids.append(Id{ .id = id, .pos = i });
        }
    }

    // Part A
    var min_id: usize = ids.items[0].id;
    var min_d: usize = min_id - ts % min_id;
    for (ids.items) |x| {
        const d = x.id - (ts % x.id);
        if (d < min_d) {
            min_id = x.id;
            min_d = d;
        }
    }
    std.debug.print("A) {d} * {d} = {d}\n", .{ min_d, min_id, min_d * min_id });

    // Part B
    var m: usize = 0;
    var n: usize = 1;
    for (ids.items) |y| {
        while (true) {
            m += n;
            if ((m + y.pos) % y.id == 0) {
                n *= y.id;
                break;
            }
        }
    }
    std.debug.print("B) earliest timestamp is {d}\n", .{m});
}
