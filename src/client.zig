//!
//! Simple websocket client
//!

const std = @import("std");
const lws = @import("lws.zig");
const yy = @import("yyjson.zig");

var interrupted: bool = false;

fn handleJsonParse(
    wsi: ?*lws.lws,
    reason: lws.callback_reasons,
    user: ?*anyopaque,
    input: ?*anyopaque,
    len: usize,
) callconv(.C) c_int {
    switch (@as(lws.CallbackReasons, @enumFromInt(reason))) {
        .client_connection_error => {
            if (len >= 0 and input != null) {
                const error_message: [*]const u8 = @ptrCast(input.?);
                std.log.err("Failed to connect to server: Message: {s}", .{error_message[0..len]});
            } else {
                std.log.err("Failed to connect to server", .{});
            }
        },
        .established => std.log.info("Connection established", .{}),
        .client_recieve => {
            const json_payload: [:0]u8 = @as([*:0]u8, @ptrCast(input.?))[0..len :0];
            std.log.info("Message from server: {s}", .{json_payload});

            const doc: *yy.doc = yy.read(json_payload, json_payload.len, 0);
            const root: *yy.val = yy.doc_get_root(doc);

            if (!yy.is_arr(root)) {
                std.log.err("Json format: root object is not an array", .{});
                return 0;
            }

            const array_len: usize = yy.arr_size(root);

            std.log.info("Payload contains {d} objects", .{array_len});

            var iter: yy.arr_iter = yy.arr_iter_with(root);
            var index: usize = 0;

            while (yy.arr_iter_next(&iter)) |root_obj| {
                const ev: *yy.val = yy.obj_get(root_obj, "ev");
                const sym: *yy.val = yy.obj_get(root_obj, "sym");
                const x: *yy.val = yy.obj_get(root_obj, "x");
                const i: *yy.val = yy.obj_get(root_obj, "i");
                const z: *yy.val = yy.obj_get(root_obj, "z");
                const p: *yy.val = yy.obj_get(root_obj, "p");
                const s: *yy.val = yy.obj_get(root_obj, "s");
                const c: *yy.val = yy.obj_get(root_obj, "c");
                const t: *yy.val = yy.obj_get(root_obj, "t");
                const q: *yy.val = yy.obj_get(root_obj, "q");

                if (!yy.is_str(ev)) {
                    std.log.err("Json format: ev is not a string", .{});
                    break;
                }

                if (!yy.is_str(sym)) {
                    std.log.err("Json format: `sym` is not a string", .{});
                    break;
                }

                if (!yy.is_num(x)) {
                    std.log.err("Json format: `x` is not a numeric value", .{});
                    break;
                }

                if (!yy.is_str(i)) {
                    std.log.err("Json format: `i` is not a string", .{});
                    break;
                }

                if (!yy.is_num(z)) {
                    std.log.err("Json format: `z` is not a numeric value", .{});
                    break;
                }

                if (!yy.is_real(p)) {
                    std.log.err("Json format: `p` is not a real value", .{});
                    break;
                }

                if (!yy.is_num(s)) {
                    std.log.err("Json format: `s` is not a numeric value", .{});
                    break;
                }

                if (!yy.is_arr(c)) {
                    std.log.err("Json format: `c` is not an array", .{});
                    break;
                }

                if (!yy.is_num(t)) {
                    std.log.err("Json format: `t` is not a numeric value", .{});
                    break;
                }

                if (!yy.is_num(q)) {
                    std.log.err("Json format: `q` is not a numeric value", .{});
                    break;
                }

                //
                // NOTE: I'm skipping the array `c` for formatting simplicity
                //

                std.debug.print("item {d}: ", .{index});
                std.debug.print("{{\"ev\": {s}, \"sym\": \"{s}\", \"x\": {d}, \"i\": \"{s}\", \"z\": {d}, \"p\": {d}, \"s\": {d}, \"t\": {d}, \"q\": {d} }}\n", .{
                    yy.get_str(ev),
                    yy.get_str(sym),
                    yy.get_int(x),
                    yy.get_str(i),
                    yy.get_int(z),
                    yy.get_real(p),
                    yy.get_int(s),
                    yy.get_uint(t),
                    yy.get_uint(q),
                });

                index += 1;
            }

            yy.doc_free(doc);
        },
        .ws_peer_initiated_close => return 0,
        .client_writeable => {
            const message_buffer_size: usize = 128;
            var message_buffer: [lws.pre + message_buffer_size]u8 = undefined;

            message_buffer[lws.pre + 0] = 'h';
            message_buffer[lws.pre + 1] = 'e';
            message_buffer[lws.pre + 2] = 'l';
            message_buffer[lws.pre + 3] = 'l';
            message_buffer[lws.pre + 4] = 'o';

            _ = lws.write(wsi, &message_buffer[lws.pre], 5, lws.WRITE_TEXT);
        },
        .client_established => {
            std.log.info("Connection updated to websocket", .{});
            _ = lws.callback_on_writable(wsi);
        },
        .protocol_init => {},
        else => {
            // const r: lws.CallbackReasons = @enumFromInt(reason);
            // std.log.info("Reason: {s}", .{@tagName(r)});
        },
    }

    return lws.callback_http_dummy(wsi, reason, user, input, len);
}

const PSConnectionStatus = enum {
    disconnected,
    connected,
    authenticated,
};

var ps_connection_status: PSConnectionStatus = .disconnected;

fn handlePolystocks(
    wsi: ?*lws.lws,
    reason: lws.callback_reasons,
    user: ?*anyopaque,
    input: ?*anyopaque,
    len: usize,
) callconv(.C) c_int {
    switch (@as(lws.CallbackReasons, @enumFromInt(reason))) {
        .client_connection_error => {
            if (len >= 0 and input != null) {
                const error_message: [*]const u8 = @ptrCast(input.?);
                std.log.err("Failed to connect to server: Message: {s}", .{error_message[0..len]});
            } else {
                std.log.err("Failed to connect to server", .{});
            }
        },
        .established => std.log.info("Connection established", .{}),
        .client_recieve => {
            const json_payload: [:0]u8 = @as([*:0]u8, @ptrCast(input.?))[0..len :0];
            std.log.info("Message from server: {s}", .{json_payload});

            switch (ps_connection_status) {
                .disconnected => {
                    const doc: *yy.doc = yy.read(json_payload, json_payload.len, 0);
                    const root: *yy.val = yy.doc_get_root(doc);

                    if (!yy.is_arr(root)) {
                        std.log.err("Json format: root object is not an array", .{});
                        return 0;
                    }

                    const array_len: usize = yy.arr_size(root);

                    std.log.info("Payload contains {d} objects", .{array_len});

                    var iter: yy.arr_iter = yy.arr_iter_with(root);
                    var index: usize = 0;

                    while (yy.arr_iter_next(&iter)) |root_obj| {
                        const ev: *yy.val = yy.obj_get(root_obj, "ev");
                        const status: *yy.val = yy.obj_get(root_obj, "status");
                        const message: *yy.val = yy.obj_get(root_obj, "message");

                        if (!yy.is_str(ev)) {
                            std.log.err("Json format: `ev` is not a string", .{});
                            break;
                        }

                        if (!yy.is_str(status)) {
                            std.log.err("Json format: `status` is not a string", .{});
                            break;
                        }

                        if (!yy.is_str(message)) {
                            std.log.err("Json format: `message` is not a string", .{});
                            break;
                        }

                        const status_string = yy.get_str(status);
                        const status_string_len = std.mem.len(status_string);
                        if (std.mem.eql(u8, "connected", status_string[0..status_string_len])) {
                            ps_connection_status = .connected;
                            _ = lws.callback_on_writable(wsi);
                        }

                        index += 1;
                    }

                    yy.doc_free(doc);
                },
                .connected => {
                    const doc: *yy.doc = yy.read(json_payload, json_payload.len, 0);
                    const root: *yy.val = yy.doc_get_root(doc);

                    if (!yy.is_arr(root)) {
                        std.log.err("Json format: root object is not an array", .{});
                        return 0;
                    }

                    const array_len: usize = yy.arr_size(root);

                    std.log.info("Payload contains {d} objects", .{array_len});

                    var iter: yy.arr_iter = yy.arr_iter_with(root);
                    while (yy.arr_iter_next(&iter)) |root_obj| {
                        const ev: *yy.val = yy.obj_get(root_obj, "ev");
                        const status: *yy.val = yy.obj_get(root_obj, "status");
                        const message: *yy.val = yy.obj_get(root_obj, "message");

                        if (!yy.is_str(ev)) {
                            std.log.err("Json format: `ev` is not a string", .{});
                            break;
                        }

                        if (!yy.is_str(status)) {
                            std.log.err("Json format: `status` is not a string", .{});
                            break;
                        }

                        if (!yy.is_str(message)) {
                            std.log.err("Json format: `message` is not a string", .{});
                            break;
                        }

                        const status_string = yy.get_str(status);
                        const status_string_len = std.mem.len(status_string);
                        if (std.mem.eql(u8, "auth_success", status_string[0..status_string_len])) {
                            ps_connection_status = .authenticated;
                            _ = lws.callback_on_writable(wsi);
                        }

                        //
                        // Expecting only one element in array
                        //
                        break;
                    }

                    yy.doc_free(doc);
                },
                .authenticated => {},
            }
        },
        .ws_peer_initiated_close => return 0,
        .client_writeable => {
            switch (ps_connection_status) {
                .connected => {
                    std.log.info("Authenticating with server", .{});
                    const auth_payload = "{\"action\":\"auth\",\"params\":\"3lUIeZ6hwWI3eYxJQXOplFOWnDopAXpg\"}";
                    const message_buffer_size: usize = 128;
                    var message_buffer: [lws.pre + message_buffer_size]u8 = undefined;
                    @memcpy(message_buffer[lws.pre .. lws.pre + auth_payload.len], auth_payload);
                    _ = lws.write(wsi, &message_buffer[lws.pre], auth_payload.len, lws.WRITE_TEXT);
                },
                .authenticated => {
                    std.log.info("Sending subscription request", .{});
                    const auth_payload = "{\"action\":\"subscribe\",\"params\":\"AM.LPL\"}";
                    const message_buffer_size: usize = 128;
                    var message_buffer: [lws.pre + message_buffer_size]u8 = undefined;
                    @memcpy(message_buffer[lws.pre .. lws.pre + auth_payload.len], auth_payload);
                    _ = lws.write(wsi, &message_buffer[lws.pre], auth_payload.len, lws.WRITE_TEXT);
                },
                .disconnected => {},
            }
        },
        .client_established => {
            std.log.info("Connection updated to websocket", .{});
            _ = lws.callback_on_writable(wsi);
        },
        .protocol_init => {},
        else => {
            // const r: lws.CallbackReasons = @enumFromInt(reason);
            // std.log.info("Reason: {s}", .{@tagName(r)});
        },
    }

    return lws.callback_http_dummy(wsi, reason, user, input, len);
}

const protocols: [3]lws.protocols = .{
    .{
        .name = "example-json-parse",
        .callback = &handleJsonParse,
        .per_session_data_size = 0,
        .rx_buffer_size = 0,
        .user = null,
        .tx_packet_size = 0,
    },
    .{
        .name = "example-polystocks",
        .callback = &handlePolystocks,
        .per_session_data_size = 0,
        .rx_buffer_size = 0,
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

const extensions: [2]lws.extension = .{
    .{
        .name = "permessage-deflate",
        .callback = lws.extension_callback_pm_deflate,
        .client_offer = "permessage-deflate" ++
            "; client_no_context_takeover" ++
            "; client_max_window_bits",
    },
    .{
        .name = null,
        .callback = null,
        .client_offer = null,
    },
};

var context: *lws.context = undefined;

const backoff_ms = [_]u32{ 1000, 2000, 3000, 4000, 5000 };

const retry_policy: lws.retry_bo_t = .{
    .retry_ms_table = &backoff_ms,
    .retry_ms_table_count = backoff_ms.len,
    .conceal_count = backoff_ms.len,
    .secs_since_valid_ping = 400,
    .secs_since_valid_hangup = 400,
    .jitter_percent = 0,
};

fn connectToPolystocks(sul: ?*lws.sorted_usec_list_t) callconv(.C) void {
    _ = sul;
    std.log.info("Connecting to polystocks..", .{});
    const ccinfo: lws.client_connect_info = .{
        .context = context,
        .address = "delayed.polygon.io",
        .port = 443,
        .path = "/stocks",
        .host = "delayed.polygon.io",
        .origin = "delayed.polygon.io",
        .ssl_connection = lws.LCCSCF_USE_SSL | lws.LCCSCF_PRIORITIZE_READS,
        .protocol = null,
        .local_protocol_name = protocols[1].name,
    };

    if (lws.client_connect_via_info(&ccinfo) == null) {
        std.log.err("Failed to connect to server", .{});
    }
}

fn connectToLocalJsonServer(sul: ?*lws.sorted_usec_list_t) callconv(.C) void {
    _ = sul;
    std.log.info("Connecting to locally hosted json server..", .{});
    const ccinfo: lws.client_connect_info = .{
        .context = context,
        .address = "localhost",
        .port = 7681,
        .path = "/",
        .host = "localhost",
        .origin = "localhost",
        .ssl_connection = 0,
        .protocol = protocols[0].name,
        .local_protocol_name = protocols[0].name,
    };

    if (lws.client_connect_via_info(&ccinfo) == null) {
        std.log.err("Failed to connect to server", .{});
    }
}

var conn_list: lws.sorted_usec_list_t = undefined;

pub fn main() !u8 {
    var context_creation_info: lws.context_creation_info = undefined;
    lws.context_info_defaults(&context_creation_info, null);

    context_creation_info.options = lws.SERVER_OPTION_DO_SSL_GLOBAL_INIT;
    context_creation_info.port = lws.CONTEXT_PORT_NO_LISTEN;
    context_creation_info.protocols = &protocols;
    context_creation_info.extensions = &extensions;

    const log_level: lws.LogLevel = .{ .user = true, .err = true, .warn = true, .notice = true };
    lws.setLogLevel(@bitCast(log_level), null);

    context = lws.create_context(&context_creation_info) orelse {
        std.log.err("Failed to create lws context", .{});
        return 1;
    };

    //
    // Uncomment to connect to accompanying json server
    //
    // lws.sul_schedule(context, 0, &conn_list, connectToLocalJsonServer, 1);

    lws.sul_schedule(context, 0, &conn_list, connectToPolystocks, 1);

    var result: i32 = 0;
    while (result >= 0 and !interrupted) {
        result = lws.service(context, 0);
    }

    std.log.info("Terminating..", .{});

    lws.context_destroy(context);

    return 0;
}
