const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    // Check endianness of the selected target
    if (target.result.cpu.arch.endian() == .big) {
        std.debug.print("Error: Big-endian is not supported.\n", .{});
        std.process.exit(1);
    }

    const lib = b.addLibrary(.{
        .name = "zmij",
        .root_module = b.createModule(.{
            .root_source_file = b.path("zmij.zig"),
            .target = target,
        }),
    });
    b.installArtifact(lib);

    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("test.zig"),
            .target = target,
        }),
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);
}
