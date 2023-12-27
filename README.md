# Simple Websocket server and client

Contains a websocket server and client, written in zig and using the libwebsockets library.

When the client connects to the server, it will be sent a simple Json payload which it will parse and display over the terminal.

## Building

Clone repo with:

```sh
git clone https://github.com/kdchambers/websockets-zig --recursive
cd websockets-zig
```

Download zig using the following link and add the zig executable to PATH

https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.1834+f36ac227b.tar.xz


### Building libwebsocket

```sh
cd deps/libwebsocket
mkdir build
cd build
cmake ..
make
```

Then run either of the following:

```sh
zig build run-client
```

```
zig build run-server
```

NOTE: Operates on port 7681

Example output from client:

```sh
[kchambers@192 websockets-zig]$ zig build run-client
[2023/12/26 21:38:30:5766] N: lws_create_context: LWS: 4.3.99-v4.3.0-329-g2631f825, NET CLI SRV H1 H2 WS SS-JSON-POL ConMon IPv6-absent
[2023/12/26 21:38:30:5767] N: __lws_lc_tag:  ++ [wsi|0|pipe] (1)
[2023/12/26 21:38:30:5768] N: __lws_lc_tag:  ++ [vh|0|netlink] (1)
[2023/12/26 21:38:30:5776] N: __lws_lc_tag:  ++ [vh|1|_ss_default||-1] (2)
info: Connecting to server..
[2023/12/26 21:38:30:5893] N: __lws_lc_tag:  ++ [wsicli|0|WS/h1/_ss_default/localhost] (1)
[2023/12/26 21:38:30:5895] N: [wsicli|0|WS/h1/_ss_default/localhost]: lws_client_connect_3_connect: trying 127.0.0.1
[2023/12/26 21:38:30:5897] N: __lws_lc_tag:  ++ [wsiSScli|0|captive_portal_detect] (1)
[2023/12/26 21:38:30:5898] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: (unset) -> LWSSSCS_CREATING
[2023/12/26 21:38:30:5898] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_CREATING -> LWSSSCS_POLL
[2023/12/26 21:38:30:5898] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_POLL -> LWSSSCS_CONNECTING
[2023/12/26 21:38:30:5898] N: __lws_lc_tag:  ++ [wsicli|1|GET/h1/connectivitycheck.android.com/([wsiSScli|0|ca] (2)
[2023/12/26 21:38:30:6855] N: [wsicli|1|GET/h1/connectivitycheck.android.com/([wsiSScli|0|ca]: lws_client_connect_3_connect: trying 64.233.185.138
info: Connection updated to websocket
info: Message from server: [
{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328},
{"ev": "T","sym": "MSFT","x": 4,"i": "12345","z": 3,"p": 114.125,"s": 100,"c": [0,12],"t": 1536036818784,"q": 3681328}
]
info: Payload contains 5 objects
item 0: {"ev": T, "sym": "MSFT", "x": 4, "i": "12345", "z": 3, "p": 114.125, "s": 100, "t": 1536036818784, "q": 3681328 }
item 1: {"ev": T, "sym": "MSFT", "x": 4, "i": "12345", "z": 3, "p": 114.125, "s": 100, "t": 1536036818784, "q": 3681328 }
item 2: {"ev": T, "sym": "MSFT", "x": 4, "i": "12345", "z": 3, "p": 114.125, "s": 100, "t": 1536036818784, "q": 3681328 }
item 3: {"ev": T, "sym": "MSFT", "x": 4, "i": "12345", "z": 3, "p": 114.125, "s": 100, "t": 1536036818784, "q": 3681328 }
item 4: {"ev": T, "sym": "MSFT", "x": 4, "i": "12345", "z": 3, "p": 114.125, "s": 100, "t": 1536036818784, "q": 3681328 }
[2023/12/26 21:38:30:8806] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_CONNECTING -> LWSSSCS_CONNECTED
[2023/12/26 21:38:30:8806] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_CONNECTED -> LWSSSCS_QOS_ACK_REMOTE
[2023/12/26 21:38:30:8806] N: lws_system_cpd_set: setting CPD result OK
[2023/12/26 21:38:30:8807] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_QOS_ACK_REMOTE -> LWSSSCS_DISCONNECTED
[2023/12/26 21:38:30:8807] N: [wsiSScli|0|captive_portal_detect]: lws_ss_check_next_state_ss: LWSSSCS_DISCONNECTED -> LWSSSCS_DESTROYING
[2023/12/26 21:38:30:8807] N: __lws_lc_untag:  -- [wsiSScli|0|captive_portal_detect] (0) 290.960ms
[2023/12/26 21:38:30:8808] N: __lws_lc_untag:  -- [wsicli|1|GET/h1/connectivitycheck.android.com/([wsiSScli|0|ca] (1) 291.015ms
```