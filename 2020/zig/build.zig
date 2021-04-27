const std = @import("std");
const Builder = std.build.Builder;
const bufPrint = std.fmt.bufPrint;
const BufPrintError = std.fmt.BufPrintError;

// Loop over the days to build each solution
const days = [_][]const u8{ "1", "2", "3", "4", "5" };

pub fn build(b: *Builder) BufPrintError!void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var buf: [32]u8 = undefined;
    for (days) |day| {
        const file = try bufPrint(&buf, "src/{s}.zig", .{day});
        const exe = b.addExecutable(day, file);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());

        const msg = try bufPrint(&buf, "Run solution for day {s}", .{day});
        const run_step = b.step(day, msg);
        run_step.dependOn(&run_cmd.step);

        std.log.info("[build.zig] including day {s}", .{day});
    }
}
