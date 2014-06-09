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

extern "C" {
    // http://nanomsg.org/v0.3/nn_bind.3.html
    static value hxnn_bind(value sock, value address) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }
        if (!val_is_string(address)) {
            val_throw(alloc_int(EINVAL));
            return val_null;
        }

        int bind = nn_bind(val_socket(sock), val_string(address));
        if (bind < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(bind);
    }

    // http://nanomsg.org/v0.3/nn_close.3.html
    static value hxnn_close(value sock) {
        val_check(sock, socket);
        int ret = nn_close(val_socket(sock));
        if (ret != 0) {
           val_throw(alloc_int(nn_errno()));
       }

       return alloc_int(ret);
    }

    // http://nanomsg.org/v0.3/nn_connect.3.html
    static value hxnn_connect(value sock, value address) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }
        if (!val_is_string(address)) {
            val_throw(alloc_int(EINVAL));
            return val_null;
        }

        int bind = nn_connect(val_socket(sock), val_string(address));
        if (bind < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(bind);
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv(value sock, value length) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }
        val_check(length, int);

        char buf[val_int(length)];
        int recv = nn_recv(val_socket(sock), buf, sizeof(buf), 0);
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        } else {
            return alloc_string((char*)buf);
        }
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv_all(value sock) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }

        void* buf = NULL;
        int recv  = nn_recv(val_socket(sock), &buf, NN_MSG, 0);
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        } else {
            return alloc_string((char*)buf);
        }
    }

    // http://nanomsg.org/v0.3/nn_send.3.html
    static value hxnn_send(value sock, value message) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }
        val_check(message, string);

        int sent = nn_send(val_socket(sock), val_string(message), val_strlen(message), 0);
        if (sent < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(sent);
    }

    // http://nanomsg.org/v0.3/nn_shutdown.3.html
    static value hxnn_shutdown(value sock, value address) {
        if (!val_is_socket(sock)) {
            val_throw(alloc_int(EBADF));
            return val_null;
        }
        if (!val_is_int(address)) {
            val_throw(alloc_int(EINVAL));
            return val_null;
        }

        int ret = nn_shutdown(val_socket(sock), val_int(address));
        if (sock != 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_int(ret);
    }

    // http://nanomsg.org/v0.3/nn_socket.3.html
    // TODO: add socket to gc_finalizer to ensure everything is closed
    static value hxnn_socket(value domain, value protocol) {
        if (!val_is_int(domain) || !val_is_int(protocol)) {
            val_throw(alloc_int(EINVAL));
            return val_null;
        }

        socket sock = nn_socket(val_int(domain), val_int(protocol));
        if (sock < 0) {
            val_throw(alloc_int(nn_errno()));
            return val_null;
        }

        return alloc_socket(sock);
    }
}

DEFINE_PRIM(hxnn_bind, 2);
DEFINE_PRIM(hxnn_close, 1);
DEFINE_PRIM(hxnn_connect, 2);
DEFINE_PRIM(hxnn_recv, 2);
DEFINE_PRIM(hxnn_recv_all, 1);
DEFINE_PRIM(hxnn_send, 2);
DEFINE_PRIM(hxnn_shutdown, 2);
DEFINE_PRIM(hxnn_socket, 2);
