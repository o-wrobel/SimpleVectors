const std = @import("std");

pub fn build(b: *std.Build) void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});
	const vector2 = b.addModule(
		"Vector2",
		.{
			.root_source_file = b.path("src/Vector2.zig"),
			.target = target,
			.optimize = optimize,
		}
	);
	const vector3 = b.addModule(
		"Vector3",
		.{
			.root_source_file = b.path("src/Vector3.zig"),
			.target = target,
			.optimize = optimize,
		}
	);
	const test_step = b.step("test", "Run all tests");
	const vector2_test = b.addTest(.{ .root_module = vector2, });
	const vector3_test = b.addTest(.{ .root_module = vector3, });
	var vector2_run_test = b.addRunArtifact(vector2_test);
	var vector3_run_test = b.addRunArtifact(vector3_test);
	vector3_run_test.step.dependOn(&vector2_run_test.step);
	test_step.dependOn(&vector3_run_test.step);
}
