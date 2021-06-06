const std = @import("std");
const Allocator = std.mem.Allocator;
const HashMap = std.AutoHashMap(u36, u36);
const eql = std.mem.eql;
const tokenize = std.mem.tokenize;
const parseUnsigned = std.fmt.parseUnsigned;
const Mask = struct { on: u36, off: u36, float: u36 };
const u36_max = ~@as(u36, 0);

fn parseMask(str: []const u8, mask: *Mask) void {
    mask.on = 0;
    mask.off = u36_max;
    mask.float = 0;
    for (str) |c, i| {
        if (c == '0') {
            mask.off ^= @as(u36, 1) << @intCast(u6, 35 - i);
        } else if (c == '1') {
            mask.on ^= @as(u36, 1) << @intCast(u6, 35 - i);
        } else if (c == 'X') {
            mask.float ^= @as(u36, 1) << @intCast(u6, 35 - i);
        }
    }
}

fn parseAssignA(lhs: []const u8, rhs: []const u8, mem: *HashMap, mask: Mask) !void {
    var l = tokenize(lhs, "[]");
    _ = l.next();
    const addr = try parseUnsigned(u36, l.next().?, 10);

    var val = try parseUnsigned(u36, rhs, 10);
    val |= mask.on; // overwrite 1s in mask
    val &= mask.off; // overwrite 0s in mask
    try mem.put(addr, val);
}

fn parseAssignB(lhs: []const u8, rhs: []const u8, mem: *HashMap, mask: Mask) !void {
    const val = try parseUnsigned(u36, rhs, 10);

    var l = tokenize(lhs, "[]");
    _ = l.next();
    var addr = try parseUnsigned(u36, l.next().?, 10);
    addr |= mask.on; // overwrite 1s in mask

    // Loop over combinations of floating bits
    var i: u36 = 0;
    while (i < (@as(u36, 1) << @popCount(u36, mask.float))) : (i += 1) {
        var j: u6 = 0;
        var n: u6 = 0;
        while (j < 36) : (j += 1) {
            if ((mask.float >> j) & 1 == 1) {
                if ((i >> n) & 1 == 1) {
                    addr |= @as(u36, 1) << j;
                } else {
                    addr &= ~(@as(u36, 1) << j);
                }
                n += 1;
            }
        }
        try mem.put(addr, val);
    }
}

fn sum(memory: *HashMap) usize {
    var n: usize = 0;
    var iter = memory.iterator();
    while (iter.next()) |entry| {
        n += entry.value_ptr.*;
    }
    return n;
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    // Since memory is a sparse array use a hash map instead
    var memA = HashMap.init(allocator);
    var memB = HashMap.init(allocator);
    var mask: Mask = undefined;

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = tokenize(line, " ");
        const lhs = iter.next().?; // mask or mem[]
        _ = iter.next().?; // =
        const rhs = iter.next().?; // value

        if (eql(u8, lhs, "mask")) {
            parseMask(rhs, &mask);
        } else {
            try parseAssignA(lhs, rhs, &memA, mask);
            try parseAssignB(lhs, rhs, &memB, mask);
        }
    }

    const na = sum(&memA);
    std.debug.print("A) Sum of all values in memory is {d}\n", .{na});

    const nb = sum(&memB);
    std.debug.print("B) Sum of all values in memory is {d}\n", .{nb});
}
