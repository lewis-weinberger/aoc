const std = @import("std");
const eql = std.mem.eql;
const indexOf = std.mem.indexOf;
const parseUnsigned = std.fmt.parseUnsigned;

const fields = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
const ecls = [_][]const u8{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };

fn isValid(key: []const u8, val: []const u8) bool {
    if (eql(u8, key, "byr")) {
        const n = parseUnsigned(u32, val, 10) catch return false;
        if (n >= 1920 and n <= 2002) {
            return true;
        }
    } else if (eql(u8, key, "iyr")) {
        const n = parseUnsigned(u32, val, 10) catch return false;
        if (n >= 2010 and n <= 2020) {
            return true;
        }
    } else if (eql(u8, key, "eyr")) {
        const n = parseUnsigned(u32, val, 10) catch return false;
        if (n >= 2020 and n <= 2030) {
            return true;
        }
    } else if (eql(u8, key, "hgt")) {
        if (indexOf(u8, val, "cm")) |i| {
            const n = parseUnsigned(u32, val[0..i], 10) catch return false;
            if (n >= 150 and n <= 193) {
                return true;
            }
        }
        if (indexOf(u8, val, "in")) |i| {
            const n = parseUnsigned(u32, val[0..i], 10) catch return false;
            if (n >= 59 and n <= 76) {
                return true;
            }
        }
    } else if (eql(u8, key, "hcl")) {
        if (val.len == 7) {
            const n = parseUnsigned(u32, val[1..], 16) catch return false;
            if (n <= 0xFFFFFF) {
                return true;
            }
        }
    } else if (eql(u8, key, "ecl")) {
        for (ecls) |ecl| {
            if (eql(u8, val, ecl)) {
                return true;
            }
        }
    } else if (eql(u8, key, "pid")) {
        if (val.len == 9) {
            const n = parseUnsigned(u32, val, 10) catch return false;
            return true;
        }
    }

    return false;
}

fn parse(allocator: *std.mem.Allocator, str: []u8, na: *u32, nb: *u32) !void {
    var map = std.BufMap.init(allocator);
    defer map.deinit();

    var pairs = std.mem.tokenize(str, " ");
    while (pairs.next()) |substr| {
        try map.put(substr[0..3], substr[4..]);
    }

    var valid = true;
    for (fields) |key| {
        if (map.get(key)) |val| {
            valid = valid and isValid(key, val);
        } else {
            return;
        }
    }

    na.* += 1;
    if (valid) {
        nb.* += 1;
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var p: u8 = undefined;
    var na: u32 = 0;
    var nb: u32 = 0;
    var passport = std.ArrayList(u8).init(allocator);
    defer passport.deinit();

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    while (in.readByte() catch null) |c| {
        // Passport entries delimited by blank lines
        if (c == '\n') {
            if (p == '\n') {
                try parse(allocator, passport.items, &na, &nb);
                passport.shrinkRetainingCapacity(0);
            } else {
                try passport.append(' ');
            }
        } else {
            try passport.append(c);
        }
        p = c;
    }
    try parse(allocator, passport.items, &na, &nb); // final password before EOF

    std.debug.print("A) {d} passports with all fields present\n", .{na});
    std.debug.print("B) {d} passports with all fields present and valid\n", .{nb});
}
