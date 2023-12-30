const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const client_exe = b.addExecutable(.{
        .name = "zws_client",
        .root_source_file = .{ .path = "src/client.zig" },
        .target = target,
        .optimize = optimize,
    });

    client_exe.addIncludePath(.{ .path = "deps/libwebsockets/include" });
    client_exe.addIncludePath(.{ .path = "deps/libwebsockets/build" });
    client_exe.addIncludePath(.{ .path = "deps/yyjson/src" });

    client_exe.addCSourceFile(.{ .file = .{ .path = "deps/yyjson/src/yyjson.c" }, .flags = &.{} });
    client_exe.addObjectFile(.{ .path = "deps/libwebsockets/build/lib/libwebsockets.a" });

    client_exe.linkLibC();
    client_exe.linkSystemLibrary("openssl");
    client_exe.linkSystemLibrary("z");

    b.installArtifact(client_exe);

    const server_exe = b.addExecutable(.{
        .name = "zws_server",
        .root_source_file = .{ .path = "src/server.zig" },
        .target = target,
        .optimize = optimize,
    });

    server_exe.addIncludePath(.{ .path = "deps/libwebsockets/include" });
    server_exe.addIncludePath(.{ .path = "deps/libwebsockets/build" });
    server_exe.linkLibC();

    server_exe.addObjectFile(.{ .path = "deps/libwebsockets/build/lib/libwebsockets.a" });

    server_exe.linkSystemLibrary("openssl");

    b.installArtifact(server_exe);

    const run_server_cmd = b.addRunArtifact(server_exe);
    const run_client_cmd = b.addRunArtifact(client_exe);

    run_server_cmd.step.dependOn(b.getInstallStep());
    run_client_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_server_cmd.addArgs(args);
    }

    if (b.args) |args| {
        run_client_cmd.addArgs(args);
    }

    const run_server_step = b.step("run-server", "Run the server");
    run_server_step.dependOn(&run_server_cmd.step);

    const run_client_step = b.step("run-client", "Run the client");
    run_client_step.dependOn(&run_client_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
