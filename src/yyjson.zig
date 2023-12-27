//!
//! Simple wrapper over the yyjson library to remove c-style prefixes
//!

const std = @import("std");
const yyjson = @cImport({
    @cInclude("yyjson.h");
});

//
// Functions
//

pub const read = yyjson.yyjson_read;
pub const doc_get_root = yyjson.yyjson_doc_get_root;
pub const arr_size = yyjson.yyjson_arr_size;
pub const arr_get_first = yyjson.yyjson_arr_get_first;
pub const unsafe_yyjson_get_next = yyjson.unsafe_yyjson_get_next;
pub const doc_free = yyjson.yyjson_doc_free;

pub const arr_iter_with = yyjson.yyjson_arr_iter_with;
pub const arr_iter_next = yyjson.yyjson_arr_iter_next;

pub const obj_get = yyjson.yyjson_obj_get;
pub const get_str = yyjson.yyjson_get_str;
pub const get_int = yyjson.yyjson_get_int;
pub const get_uint = yyjson.yyjson_get_uint;
pub const get_real = yyjson.yyjson_get_real;

pub const is_null = yyjson.yyjson_is_null;
pub const is_true = yyjson.yyjson_is_true;
pub const is_false = yyjson.yyjson_is_false;
pub const is_bool = yyjson.yyjson_is_bool;
pub const is_uint = yyjson.yyjson_is_uint;
pub const is_sint = yyjson.yyjson_is_sint;
pub const is_int = yyjson.yyjson_is_int;
pub const is_real = yyjson.yyjson_is_real;
pub const is_num = yyjson.yyjson_is_num;
pub const is_str = yyjson.yyjson_is_str;
pub const is_arr = yyjson.yyjson_is_arr;
pub const is_obj = yyjson.yyjson_is_obj;
pub const is_ctn = yyjson.yyjson_is_ctn;
pub const is_raw = yyjson.yyjson_is_raw;

//
// Structures
//

pub const doc = yyjson.yyjson_doc;
pub const val = yyjson.yyjson_val;
pub const arr_iter = yyjson.yyjson_arr_iter;
