const std = @import("std");
const Vector3 = @This();

data: @Vector(3, f32) = .{0, 0, 0},

pub inline fn init(x_: f32, y_: f32, z_: f32) Vector3 {
    return .{ .data = .{x_, y_, z_}};
}

// Component access

pub inline fn x(self: Vector3) f32 {
    return self.data[0];
}

pub inline fn y(self: Vector3) f32 {
    return self.data[1];
}

pub inline fn z(self: Vector3) f32 {
    return self.data[2];
}

pub inline fn xRef(self: *Vector3) *f32 {
    return &self.data[0];
}

pub inline fn yRef(self: *Vector3) *f32 {
    return &self.data[1];
}

pub inline fn zRef(self: *Vector3) *f32 {
    return &self.data[2];
}

// Arithmetic

pub inline fn add(v1: Vector3, v2: Vector3) Vector3 {
    return .{ .data = v1.data + v2.data };
}

pub inline fn sub(v1: Vector3, v2: Vector3) Vector3 {
    return .{ .data = v1.data - v2.data };
}

pub inline fn mul(v1: Vector3, v2: Vector3) Vector3 {
    return .{ .data = v1.data * v2.data };
}

pub inline fn scale(v: Vector3, s: f32) Vector3 {
    return .{ .data = v.data * @as(@Vector(3, f32), @splat(s)) };
}

// Self operations

pub inline fn neg(self: Vector3) Vector3 {
    return .{.data = -self.data};
}

pub fn norm(self: Vector3) Vector3 {
    return self.scale(1 / self.length());
}

pub inline fn lengthSquared(self: Vector3) f32 {
    return (
        self.data[0] * self.data[0] +
        self.data[1] * self.data[1] +
        self.data[2] * self.data[2]
    );
}

pub fn length(self: Vector3) f32 {
    return @sqrt(lengthSquared(self));
}

// Vector-Vector operations

pub inline fn dot(v1: Vector3, v2: Vector3) f32 {
    const res: f32 = @reduce(.Add, v1.data * v2.data);
    return res;
}

pub fn cross(v1: Vector3, v2: Vector3) Vector3 {
    const xp: f32 = v1.data[1] * v2.data[2] - v1.data[2] * v2.data[1];
    const yp: f32 = v1.data[2] * v2.data[0] - v1.data[0] * v2.data[2];
    const zp: f32 = v1.data[0] * v2.data[1] - v1.data[1] * v2.data[0];
    return .init(xp, yp, zp);
}

pub fn reflect(v1: Vector3, v2: Vector3) Vector3 {
    return .sub(
        v1,
        .scale(v2, 2 * dot(v1, v2)),
    );
}

// Random Generation

pub fn randomUnitVec(random: std.Random) Vector3 {
    var p: Vector3 = .init(1, 1, 1);
    while (p.lengthSquared() >= 1 or p.lengthSquared() < 1e-160) {
        p = .init(
            2 * random.float(f32) - 1,
            2 * random.float(f32) - 1,
            2 * random.float(f32) - 1,
        );
    }
    return p.norm();
}

pub fn randomOnUnitDisk(random: std.Random) Vector3 {
    var p: Vector3 = .init(1, 1, 1);
    while (p.lengthSquared() >= 1 or p.lengthSquared() < 1e-160) {
        p = .init(
            2 * random.float(f32) - 1,
            2 * random.float(f32) - 1,
            0,
        );
    }
    return p;
}

pub fn randomOnHemisphere(normal: Vector3, random: std.Random) Vector3 {
    const tangent_point = randomUnitVec(random);
    return if (Vector3.dot(tangent_point, normal) > 0) tangent_point else .scale(tangent_point, -1);
}

// Utility

pub const r = x;
pub const g = y;
pub const b = z;

pub inline fn isNearZero(v: Vector3) bool {
    const s = 1e-8;
    return (@abs(v.x()) < s) and (@abs(v.y()) < s) and (@abs(v.z()) < s);
}

pub fn format(self: Vector3, writer: *std.Io.Writer) !void {
    try writer.print("[{}, {}, {}]", .{ self.x(), self.y(), self.z() });
}
