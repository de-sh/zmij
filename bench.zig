const std = @import("std");
const time = std.time;
const zmij = @import("zmij.zig");

const BenchValue = struct {
    name: []const u8,
    value: f64,
};

// Test values matching the Rust reference benchmark (benches/bench.rs)
const bench_values = [_]BenchValue{
    .{ .name = "f64[0]", .value = 0.0 },
    .{ .name = "f64[short]", .value = 0.1234 },
    .{ .name = "f64[medium]", .value = 0.123456789 },
    .{ .name = "f64[e]", .value = std.math.e },
    .{ .name = "f64[max]", .value = std.math.floatMax(f64) },
    .{ .name = "f64[pi]", .value = std.math.pi },
    .{ .name = "f64[1e-20]", .value = 1e-20 },
    .{ .name = "f64[1.23e300]", .value = 1.2345678901234567e300 },
};

pub fn main() !void {
    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("\n{s:<16} | {s:>15} | {s:>15} | {s:<24} | {s:<24}\n", .{
        "Name",          "zmij (ns)",
        "std.fmt (ns)",  "zmij output",
        "std.fmt output",
    });
    try stdout.print("{s:-<16}-|-{s:-<15}-|-{s:-<15}-|-{s:-<24}-|-{s:-<24}\n", .{ "", "", "", "", "" });

    inline for (bench_values) |bv| {
        const iterations = 1_000_000;
        var buf: [128]u8 = undefined;

        // Warmup
        for (0..1000) |_| {
            _ = zmij.writer(f64, bv.value, &buf);
            std.mem.doNotOptimizeAway(&buf);
        }

        // Benchmark zmij
        var timer = try time.Timer.start();
        for (0..iterations) |_| {
            _ = zmij.writer(f64, bv.value, &buf);
            std.mem.doNotOptimizeAway(&buf);
        }
        const zmij_time = timer.read();

        // Warmup
        for (0..1000) |_| {
            _ = try std.fmt.bufPrint(&buf, "{e}", .{bv.value});
            std.mem.doNotOptimizeAway(&buf);
        }

        // Benchmark std.fmt
        timer = try time.Timer.start();
        for (0..iterations) |_| {
            _ = try std.fmt.bufPrint(&buf, "{e}", .{bv.value});
            std.mem.doNotOptimizeAway(&buf);
        }
        const std_time = timer.read();

        var zmij_buf = zmij.Formatter(f64){};
        const zmij_val = zmij_buf.format(bv.value);
        const std_val = try std.fmt.bufPrint(&buf, "{e}", .{bv.value});

        const zmij_avg = @as(f64, @floatFromInt(zmij_time)) / iterations;
        const std_avg = @as(f64, @floatFromInt(std_time)) / iterations;

        try stdout.print("{s:<16} | {d:>15.1} | {d:>15.1} | {s:<24} | {s:<24}\n", .{
            bv.name, zmij_avg, std_avg, zmij_val, std_val,
        });
    }

    try stdout.print("\n", .{});
    try stdout.flush();
}
