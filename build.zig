const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const vector3 = b.createModule(.{
	    .root_source_file = b.path("src/Vector3.zig")
    });

    const mod = b.addModule("simplevectors", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    mod.addImport("Vector3", vector3);

}
