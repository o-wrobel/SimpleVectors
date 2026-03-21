const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    _ = b.addModule("Vector3", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

}
