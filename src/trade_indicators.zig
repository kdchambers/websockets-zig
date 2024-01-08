const std = @import("std");
const yy = @import("yyjson.zig");
const ti = @cImport({
    @cInclude("indicators.h");
});

const trade_data: [:0]const u8 =
    \\[
    \\  {"ev":"A","sym":"NVDA","v":651,"av":36238006,"op":484.62,"vw":489.0876,"o":489.12,"c":489.07,"h":489.12,"l":489.07,"a":490.128,"z":36,"s":1704487368000,"e":1704487369000},
    \\  {"ev":"A","sym":"NVDA","v":264,"av":36237332,"op":484.62,"vw":489.1329,"o":489.1338,"c":489.1338,"h":489.1338,"l":489.1338,"a":490.128,"z":33,"s":1704487366000,"e":1704487367000},
    \\  {"ev":"A","sym":"NVDA","v":377,"av":36236662,"op":484.62,"vw":489.1204,"o":489.12,"c":489.12,"h":489.12,"l":489.12,"a":490.128,"z":25,"s":1704487362000,"e":1704487363000},
    \\  {"ev":"A","sym":"NVDA","v":700,"av":36236285,"op":484.62,"vw":489.0831,"o":489.09,"c":489.09,"h":489.09,"l":489.08,"a":490.128,"z":46,"s":1704487361000,"e":1704487362000},
    \\  {"ev":"A","sym":"NVDA","v":554,"av":36235585,"op":484.62,"vw":489.0725,"o":489.07,"c":489.07,"h":489.07,"l":489.07,"a":490.128,"z":92,"s":1704487360000,"e":1704487361000},
    \\  {"ev":"A","sym":"NVDA","v":821,"av":36235031,"op":484.62,"vw":489.0887,"o":489.095,"c":489.07,"h":489.095,"l":489.07,"a":490.128,"z":102,"s":1704487359000,"e":1704487360000},
    \\  {"ev":"A","sym":"NVDA","v":935,"av":36234210,"op":484.62,"vw":489.0879,"o":489.1599,"c":489.088,"h":489.1599,"l":489.06,"a":490.1281,"z":58,"s":1704487358000,"e":1704487359000},
    \\  {"ev":"A","sym":"NVDA","v":1294,"av":36233275,"op":484.62,"vw":489.0857,"o":489.08,"c":489.0859,"h":489.1,"l":489.08,"a":490.1281,"z":61,"s":1704487357000,"e":1704487358000},
    \\  {"ev":"A","sym":"NVDA","v":1128,"av":36231981,"op":484.62,"vw":489.0784,"o":489.12,"c":489.04,"h":489.12,"l":489.04,"a":490.1281,"z":43,"s":1704487356000,"e":1704487357000},
    \\  {"ev":"A","sym":"NVDA","v":501,"av":36230853,"op":484.62,"vw":489.1562,"o":489.15,"c":489.165,"h":489.165,"l":489.15,"a":490.1282,"z":31,"s":1704487355000,"e":1704487356000},
    \\  {"ev":"A","sym":"NVDA","v":3920,"av":36492980,"op":484.62,"vw":489.6827,"o":489.69,"c":489.68,"h":489.7158,"l":489.68,"a":490.1231,"z":130,"s":1704487532000,"e":1704487533000},
    \\  {"ev":"A","sym":"NVDA","v":219,"av":36493199,"op":484.62,"vw":489.6854,"o":489.685,"c":489.685,"h":489.685,"l":489.685,"a":490.1231,"z":43,"s":1704487533000,"e":1704487534000},
    \\  {"ev":"A","sym":"NVDA","v":121,"av":36493320,"op":484.62,"vw":489.71,"o":489.71,"c":489.71,"h":489.71,"l":489.71,"a":490.1231,"z":30,"s":1704487534000,"e":1704487535000},
    \\  {"ev":"A","sym":"NVDA","v":837,"av":36494157,"op":484.62,"vw":489.7208,"o":489.73,"c":489.7,"h":489.7499,"l":489.7,"a":490.1231,"z":34,"s":1704487535000,"e":1704487536000},
    \\  {"ev":"A","sym":"NVDA","v":961,"av":36495118,"op":484.62,"vw":489.7027,"o":489.69,"c":489.715,"h":489.7299,"l":489.69,"a":490.1231,"z":106,"s":1704487536000,"e":1704487537000},
    \\  {"ev":"A","sym":"NVDA","v":392,"av":36495510,"op":484.62,"vw":489.7105,"o":489.715,"c":489.7109,"h":489.715,"l":489.7109,"a":490.1231,"z":56,"s":1704487537000,"e":1704487538000},
    \\  {"ev":"A","sym":"NVDA","v":2399,"av":36497995,"op":484.62,"vw":489.6552,"o":489.69,"c":489.63,"h":489.7,"l":489.63,"a":490.1231,"z":85,"s":1704487539000,"e":1704487540000},
    \\  {"ev":"A","sym":"NVDA","v":155,"av":36498150,"op":484.62,"vw":489.6554,"o":489.65,"c":489.65,"h":489.65,"l":489.65,"a":490.1231,"z":31,"s":1704487540000,"e":1704487541000},
    \\  {"ev":"A","sym":"NVDA","v":366,"av":36498516,"op":484.62,"vw":489.6438,"o":489.65,"c":489.63,"h":489.65,"l":489.63,"a":490.1231,"z":28,"s":1704487541000,"e":1704487542000},
    \\  {"ev":"A","sym":"NVDA","v":925,"av":36499441,"op":484.62,"vw":489.6373,"o":489.6348,"c":489.657,"h":489.657,"l":489.63,"a":490.1231,"z":77,"s":1704487542000,"e":1704487543000},
    \\  {"ev":"A","sym":"NVDA","v":884,"av":36500325,"op":484.62,"vw":489.6119,"o":489.62,"c":489.6,"h":489.62,"l":489.6,"a":490.123,"z":31,"s":1704487543000,"e":1704487544000},
    \\  {"ev":"A","sym":"NVDA","v":1699,"av":36502024,"op":484.62,"vw":489.5598,"o":489.6,"c":489.54,"h":489.6,"l":489.54,"a":490.123,"z":67,"s":1704487544000,"e":1704487545000},
    \\  {"ev":"A","sym":"NVDA","v":6177,"av":36508201,"op":484.62,"vw":489.5582,"o":489.5702,"c":489.595,"h":489.6364,"l":489.52,"a":490.1229,"z":193,"s":1704487545000,"e":1704487546000}
    \\]
;

fn runExampleApp() !void {
    const doc: *yy.doc = yy.read(trade_data, trade_data.len, 0);
    const root: *yy.val = yy.doc_get_root(doc);

    if (!yy.is_arr(root)) {
        std.log.err("Json format: root object is not an array", .{});
        return error.JsonFormatInvalid;
    }

    const array_len: usize = yy.arr_size(root);

    std.log.info("Payload contains {d} objects", .{array_len});

    if (array_len == 0) {
        return;
    }

    var input_array: []f64 = std.heap.c_allocator.alloc(f64, array_len) catch |err| {
        std.log.err("Failed to allocate buffer for input. Error: {}", .{err});
        return err;
    };
    defer std.heap.c_allocator.free(input_array);

    var iter: yy.arr_iter = yy.arr_iter_with(root);
    var index: usize = 1;

    while (yy.arr_iter_next(&iter)) |root_obj| {
        const ev: *yy.val = yy.obj_get(root_obj, "ev");
        const sym: *yy.val = yy.obj_get(root_obj, "sym");
        const v: *yy.val = yy.obj_get(root_obj, "v");
        const av: *yy.val = yy.obj_get(root_obj, "av");
        const op: *yy.val = yy.obj_get(root_obj, "op");
        const vw: *yy.val = yy.obj_get(root_obj, "vw");
        const o: *yy.val = yy.obj_get(root_obj, "o");
        const c: *yy.val = yy.obj_get(root_obj, "c");
        const h: *yy.val = yy.obj_get(root_obj, "h");
        const l: *yy.val = yy.obj_get(root_obj, "l");
        const a: *yy.val = yy.obj_get(root_obj, "a");
        const z: *yy.val = yy.obj_get(root_obj, "z");
        const s: *yy.val = yy.obj_get(root_obj, "s");
        const e: *yy.val = yy.obj_get(root_obj, "e");

        if (!yy.is_str(ev)) {
            std.log.err("Json format: `ev` is not a string", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_str(sym)) {
            std.log.err("Json format: `sym` is not a string", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_uint(v)) {
            std.log.err("Json format: `v` is not an integer", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_uint(av)) {
            std.log.err("Json format: `av` is not an integer", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(op)) {
            std.log.err("Json format: `op` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(vw)) {
            std.log.err("Json format: `vw` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(o)) {
            std.log.err("Json format: `o` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(c)) {
            std.log.err("Json format: `c` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(h)) {
            std.log.err("Json format: `h` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(l)) {
            std.log.err("Json format: `l` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_num(a)) {
            std.log.err("Json format: `a` is not a number", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_uint(z)) {
            std.log.err("Json format: `z` is not an integer", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_uint(s)) {
            std.log.err("Json format: `s` is not an integer", .{});
            return error.JsonFormatInvalid;
        }

        if (!yy.is_uint(e)) {
            std.log.err("Json format: `e` is not an integer", .{});
            return error.JsonFormatInvalid;
        }

        const av_value: u64 = yy.get_uint(av);
        input_array[input_array.len - index] = @floatFromInt(av_value);

        index += 1;
    }

    {
        //
        // Simple Moving Average
        //

        const period: f64 = 3.0;
        const options: [1]f64 = .{period};
        const start: c_int = ti.ti_sma_start(&options);
        const input_array_len: c_int = @intCast(input_array.len);
        const output_len: c_int = input_array_len - start;
        const output_array: []f64 = std.heap.c_allocator.alloc(f64, @intCast(output_len)) catch |err| {
            std.log.info("Failed to allocate buffer for output array. Error {}", .{err});
            return err;
        };
        defer std.heap.c_allocator.free(output_array);

        const all_inputs: [1][*]f64 = .{input_array.ptr};
        const all_outputs: [1][*]f64 = .{output_array.ptr};

        const retcode = ti.ti_sma(@intCast(input_array.len), &all_inputs, &options, &all_outputs);

        if (retcode != ti.TI_OKAY) {
            std.log.err("Failed to calculate Simple Moving Average for input data", .{});
            return error.CalcSMAFailed;
        }

        std.debug.print("\nSimple Moving Average (SMA) of Accumulated Volume w/ Period of {d}\n", .{period});
        for (output_array, 0..) |value, i| {
            std.debug.print("  {d:2} -- {d:.2}\n", .{ i, value });
        }
    }

    {
        //
        // Relative Strength Index
        //

        const period: f64 = 5.0;
        const options: [1]f64 = .{period};
        const start: c_int = ti.ti_rsi_start(&options);
        const input_array_len: c_int = @intCast(input_array.len);
        const output_len: c_int = input_array_len - start;
        const output_array: []f64 = std.heap.c_allocator.alloc(f64, @intCast(output_len)) catch |err| {
            std.log.info("Failed to allocate buffer for output array. Error {}", .{err});
            return err;
        };
        defer std.heap.c_allocator.free(output_array);

        const all_inputs: [1][*]f64 = .{input_array.ptr};
        const all_outputs: [1][*]f64 = .{output_array.ptr};

        const retcode = ti.ti_rsi(@intCast(input_array.len), &all_inputs, &options, &all_outputs);

        if (retcode != ti.TI_OKAY) {
            std.log.err("Failed to calculate Relative Strength Index for input data", .{});
            return error.CalcRSIFailed;
        }

        std.debug.print("\nRelative Strength Index (RSI) of Accumulated Volume w/ Period of {d}\n", .{period});
        for (output_array, 0..) |value, i| {
            std.debug.print("  {d:2} -- {d:.2}\n", .{ i, value });
        }
    }
}

pub fn main() u8 {
    runExampleApp() catch |err| {
        //
        // Convert all possible errors into a return code to return
        //
        return switch (err) {
            error.JsonFormatInvalid => 1,
            error.OutOfMemory => 2,
            error.CalcSMAFailed => 3,
            error.CalcRSIFailed => 4,
        };
    };
    return 0;
}
