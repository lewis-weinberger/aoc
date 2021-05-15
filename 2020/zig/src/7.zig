const std = @import("std");

const Bags = std.ArrayList([]const u8);
const NBag = struct { n: usize, bag: []const u8 };
const NBags = std.ArrayList(NBag);

fn parse(allocator: *std.mem.Allocator, line: []const u8, backward: *std.StringHashMap(Bags), forward: *std.StringHashMap(NBags)) !void {
    var iter = std.mem.tokenize(line, " ");

    var parent = std.ArrayList(u8).init(allocator);
    try parent.appendSlice(iter.next().?);
    try parent.appendSlice(iter.next().?);
    _ = iter.next(); // bags
    _ = iter.next(); // contain

    var children = NBags.init(allocator);
    while (iter.next()) |num| {
        if (std.mem.eql(u8, num, "no")) {
            _ = iter.next(); // other
            _ = iter.next(); // bags
        } else {
            const n = try std.fmt.parseUnsigned(usize, num, 10);
            var child = std.ArrayList(u8).init(allocator);
            try child.appendSlice(iter.next().?);
            try child.appendSlice(iter.next().?);
            _ = iter.next(); // bags

            try children.append(NBag{ .n = n, .bag = child.items });
            var parents = backward.get(child.items) orelse Bags.init(allocator);
            try parents.append(parent.items);
            try backward.put(child.items, parents);
        }
    }
    try forward.put(parent.items, children);
}

fn countBackward(backward: *std.StringHashMap(Bags), checked: *std.StringHashMap(u8), bag: []const u8) std.mem.Allocator.Error!usize {
    var n: usize = 0;
    if (backward.get(bag)) |parents| {
        for (parents.items) |parent| {
            if (checked.get(parent) == null) {
                n += 1;
                try checked.put(parent, 1);
                n += try countBackward(backward, checked, parent);
            }
        }
    }
    return n;
}

fn countForward(forward: *std.StringHashMap(NBags), bag: []const u8) usize {
    var n: usize = 0;
    if (forward.get(bag)) |children| {
        for (children.items) |child| {
            n += child.n;
            n += child.n * countForward(forward, child.bag);
        }
    }
    return n;
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    // Store each bag as a key in a HashMap with a list of parent bags
    var backward = std.StringHashMap(Bags).init(allocator);
    // Store each bag as a key in a HashMap with a list of children bags
    var forward = std.StringHashMap(NBags).init(allocator);

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try parse(allocator, line, &backward, &forward);
    }

    var checked = std.StringHashMap(u8).init(allocator);
    const na = try countBackward(&backward, &checked, "shinygold");
    std.debug.print("A) {d} bags can contain a shiny gold bag\n", .{na});

    const nb = countForward(&forward, "shinygold");
    std.debug.print("B) a shiny gold bag must contain {d} bags\n", .{nb});
}
