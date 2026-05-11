const std = @import("std");

pub fn build(b: *std.Build) void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});
	_ = b.addModule(
		"Vector2",
		.{
			.root_source_file = b.path("src/Vector2.zig"),
			.target = target,
			.optimize = optimize,
		}
	);
	_ = b.addModule(
		"Vector3",
		.{
			.root_source_file = b.path("src/Vector3.zig"),
			.target = target,
			.optimize = optimize,
		}
	);
}
