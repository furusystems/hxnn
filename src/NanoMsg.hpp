#ifndef NANOMSG_HPP
#define NANOMSG_HPP

#define IMPLEMENT_API
#define NEKO_COMPATIBLE 1
#include <hx/CFFI.h>

extern "C" {
    // aliases
    #define alloc_socket  alloc_int
    #define socket        int
    #define val_is_socket val_is_int
    #define val_socket    val_int

    // functions
    static void finalize_socket(value sock);
    static value hxnn_bind(value sock, value address);
    static value hxnn_close(value sock);
    static value hxnn_connect(value sock, value address);
    static value hxnn_recv(value sock, value length);
    static value hxnn_recv_all(value sock);
    static value hxnn_send(value sock, value message);
    static value hxnn_shutdown(value sock, value address);
    static value hxnn_socket(value domain, value protocol);
}

#endif
