const std = @import("std");
const Io = std.Io;
const zmij = @import("zmij.zig");

pub fn main(init: std.process.Init) !void {
    var ts: Io.Timestamp = undefined;
    const test_values = [_]f64{ 123.456, std.math.pi, 1e-20, 1.2345678901234567e300, 0.0 };

    std.debug.print("{s:<25} | {s:<15} | {s:<25} | {s:<15}\n", .{ "Value(std.fmt)", "Avg. Time (ns)", "Value(zmij)", "Avg. Time (ns)" });
    std.debug.print("{s:-<25}-|-{s:-<15}-|-{s:-<25}-|-{s:-<15}\n", .{ "", "", "", "" });

    inline for (test_values) |val| {
        const iterations = 1_000_000;
        var buf: [128]u8 = undefined;

        // Benchmark std.fmt
        ts = Io.Clock.awake.now(init.io);
        for (0..iterations) |_| {
            _ = try std.fmt.float.render(&buf, val, .{ .mode = .scientific, .precision = null });
            std.mem.doNotOptimizeAway(&buf);
        }
        const std_time = ts.untilNow(init.io, .awake).toNanoseconds();

        // Benchmark zmij
        ts = Io.Clock.awake.now(init.io);
        for (0..iterations) |_| {
            _ = zmij.dtoa(val, &buf);
            std.mem.doNotOptimizeAway(&buf);
        }
        const zmij_time = ts.untilNow(init.io, .awake).toNanoseconds();

        const std_val = try std.fmt.bufPrint(&buf, "{e}", .{val});
        var zmij_buf = zmij.Buffer{};
        const zmij_val = zmij_buf.format(val);

        const std_avg = @as(f64, @floatFromInt(std_time)) / iterations;
        const zmij_avg = @as(f64, @floatFromInt(zmij_time)) / iterations;

        std.debug.print("{s:<25} | {d:>15} | {s:<25} | {d:>15}\n", .{ std_val, std_avg, zmij_val, zmij_avg });
    }
}
