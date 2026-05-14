const std = @import("std");

pub const Vector2 = @This();

data: @Vector(2, f32),

// Component access

pub inline fn x(a: Vector2) f32 {
    return a.data[0];
}

pub inline fn y(a: Vector2) f32 {
    return a.data[1];
}

pub inline fn xRef(a: *Vector2) *f32 {
    return &a.data[0];
}

pub inline fn yRef(a: *Vector2) *f32 {
    return &a.data[1];
}

// Construction

pub inline fn init(x_: f32, y_: f32) Vector2 {
    return .{ .data = .{ x_, y_ } };
}

pub inline fn splat(value: f32) Vector2 {
    return .{ .data = @splat(value) };
}

pub inline fn zero() Vector2 {
    return splat(0.0);
}

// Arithmetic

pub inline fn add(a: Vector2, b: Vector2) Vector2 {
    return .{ .data = a.data + b.data };
}

pub inline fn sub(a: Vector2, b: Vector2) Vector2 {
    return .{ .data = a.data - b.data };
}

pub inline fn mul(a: Vector2, b: Vector2) Vector2 {
    return .{ .data = a.data * b.data };
}

pub inline fn div(a: Vector2, b: Vector2) Vector2 {
    return .{ .data = a.data / b.data };
}

pub inline fn scale(a: Vector2, scalar: f32) Vector2 {
    return .{ .data = a.data * @as(@Vector(2, f32), @splat(scalar)) };
}

// Self operations

pub inline fn neg(a: Vector2) Vector2 {
    return .{ .data = -a.data };
}

pub inline fn normalized(a: Vector2) Vector2 {
    const len_sq = lengthSquared(a);
    if (len_sq == 0.0) return zero();
    return scale(a, 1.0 / @sqrt(len_sq));
}

pub inline fn lengthSquared(a: Vector2) f32 {
    return dot(a, a);
}

pub inline fn length(a: Vector2) f32 {
    return @sqrt(lengthSquared(a));
}

// Vector-Vector operations

pub inline fn dot(a: Vector2, b: Vector2) f32 {
    return @reduce(.Add, a.data * b.data);
}

pub inline fn cross(a: Vector2, b: Vector2) f32 {
    return (a.data[0] * b.data[1]) - (a.data[1] * b.data[0]);
}

pub inline fn distance(a: Vector2, b: Vector2) f32 {
    return length(sub(a, b));
}

pub inline fn reflect(v: Vector2, n: Vector2) Vector2 {
    // v - 2 * dot(v, n) * n
    return sub(v, scale(n, 2.0 * dot(v, n)));
}

pub inline fn angleBetween(a: Vector2, b: Vector2) f32 {
    const cos_theta = dot(a, b) / (length(a) * length(b));
    return std.math.acos(@max(-1.0, @min(1.0, cos_theta)));
}

// Miscellaneous

pub inline fn lerp(a: Vector2, b: Vector2, t: f32) Vector2 {
    const clamped_t = @max(0.0, @min(1.0, t));
    return add(a, scale(sub(b, a), clamped_t));
}

pub inline fn clamp(a: Vector2, min: Vector2, max: Vector2) Vector2 {
    return .{ .data = @min(@max(a.data, min.data), max.data) };
}

// Utility

/// Converts a vector to a Vector2, using tuple fields or named struct fields
pub inline fn initAny(vector: anytype) Vector2 {
	const T = @TypeOf(vector);
	switch (@typeInfo(T)) {
		.@"struct" => |s| {
			if (s.is_tuple) {
				if (s.fields.len < 2)
					@compileError("Tuple needs at least 2 fields to convert to Vector2, got: " ++ @typeName(T));

				return .init(
					@as(f32, @floatCast(vector[0])),
					@as(f32, @floatCast(vector[1])),
				);
			}
			// Named struct — require .x and .y
			if (!@hasField(T, "x"))
				@compileError("Struct missing field 'x' for Vector2 conversion: " ++ @typeName(T));

			if (!@hasField(T, "y"))
				@compileError("Struct missing field 'y' for Vector2 conversion: " ++ @typeName(T));
			return .init(
				@as(f32, @floatCast(vector.x)),
				@as(f32, @floatCast(vector.y)),
			);
		},
		else => @compileError("vector must be a struct with x/y fields or a tuple")
	}
}

pub fn format(self: Vector2, writer: *std.Io.Writer) !void {
    try writer.print("[{}, {}]", .{ self.x(), self.y() });
}
