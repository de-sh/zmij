//! Exhaustive f32 round-trip test: iterates all 2^32 bit patterns.
//! Run with: zig build test-exhaustive
//! This test is slow (~minutes depending on hardware).

const std = @import("std");
const zmij = @import("zmij.zig");

fn ftoa(value: f32) []const u8 {
    var buf = zmij.Buffer(f32){};
    return buf.format(value);
}

test "exhaustive_f32_round_trip" {
    var failures: u64 = 0;
    var checked: u64 = 0;
    var u: u32 = 0;

    while (true) {
        const f: f32 = @bitCast(u);

        if (std.math.isFinite(f)) {
            checked += 1;
            const formatted = ftoa(f);
            const parsed = std.fmt.parseFloat(f32, formatted) catch {
                if (failures < 10) {
                    std.debug.print("FAIL parse: bits=0x{x:0>8} formatted='{s}'\n", .{ u, formatted });
                }
                failures += 1;
                if (u == std.math.maxInt(u32)) break;
                u += 1;
                continue;
            };

            if (f != parsed) {
                if (failures < 10) {
                    std.debug.print("FAIL round-trip: bits=0x{x:0>8} formatted='{s}' expected={x} got={x}\n", .{
                        u, formatted, @as(u32, @bitCast(f)), @as(u32, @bitCast(parsed)),
                    });
                }
                failures += 1;
            }
        }

        if (u == std.math.maxInt(u32)) break;
        u += 1;

        // Progress report every 100M values
        if (u % 100_000_000 == 0) {
            std.debug.print("progress: {d}M / 4295M ({d} failures so far)\n", .{
                u / 1_000_000,
                failures,
            });
        }
    }

    std.debug.print("exhaustive f32: checked {d} finite values, {d} failures\n", .{ checked, failures });
    try std.testing.expectEqual(@as(u64, 0), failures);
}
