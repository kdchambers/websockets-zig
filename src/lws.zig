//!
//! Simple wrapper over the libwebsockets library to remove c-style prefixes
//!

const std = @import("std");
const assert = std.debug.assert;

const _lws = @cImport(@cInclude("libwebsockets.h"));

//
// Definitions
//

pub const LCCSCF_USE_SSL = _lws.LCCSCF_USE_SSL;
pub const LCCSCF_PRIORITIZE_READS = _lws.LCCSCF_PRIORITIZE_READS;

pub const pre: usize = 16;

pub const protocols = _lws.lws_protocols;
pub const CONTEXT_PORT_NO_LISTEN = _lws.CONTEXT_PORT_NO_LISTEN;
pub const SERVER_OPTION_HTTP_HEADERS_SECURITY_BEST_PRACTICES_ENFORCE = _lws.LWS_SERVER_OPTION_HTTP_HEADERS_SECURITY_BEST_PRACTICES_ENFORCE;

pub const WRITE_TEXT = _lws.LWS_WRITE_TEXT;

pub const LLL_USER = _lws.LLL_USER;
pub const LLL_ERR = _lws.LLL_ERR;
pub const LLL_WARN = _lws.LLL_WARN;
pub const LLL_NOTICE = _lws.LLL_NOTICE;

pub const callback_http_dummy = _lws.lws_callback_http_dummy;
pub const extension_callback_pm_deflate = _lws.lws_extension_callback_pm_deflate;

pub const SERVER_OPTION_DO_SSL_GLOBAL_INIT = _lws.LWS_SERVER_OPTION_DO_SSL_GLOBAL_INIT;

pub const sul_schedule = _lws.lws_sul_schedule;
pub const sorted_usec_list_t = _lws.lws_sorted_usec_list_t;

//
// Functions
//

pub const create_context = _lws.lws_create_context;
pub const service = _lws.lws_service;
pub const context_destroy = _lws.lws_context_destroy;
pub const write = _lws.lws_write;
pub const setLogLevel = _lws.lws_set_log_level;
pub const client_connect_via_info = _lws.lws_client_connect_via_info;
pub const callback_on_writable = _lws.lws_callback_on_writable;
pub const context_info_defaults = _lws.lws_context_info_defaults;

//
// Structures
//

pub const callback_reasons = _lws.lws_callback_reasons;
pub const lws = _lws.lws;
pub const client_connect_info = _lws.lws_client_connect_info;
pub const context_creation_info = _lws.lws_context_creation_info;
pub const context = _lws.lws_context;
pub const extension = _lws.lws_extension;
pub const retry_bo_t = _lws.lws_retry_bo_t;

pub const LogLevel = packed struct(c_int) {
    err: bool = false,
    warn: bool = false,
    notice: bool = false,
    info: bool = false,
    debug: bool = false,
    parser: bool = false,
    header: bool = false,
    ext: bool = false,
    client: bool = false,
    latency: bool = false,
    user: bool = false,
    reserved: u21 = 0,
};

//
// Make sure LogLevel API matches C headers
//
comptime {
    assert(@as(i32, @bitCast(LogLevel{ .err = true })) == _lws.LLL_ERR);
    assert(@as(i32, @bitCast(LogLevel{ .warn = true })) == _lws.LLL_WARN);
    assert(@as(i32, @bitCast(LogLevel{ .notice = true })) == _lws.LLL_NOTICE);
    assert(@as(i32, @bitCast(LogLevel{ .info = true })) == _lws.LLL_INFO);
    assert(@as(i32, @bitCast(LogLevel{ .debug = true })) == _lws.LLL_DEBUG);
    assert(@as(i32, @bitCast(LogLevel{ .parser = true })) == _lws.LLL_PARSER);
    assert(@as(i32, @bitCast(LogLevel{ .header = true })) == _lws.LLL_HEADER);
    assert(@as(i32, @bitCast(LogLevel{ .ext = true })) == _lws.LLL_EXT);
    assert(@as(i32, @bitCast(LogLevel{ .client = true })) == _lws.LLL_CLIENT);
    assert(@as(i32, @bitCast(LogLevel{ .latency = true })) == _lws.LLL_LATENCY);
    assert(@as(i32, @bitCast(LogLevel{ .user = true })) == _lws.LLL_USER);
}

pub const CallbackReasons = enum(i32) {
    client_connection_error = _lws.LWS_CALLBACK_CLIENT_CONNECTION_ERROR,
    openssl_load_extra_client_verify_certs = _lws.LWS_CALLBACK_OPENSSL_LOAD_EXTRA_CLIENT_VERIFY_CERTS,
    get_thread_id = _lws.LWS_CALLBACK_GET_THREAD_ID,
    http = _lws.LWS_CALLBACK_HTTP,
    established = _lws.LWS_CALLBACK_ESTABLISHED,
    ws_peer_initiated_close = _lws.LWS_CALLBACK_WS_PEER_INITIATED_CLOSE,
    client_filter_pre_establish = _lws.LWS_CALLBACK_CLIENT_FILTER_PRE_ESTABLISH,
    protocol_init = _lws.LWS_CALLBACK_PROTOCOL_INIT,
    server_new_client_instantiated = _lws.LWS_CALLBACK_SERVER_NEW_CLIENT_INSTANTIATED,
    wsi_destroy = _lws.LWS_CALLBACK_WSI_DESTROY,
    connecting = _lws.LWS_CALLBACK_CONNECTING,
    client_http_bind_protocol = _lws.LWS_CALLBACK_CLIENT_HTTP_BIND_PROTOCOL,
    protocol_destroy = _lws.LWS_CALLBACK_PROTOCOL_DESTROY,
    wsi_create = _lws.LWS_CALLBACK_WSI_CREATE,
    wsi_tx_credit_get = _lws.LWS_CALLBACK_WSI_TX_CREDIT_GET,
    openssl_load_extra_server_verify_certs = _lws.LWS_CALLBACK_OPENSSL_LOAD_EXTRA_SERVER_VERIFY_CERTS,
    openssl_perform_client_cert_verification = _lws.LWS_CALLBACK_OPENSSL_PERFORM_CLIENT_CERT_VERIFICATION,
    ssl_info = _lws.LWS_CALLBACK_SSL_INFO,
    openssl_perform_server_cert_verification = _lws.LWS_CALLBACK_OPENSSL_PERFORM_SERVER_CERT_VERIFICATION,
    http_body = _lws.LWS_CALLBACK_HTTP_BODY,
    http_body_completion = _lws.LWS_CALLBACK_HTTP_BODY_COMPLETION,
    http_file_completion = _lws.LWS_CALLBACK_HTTP_FILE_COMPLETION,
    http_writeable = _lws.LWS_CALLBACK_HTTP_WRITEABLE,
    closed_http = _lws.LWS_CALLBACK_CLOSED_HTTP,
    filter_http_connection = _lws.LWS_CALLBACK_FILTER_HTTP_CONNECTION,
    add_headers = _lws.LWS_CALLBACK_ADD_HEADERS,
    verify_basic_authorization = _lws.LWS_CALLBACK_VERIFY_BASIC_AUTHORIZATION,
    check_access_rights = _lws.LWS_CALLBACK_CHECK_ACCESS_RIGHTS,
    process_html = _lws.LWS_CALLBACK_PROCESS_HTML,
    http_bind_protocol = _lws.LWS_CALLBACK_HTTP_BIND_PROTOCOL,
    http_drop_protocol = _lws.LWS_CALLBACK_HTTP_DROP_PROTOCOL,
    http_confirm_upgrade = _lws.LWS_CALLBACK_HTTP_CONFIRM_UPGRADE,
    established_client_http = _lws.LWS_CALLBACK_ESTABLISHED_CLIENT_HTTP,
    closed_client_http = _lws.LWS_CALLBACK_CLOSED_CLIENT_HTTP,
    receive_client_http_read = _lws.LWS_CALLBACK_RECEIVE_CLIENT_HTTP_READ,
    receive_client_http = _lws.LWS_CALLBACK_RECEIVE_CLIENT_HTTP,
    completed_client_http = _lws.LWS_CALLBACK_COMPLETED_CLIENT_HTTP,
    client_http_writeable = _lws.LWS_CALLBACK_CLIENT_HTTP_WRITEABLE,
    http_redirect = _lws.LWS_CALLBACK_CLIENT_HTTP_REDIRECT,
    client_http_drop_protocol = _lws.LWS_CALLBACK_CLIENT_HTTP_DROP_PROTOCOL,
    closed = _lws.LWS_CALLBACK_CLOSED,
    server_writeable = _lws.LWS_CALLBACK_SERVER_WRITEABLE,
    recieve = _lws.LWS_CALLBACK_RECEIVE,
    recieve_pong = _lws.LWS_CALLBACK_RECEIVE_PONG,
    filter_protocol_connection = _lws.LWS_CALLBACK_FILTER_PROTOCOL_CONNECTION,
    confirm_extension_okay = _lws.LWS_CALLBACK_CONFIRM_EXTENSION_OKAY,
    ws_server_bind_protocol = _lws.LWS_CALLBACK_WS_SERVER_BIND_PROTOCOL,
    ws_server_drop_protocol = _lws.LWS_CALLBACK_WS_SERVER_DROP_PROTOCOL,
    client_established = _lws.LWS_CALLBACK_CLIENT_ESTABLISHED,
    client_closed = _lws.LWS_CALLBACK_CLIENT_CLOSED,
    client_append_handeshake_header = _lws.LWS_CALLBACK_CLIENT_APPEND_HANDSHAKE_HEADER,
    client_recieve = _lws.LWS_CALLBACK_CLIENT_RECEIVE,
    client_recieve_pong = _lws.LWS_CALLBACK_CLIENT_RECEIVE_PONG,
    client_writeable = _lws.LWS_CALLBACK_CLIENT_WRITEABLE,
    client_confirm_extention_supported = _lws.LWS_CALLBACK_CLIENT_CONFIRM_EXTENSION_SUPPORTED,
    ws_ext_defaults = _lws.LWS_CALLBACK_WS_EXT_DEFAULTS,
    filter_network_connection = _lws.LWS_CALLBACK_FILTER_NETWORK_CONNECTION,
    ws_client_bind_protocol = _lws.LWS_CALLBACK_WS_CLIENT_BIND_PROTOCOL,
    ws_client_drop_protocol = _lws.LWS_CALLBACK_WS_CLIENT_DROP_PROTOCOL,
    add_poll_fd = _lws.LWS_CALLBACK_ADD_POLL_FD,
    del_poll_fd = _lws.LWS_CALLBACK_DEL_POLL_FD,
    change_mode_poll_fd = _lws.LWS_CALLBACK_CHANGE_MODE_POLL_FD,
    lock_poll = _lws.LWS_CALLBACK_LOCK_POLL,
    unlock_poll = _lws.LWS_CALLBACK_UNLOCK_POLL,
    cgi = _lws.LWS_CALLBACK_CGI,
    cgi_terminated = _lws.LWS_CALLBACK_CGI_TERMINATED,
    cgi_stdin_data = _lws.LWS_CALLBACK_CGI_STDIN_DATA,
    cgi_stdin_completed = _lws.LWS_CALLBACK_CGI_STDIN_COMPLETED,
    cgi_process_attach = _lws.LWS_CALLBACK_CGI_PROCESS_ATTACH,
    session_info = _lws.LWS_CALLBACK_SESSION_INFO,
    gs_event = _lws.LWS_CALLBACK_GS_EVENT,
    http_pmo = _lws.LWS_CALLBACK_HTTP_PMO,
    raw_proxy_cli_rx = _lws.LWS_CALLBACK_RAW_PROXY_CLI_RX,
    raw_proxy_srv_rx = _lws.LWS_CALLBACK_RAW_PROXY_SRV_RX,
    raw_proxy_cli_close = _lws.LWS_CALLBACK_RAW_PROXY_CLI_CLOSE,
    raw_proxy_srv_close = _lws.LWS_CALLBACK_RAW_PROXY_SRV_CLOSE,
    raw_proxy_cli_writeable = _lws.LWS_CALLBACK_RAW_PROXY_CLI_WRITEABLE,
    raw_proxy_srv_writeable = _lws.LWS_CALLBACK_RAW_PROXY_SRV_WRITEABLE,
    raw_proxy_cli_adopt = _lws.LWS_CALLBACK_RAW_PROXY_CLI_ADOPT,
    raw_proxy_srv_adopt = _lws.LWS_CALLBACK_RAW_PROXY_SRV_ADOPT,
    raw_proxy_cli_bind_protocol = _lws.LWS_CALLBACK_RAW_PROXY_CLI_BIND_PROTOCOL,
    raw_proxy_srv_bind_protocol = _lws.LWS_CALLBACK_RAW_PROXY_SRV_BIND_PROTOCOL,
    raw_proxy_cli_drop_protocol = _lws.LWS_CALLBACK_RAW_PROXY_CLI_DROP_PROTOCOL,
    raw_proxy_srv_drop_protocol = _lws.LWS_CALLBACK_RAW_PROXY_SRV_DROP_PROTOCOL,
    raw_rx = _lws.LWS_CALLBACK_RAW_RX,
    raw_close = _lws.LWS_CALLBACK_RAW_CLOSE,
    raw_writeable = _lws.LWS_CALLBACK_RAW_WRITEABLE,
    raw_adopt = _lws.LWS_CALLBACK_RAW_ADOPT,
    raw_connected = _lws.LWS_CALLBACK_RAW_CONNECTED,
    raw_skt_bind_protocol = _lws.LWS_CALLBACK_RAW_SKT_BIND_PROTOCOL,
    raw_skt_drop_protocol = _lws.LWS_CALLBACK_RAW_SKT_DROP_PROTOCOL,
    raw_adopt_file = _lws.LWS_CALLBACK_RAW_ADOPT_FILE,
    raw_rx_file = _lws.LWS_CALLBACK_RAW_RX_FILE,
    raw_writeable_file = _lws.LWS_CALLBACK_RAW_WRITEABLE_FILE,
    raw_close_file = _lws.LWS_CALLBACK_RAW_CLOSE_FILE,
    raw_file_bind_protocol = _lws.LWS_CALLBACK_RAW_FILE_BIND_PROTOCOL,
    raw_file_drop_protocol = _lws.LWS_CALLBACK_RAW_FILE_DROP_PROTOCOL,
    timer = _lws.LWS_CALLBACK_TIMER,
    event_wait_cancelled = _lws.LWS_CALLBACK_EVENT_WAIT_CANCELLED,
    child_closing = _lws.LWS_CALLBACK_CHILD_CLOSING,
    vhost_cert_aging = _lws.LWS_CALLBACK_VHOST_CERT_AGING,
    vhost_cert_update = _lws.LWS_CALLBACK_VHOST_CERT_UPDATE,
    mqtt_new_client_instantiated = _lws.LWS_CALLBACK_MQTT_NEW_CLIENT_INSTANTIATED,
    mqtt_client_rx = _lws.LWS_CALLBACK_MQTT_CLIENT_RX,
    mqtt_unsubscribed = _lws.LWS_CALLBACK_MQTT_UNSUBSCRIBED,
    mqtt_drop_protocol = _lws.LWS_CALLBACK_MQTT_DROP_PROTOCOL,
    mqtt_client_closed = _lws.LWS_CALLBACK_MQTT_CLIENT_CLOSED,
    mqtt_ack = _lws.LWS_CALLBACK_MQTT_ACK,
    mqtt_resend = _lws.LWS_CALLBACK_MQTT_RESEND,
    mqtt_unsubscribe_timeout = _lws.LWS_CALLBACK_MQTT_UNSUBSCRIBE_TIMEOUT,
    mqtt_shadow_timeout = _lws.LWS_CALLBACK_MQTT_SHADOW_TIMEOUT,
    _,
};

const callback_reasons_user_start = _lws.LWS_CALLBACK_USER;
