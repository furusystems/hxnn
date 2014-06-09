#ifndef NANOMSG_HPP
#define NANOMSG_HPP

#define IMPLEMENT_API
#define NEKO_COMPATIBLE 1
#include <hx/CFFI.h>

extern "C" {
    #define alloc_socket  alloc_int
    #define socket        int
    #define val_is_socket val_is_int
    #define val_socket    val_int
}

#endif
