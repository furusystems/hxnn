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

       return alloc_int(ret);
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
    static value hxnn_getsockopt(value sock, value level, value option, value optsize)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);
        val_check(optsiz, int);

        void* buf = NULL;
        int ret = nn_setsockopt(val_sock(sock), val_int(level), val_int(option), &optval, val_int(optsize));
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int((int*)buf);
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv(value sock, value length)
    {
        val_check(sock, socket);
        val_check(length, int);

        char buf[val_int(length)];
        int recv = nn_recv(val_socket(sock), buf, sizeof(buf), 0);
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_string((char*)buf);
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv_all(value sock)
    {
        val_check(sock, socket);

        void* buf = NULL;
        int recv  = nn_recv(val_socket(sock), &buf, NN_MSG, 0);
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_string((char*)buf);
    }

    // http://nanomsg.org/v0.3/nn_send.3.html
    static value hxnn_send(value sock, value message)
    {
        val_check(sock, socket);
        val_check(message, string);

        int sent = nn_send(val_socket(sock), val_string(message), val_strlen(message), 0);
        if (sent < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(sent);
    }

    // http://nanomsg.org/v0.3/nn_setsockopt.3.html
    static value hxnn_setsockopt(value sock, value level, value option, value optval, value optsize)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);
        val_check(optval, int);
        val_check(optsiz, int);

        int ret = nn_setsockopt(val_sock(sock), val_int(level), val_int(option), val_int(optval), val_int(optsize));
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(ret);
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

        return alloc_int(ret);
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
DEFINE_PRIM(hxnn_getsockopt, 4);
DEFINE_PRIM(hxnn_recv, 2);
DEFINE_PRIM(hxnn_recv_all, 1);
DEFINE_PRIM(hxnn_send, 2);
DEFINE_PRIM(hxnn_setsockopt, 5);
DEFINE_PRIM(hxnn_shutdown, 2);
DEFINE_PRIM(hxnn_socket, 2);
