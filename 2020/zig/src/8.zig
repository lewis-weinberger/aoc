const std = @import("std");
const eql = std.mem.eql;
const Allocator = std.mem.Allocator;
const OpCode = enum { nop, acc, jmp };
const Op = union(OpCode) { nop: isize, acc: isize, jmp: isize };
const Program = std.ArrayList(Op);
const HashMap = std.AutoHashMap(isize, u8);

fn parse(line: []u8, program: *Program) !void {
    const n = try std.fmt.parseInt(isize, line[4..], 10);
    if (eql(u8, line[0..3], "nop")) {
        try program.append(Op{ .nop = n });
    } else if (eql(u8, line[0..3], "acc")) {
        try program.append(Op{ .acc = n });
    } else if (eql(u8, line[0..3], "jmp")) {
        try program.append(Op{ .jmp = n });
    }
}

fn run(allocator: *Allocator, program: *Program, fixed: *bool) !isize {
    var visited = HashMap.init(allocator);
    defer visited.deinit();

    var ic: isize = 0;
    var acc: isize = 0;
    while (visited.get(ic) == null) {
        if (ic >= program.items.len) {
            break;
        }

        try visited.put(ic, 0);
        switch (program.items[@intCast(usize, ic)]) {
            .nop => |_| {
                ic += 1;
            },
            .acc => |val| {
                acc += val;
                ic += 1;
            },
            .jmp => |val| {
                ic += val;
            },
        }

        if (ic == program.items.len - 1) {
            fixed.* = true;
        }
    }

    return acc;
}

fn swap(op: *Op) void {
    switch (op.*) {
        .nop => |val| {
            op.* = Op{ .jmp = val };
        },
        .jmp => |val| {
            op.* = Op{ .nop = val };
        },
        .acc => {},
    }
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var program = Program.init(allocator);

    var stdin = std.io.getStdIn().reader();
    var in = std.io.bufferedReader(stdin).reader();
    var buf: [32]u8 = undefined;
    while (try in.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try parse(line, &program);
    }

    // Part A
    var fixed = false;
    const na = try run(allocator, &program, &fixed);
    std.debug.print("A) the value of the accumulator is {d}\n", .{na});

    // Part B
    var nb: isize = 0;
    var i: usize = 0;
    while (i < program.items.len) : (i += 1) {
        swap(&program.items[i]);
        nb = try run(allocator, &program, &fixed);
        if (fixed) {
            std.debug.print("B) the value of the accumulator is {d}\n", .{nb});
            break;
        } else {
            swap(&program.items[i]);
        }
    }
}
