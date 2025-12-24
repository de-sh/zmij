const std = @import("std");
const time = std.time;
const zmij = @import("zmij.zig");

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    const test_values = [_]f64{ 123.456, std.math.pi, 1e-20, 1.2345678901234567e300, 0.0 };

    try stdout.print("{s:<43} | {s:<43}\n", .{ "std.fmt (ns)", "zmij (ns)" });
    try stdout.print("{s:-<43}-|-{s:-<43}\n", .{ "", "" });
    try stdout.print("{s:<25} | {s:<15} | {s:<25} | {s:<15}\n", .{ "Value", "Avg. Time", "Value", "Avg. Time" });
    try stdout.print("{s:-<25}-|-{s:-<15}-|-{s:-<25}-|-{s:-<15}\n", .{ "", "", "", "" });

    inline for (test_values) |val| {
        const iterations = 1_000_000;
        var buf: [128]u8 = undefined;

        // Benchmark std.fmt
        var timer = try time.Timer.start();
        var i: u64 = 0;
        while (i < iterations) : (i += 1) {
            _ = try std.fmt.bufPrint(&buf, "{e}", .{val});
            std.mem.doNotOptimizeAway(&buf);
        }
        const std_time = timer.read();

        // Benchmark zmij
        timer = try time.Timer.start();
        i = 0;
        while (i < iterations) : (i += 1) {
            _ = zmij.dtoa(val, &buf);
            std.mem.doNotOptimizeAway(&buf);
        }
        const zmij_time = timer.read();

        const std_val = try std.fmt.bufPrint(&buf, "{e}", .{val});
        var zmij_buf = zmij.Buffer{};
        const zmij_val = zmij_buf.format(val);

        const std_avg = @as(f64, @floatFromInt(std_time)) / iterations;
        const zmij_avg = @as(f64, @floatFromInt(zmij_time)) / iterations;

        try stdout.print("{s:<25} | {d:>15} | {s:<25} | {d:>15}\n", .{ std_val, std_avg, zmij_val, zmij_avg });
    }

    try stdout.flush();
}
