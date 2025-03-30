const std = @import("std");

pub fn main() !u8 {
    if (std.os.argv.len < 2) {
        printHelp();
        return 1;
    }

    std.debug.print("There are {d} args:\n", .{std.os.argv.len});
    for (std.os.argv) |arg| {
        std.debug.print("  {s}\n", .{arg});
    }

    return 0;
}

fn printHelp() void {
    std.debug.print("gc - git clone\n", .{});
    std.debug.print("  Given an address, clones it in the correct folder\n", .{});
    std.debug.print("Usage: gc <repository>\n", .{});
    std.debug.print("Example: gc https://github.com/sirikon/workstation\n", .{});
}
