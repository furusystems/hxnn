// Copyright (c) MaddinXx 2014
#include "NanoMsg.hpp"
#include <hx/CFFI.h>

#include "nanomsg/nn.h"
// scalability protocols
#include "nanomsg/pair.h"
#include "nanomsg/reqrep.h"
#include "nanomsg/pubsub.h"
#include "nanomsg/survey.h"
#include "nanomsg/pipeline.h"
#include "nanomsg/bus.h"
// transport mechanisms
#include "nanomsg/inproc.h"
#include "nanomsg/ipc.h"
#include "nanomsg/tcp.h"

extern "C"
{
    static void finalize_socket(value sock)
    {
        hxnn_close(sock);
    }

    // http://nanomsg.org/v0.3/nn_bind.3.html
    static value hxnn_bind(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, string);

        int bind = nn_bind(val_socket(sock), val_string(address));
        if (bind < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(bind);
    }

    // http://nanomsg.org/v0.3/nn_close.3.html
    static value hxnn_close(value sock)
    {
        val_check(sock, socket);

        int ret = nn_close(val_socket(sock));
        if (ret != 0) {
           val_throw(alloc_int(nn_errno()));
       }

       return val_null;
    }

    // http://nanomsg.org/v0.3/nn_connect.3.html
    static value hxnn_connect(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, string);

        int bind = nn_connect(val_socket(sock), val_string(address));
        if (bind < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(bind);
    }

    // http://nanomsg.org/v0.3/nn_getsockopt.3.html
    static value hxnn_getsockopt(value sock, value level, value option)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);

        // get option size
        int    opt       = val_int(option);
        if (opt < 0) opt = -opt;
        size_t optsize   = 1;
        while ((opt = opt / 10) > 1) {
            ++optsize;
        }

        void* buf = NULL;
        int ret = nn_setsockopt(val_socket(sock), val_int(level), val_int(option), &buf, optsize);
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int((intptr_t)buf);
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv(value sock, value length, value flags)
    {
        val_check(sock, socket);
        val_check(length, int);
        val_check(flags, int);

        char buf[val_int(length)];
        int recv = nn_recv(val_socket(sock), buf, sizeof(buf), val_int(flags));
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_string((char*)buf);
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv_all(value sock, value flags)
    {
        val_check(sock, socket);
        val_check(flags, int);

        void* buf = NULL;
        int recv  = nn_recv(val_socket(sock), &buf, NN_MSG, val_int(flags));
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_string((char*)buf);
    }

    // http://nanomsg.org/v0.3/nn_send.3.html
    static value hxnn_send(value sock, value message, value flags)
    {
        val_check(sock, socket);
        val_check(message, string);
        val_check(flags, int);

        int sent = nn_send(val_socket(sock), val_string(message), val_strlen(message), val_int(flags));
        if (sent < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(sent);
    }

    // http://nanomsg.org/v0.3/nn_setsockopt.3.html
    static value hxnn_setsockopt(value sock, value level, value option, value optval)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);
        val_check(optval, int);

        // get option size
        int    opt       = val_int(option);
        if (opt < 0) opt = -opt;
        size_t optsize   = 1;
        while ((opt = opt / 10) > 1) {
            ++optsize;
        }

        int ret = nn_setsockopt(val_socket(sock), val_int(level), val_int(option), (void*)(intptr_t)val_int(optval), optsize);
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return val_null;
    }

    // http://nanomsg.org/v0.3/nn_shutdown.3.html
    static value hxnn_shutdown(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, int);

        int ret = nn_shutdown(val_socket(sock), val_int(address));
        if (sock != 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return val_null;
    }

    // http://nanomsg.org/v0.3/nn_socket.3.html
    static value hxnn_socket(value domain, value protocol)
    {
        val_check(domain, int);
        val_check(protocol, int);

        socket sock = nn_socket(val_int(domain), val_int(protocol));
        if (sock < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }
        value val = alloc_socket(sock);
        val_gc((value)&val, finalize_socket);

        return val;
    }
}

DEFINE_PRIM(hxnn_bind, 2);
DEFINE_PRIM(hxnn_close, 1);
DEFINE_PRIM(hxnn_connect, 2);
DEFINE_PRIM(hxnn_getsockopt, 3);
DEFINE_PRIM(hxnn_recv, 3);
DEFINE_PRIM(hxnn_recv_all, 2);
DEFINE_PRIM(hxnn_send, 3);
DEFINE_PRIM(hxnn_setsockopt, 4);
DEFINE_PRIM(hxnn_shutdown, 2);
DEFINE_PRIM(hxnn_socket, 2);
