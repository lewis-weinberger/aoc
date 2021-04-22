const std = @import("std");

fn parse(line: []u8, lo: *u8, hi: *u8, c: *[]const u8) ![]const u8 {
    var iter = std.mem.tokenize(line, " -:");
    lo.* = try std.fmt.parseUnsigned(u8, iter.next().?, 10);
    hi.* = try std.fmt.parseUnsigned(u8, iter.next().?, 10);
    c.* = iter.next().?;
    return iter.next().?;
}

pub fn main() anyerror!void {
    var na: u32 = 0;
    var nb: u32 = 0;
    var lo: u8 = undefined;
    var hi: u8 = undefined;
    var c: []const u8 = undefined;

    // Read and parse puzzle input from stdin
    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [256]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const str = try parse(line, &lo, &hi, &c);

        // Part A
        const m = std.mem.count(u8, str, c);
        if (m >= lo and m <= hi) {
            na += 1;
        }

        // Part B
        if ((str[lo - 1] == c[0]) != (str[hi - 1] == c[0])) {
            nb += 1;
        }
    }

    std.debug.print("A) {d} valid passwords\n", .{na});
    std.debug.print("B) {d} valid passwords\n", .{nb});
}
