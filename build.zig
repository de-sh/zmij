const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Check endianness of the selected target
    if (target.result.cpu.arch.endian() == .big) {
        std.debug.print("Error: Big-endian is not supported.\n", .{});
        std.process.exit(1);
    }

    const zmij_mod = b.createModule(.{
        .root_source_file = b.path("zmij.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "zmij",
        .root_module = zmij_mod,
    });
    b.installArtifact(lib);

    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);

    const test_mod = b.createModule(.{
        .root_source_file = b.path("test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tests = b.addTest(.{
        .root_module = test_mod,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    const exhaustive_mod = b.createModule(.{
        .root_source_file = b.path("test_exhaustive.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exhaustive_tests = b.addTest(.{
        .root_module = exhaustive_mod,
    });

    const run_exhaustive = b.addRunArtifact(exhaustive_tests);
    const exhaustive_step = b.step("test-exhaustive", "Run exhaustive f32 round-trip test (slow)");
    exhaustive_step.dependOn(&run_exhaustive.step);

    const bench_mod = b.createModule(.{
        .root_source_file = b.path("bench.zig"),
        .target = target,
        .optimize = optimize,
    });

    const bench = b.addExecutable(.{
        .name = "bench",
        .root_module = bench_mod,
    });

    const run_bench = b.addRunArtifact(bench);
    const bench_step = b.step("bench", "Run benchmarks");
    bench_step.dependOn(&run_bench.step);
}
