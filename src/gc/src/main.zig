const std = @import("std");

pub fn main() !void {
    std.debug.print("There are {d} args:\n", .{std.os.argv.len});
    for (std.os.argv) |arg| {
        std.debug.print("  {s}\n", .{arg});
    }
}
