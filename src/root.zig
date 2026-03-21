pub const Vector3 = @This();

const std = @import("std");

data: @Vector(3, f32) = .{0, 0, 0},

pub fn init(xd: f32, yd: f32, zd: f32) Vector3 {
	return .{ .data = .{xd, yd, zd}};
}

pub fn x(self: *const Vector3) f32 {
	return self.data[0];
}

pub fn y(self: *const Vector3) f32 {
	return self.data[1];
}

pub fn z(self: *const Vector3) f32 {
	return self.data[2];
}

pub const r = x;
pub const g = y;
pub const b = z;


pub fn opposite(self: *const Vector3) Vector3 {
	const temp: Vector3 = .{
		.data = -self.data
	};
	return temp;
}

pub fn magnitude(self: *const Vector3) f32 {
	return std.math.sqrt(magnitudeSquared(self));
}

pub fn magnitudeSquared(self: *const Vector3) f32 {
	return (
		self.data[0] * self.data[0] +
		self.data[1] * self.data[1] +
		self.data[2] * self.data[2]
	);
}

pub fn normalized(v: Vector3) Vector3 {
	const len = v.magnitude();
	return v.scale(1/len);
}

pub fn add(v1: *const Vector3, v2: *const Vector3) Vector3 {
	return Vector3{.data = v1.data + v2.data};
}

pub fn subtract(v1: *const Vector3, v2: *const Vector3) Vector3 {
	return Vector3{.data = v1.data - v2.data};
}

pub fn multiply(v1: *const Vector3, v2: *const Vector3) Vector3 {
	return Vector3{.data = v1.data * v2.data};
}

pub fn scale(v: *const Vector3, s: f32) Vector3 {
	return Vector3{.data = v.data * @as(@Vector(3, f32), @splat(s))};
}

pub fn dot(v1: *const Vector3, v2: *const Vector3) f32 {
	const res: f32 = @reduce(.Add, v1.data*v2.data);
	return res;
}

pub fn cross(v1: *const Vector3, v2: *const Vector3) Vector3 {
	const xp: f32 = v1.data[1] * v2.data[2] - v1.data[2] * v2.data[1];
	const yp: f32 = v1.data[2] * v2.data[0] - v1.data[0] * v2.data[2];
	const zp: f32 = v1.data[0] * v2.data[1] - v1.data[1] * v2.data[0];
	return .init(xp, yp, zp);
}

pub fn reflect(v1: *const Vector3, v2: *const Vector3) Vector3 {
	return .subtract(
		v1,
		&.scale(v2, 2*dot(v1, v2))
	);
}

pub fn randomUnitVector(random: *const std.Random) Vector3 {
	var p: Vector3 = .init(1, 1, 1);
	while (p.magnitudeSquared() >= 1 or p.magnitudeSquared() < 1e-160) {
		p = .init(
			2 * random.float(f32) - 1,
			2 * random.float(f32) - 1,
			2 * random.float(f32) - 1,
		);
	}
	return p.normalized();
}

pub fn randomOnUnitDisk(random: std.Random) Vector3 {
	var p: Vector3 = .init(1, 1, 1);
	while (p.magnitudeSquared() >= 1 or p.magnitudeSquared() < 1e-160) {
		p = .init(
			2 * random.float(f32) - 1,
			2 * random.float(f32) - 1,
			0
		);
	}
	return p;
}

pub fn randomOnHemisphere(normal: *const Vector3, random: std.Random) Vector3 {
	const tangent_point = randomUnitVector(random);
	return if (Vector3.dot(tangent_point, normal) > 0) tangent_point else .scale(tangent_point, -1);
}

pub fn isCloseToZero(v: *const Vector3) bool {
	const s = 1e-8;
	return (@abs(v.x()) < s) and (@abs(v.y()) < s) and (@abs(v.z()) < s);
}

pub fn jsonParse(allocator: std.mem.Allocator, source: anytype, options: std.json.ParseOptions) !Vector3 {
	const array = try std.json.innerParse([]f32, allocator, source, options);
	defer allocator.free(array);
	return .init(array[0], array[1], array[2]);
}
