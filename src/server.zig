//!
//! Simple websocket server
//!

const std = @import("std");
const lws = @import("lws.zig");

var gpa: std.mem.Allocator = undefined;

var json_requested: bool = true;
var shutdown_requested: bool = false;

const json_payload: [:0]const u8 =
    \\[
    \\{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
    \\{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
    \\{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
    \\{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
    \\{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328}
    \\]
;

var output_buffer: [2048]u8 = undefined;

const protocols: [3]lws.protocols = .{
    .{
        .name = "http",
        .callback = lws.callback_http_dummy,
        .per_session_data_size = 0,
        .rx_buffer_size = 0,
        .user = null,
        .tx_packet_size = 0,
    },
    .{
        .name = "example-json-parse",
        .callback = &handleJsonParse,
        .per_session_data_size = 0,
        .rx_buffer_size = 512,
        .user = null,
        .tx_packet_size = 0,
    },
    .{
        .name = null,
        .callback = null,
        .per_session_data_size = 0,
        .rx_buffer_size = 0,
        .user = null,
        .tx_packet_size = 0,
    },
};

pub fn main() !u8 {
    var context_creation_info: lws.context_creation_info = undefined;
    lws.context_info_defaults(&context_creation_info, null);

    gpa = std.heap.c_allocator;

    context_creation_info.port = 7681;
    context_creation_info.protocols = &protocols;
    context_creation_info.mounts = null;
    context_creation_info.options = lws.SERVER_OPTION_HTTP_HEADERS_SECURITY_BEST_PRACTICES_ENFORCE;

    const log_level: lws.LogLevel = .{ .user = true, .err = true, .warn = true, .notice = true };
    lws.setLogLevel(@bitCast(log_level), null);

    const context: *lws.context = lws.create_context(&context_creation_info) orelse {
        std.log.err("Failed to create lws context", .{});
        return 1;
    };

    while (!shutdown_requested) {
        if (lws.service(context, 0) < 0) {
            break;
        }
    }

    std.log.info("Terminating..", .{});

    lws.context_destroy(context);

    return 0;
}

fn handleJsonParse(
    wsi: ?*lws.lws,
    reason: lws.callback_reasons,
    user: ?*anyopaque,
    input: ?*anyopaque,
    len: usize,
) callconv(.C) c_int {
    _ = user;

    switch (@as(lws.CallbackReasons, @enumFromInt(reason))) {
        .server_writeable => {
            //
            // Socket is free for data transfer without blocking
            //
            if (json_requested) {
                std.log.info("Sending json payload to client", .{});
                @memcpy(output_buffer[lws.pre .. lws.pre + json_payload.len], json_payload[0..]);
                const bytes_sent = lws.write(wsi, &output_buffer[lws.pre], json_payload.len, lws.WRITE_TEXT);
                if (bytes_sent != json_payload.len) {
                    std.log.err("Bytes sent: {d} expected: {d}", .{ bytes_sent, json_payload.len });
                    shutdown_requested = true;
                }
                json_requested = false;
            }
        },
        .established => {
            _ = lws.callback_on_writable(wsi);
        },
        .recieve => {
            const message: [*]const u8 = @ptrCast(input.?);
            std.log.info("Message from client: {s}", .{message[0..len]});
        },
        else => {
            // std.log.info("Reason: {s}", .{@tagName(@as(lws.CallbackReasons, @enumFromInt(reason)))});
        },
    }

    return 0;
}
