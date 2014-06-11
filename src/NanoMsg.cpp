#include "NanoMsg.hpp"

#include <nanomsg/nn.h>
// scalability protocols
#include <nanomsg/pair.h>
#include <nanomsg/reqrep.h>
#include <nanomsg/pubsub.h>
#include <nanomsg/survey.h>
#include <nanomsg/pipeline.h>
#include <nanomsg/bus.h>
// transport mechanisms
#include <nanomsg/inproc.h>
#include <nanomsg/ipc.h>
#include <nanomsg/tcp.h>

extern "C"
{
    // called by val_gc when a nanomsg socket gets garbage collected
    static void finalize_socket(value sock)
    {
        const socket vsock = val_socket(sock);

        gc_enter_blocking();
        nn_setsockopt(vsock, NN_SOL_SOCKET, NN_LINGER, 0, sizeof(int));
        int ret = nn_close(vsock);
        gc_exit_blocking();
        if (ret != 0) {
           val_throw(alloc_int(nn_errno()));
       }
    }

    // http://nanomsg.org/v0.3/nn_bind.3.html
    static value hxnn_bind(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, string);

        value val;
        int ret = nn_bind(val_socket(sock), val_string(address));
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else {
            val = alloc_int(ret);
        }

        return val;
    }

    // http://nanomsg.org/v0.3/nn_close.3.html
    static value hxnn_close(value sock)
    {
        val_check(sock, socket);
        finalize_socket(sock);

       return alloc_int(999);
    }

    // http://nanomsg.org/v0.3/nn_connect.3.html
    static value hxnn_connect(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, string);

        value val;
        int ret = nn_connect(val_socket(sock), val_string(address));
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else {
            val = alloc_int(ret);
        }

        return val;
    }

    // http://nanomsg.org/v0.3/nn_getsockopt.3.html
    // TODO: support string options
    static value hxnn_getsockopt(value sock, value level, value option)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);

        value val;
        size_t valsize = sizeof(val);
        int ret = nn_getsockopt(val_socket(sock), val_int(level), val_int(option), &val, &valsize);
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        }

        return val;
    }

    // http://nanomsg.org/v0.4/nn_poll.3.html
    static value hxnn_poll(value socks, value timeout)
    {
        val_check(socks, array);
        val_check(timeout, float);

        const size_t arr_size = val_array_size(socks);
        struct nn_pollfd pfd[arr_size];

        value current;
        for (int i = 0; i < arr_size; ++i)
        {
            current = val_array_i(socks, i);
            val_check(current, socket);
            pfd[i].fd     = val_socket(current);
            pfd[i].events = NN_POLLIN | NN_POLLOUT;
        }

        value val;
        int ret = nn_poll(pfd, arr_size, val_float(timeout));
        if (ret == -1) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else if (ret == 0) {
            val = alloc_int(0);
        }

        return val;
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv(value sock, value length, value flags)
    {
        val_check(sock, socket);
        val_check(length, int);
        val_check(flags, int);

        value val;
        char buf[val_int(length)];
        int recv = nn_recv(val_socket(sock), &buf, sizeof(buf), val_int(flags));
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else {
            val = alloc_string(buf);
        }
        free(buf);

        return val;
    }

    // http://nanomsg.org/v0.3/nn_recv.3.html
    static value hxnn_recv_all(value sock, value flags)
    {
        val_check(sock, socket);
        val_check(flags, int);

        value val;
        char* buf = NULL;
        int recv  = nn_recv(val_socket(sock), &buf, NN_MSG, val_int(flags));
        if (recv < 0) {
            val_throw(alloc_int(nn_errno()));
        } else {
            val = alloc_string(buf);
        }

        return val;
    }

    // http://nanomsg.org/v0.3/nn_send.3.html
    static value hxnn_send(value sock, value message, value flags)
    {
        val_check(sock, socket);
        val_check(message, string);
        val_check(flags, int);

        value val;
        int sent = nn_send(val_socket(sock), val_string(message), val_strlen(message) + 1, val_int(flags)); // +1 for \0
        if (sent < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else {
            val = alloc_int(sent);
        }

        return val;
    }

    // http://nanomsg.org/v0.3/nn_setsockopt.3.html
    static value hxnn_setsockopt(value sock, value level, value option, value optval)
    {
        val_check(sock, socket);
        val_check(level, int);
        val_check(option, int);

        const void* val;
        size_t size;
        if (val_is_int(optval)) {
            val  = (void*)(intptr_t)val_int(optval);
            size = sizeof(int);
        } else {
            val = val_string(optval);
            size = sizeof(val);
        }

        int ret = nn_setsockopt(val_socket(sock), val_int(level), val_int(option), &val, size);
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
        }

        return alloc_int(999);
    }

    // http://nanomsg.org/v0.3/nn_shutdown.3.html
    static value hxnn_shutdown(value sock, value address)
    {
        val_check(sock, socket);
        val_check(address, int);

        int ret = nn_shutdown(val_socket(sock), val_int(address));
        if (ret != 0) {
            val_throw(alloc_int(nn_errno()));
        }

        return alloc_int(999);
    }

    // http://nanomsg.org/v0.3/nn_socket.3.html
    static value hxnn_socket(value domain, value protocol)
    {
        val_check(domain, int);
        val_check(protocol, int);

        value val;
        int ret = nn_socket(val_int(domain), val_int(protocol));
        if (ret < 0) {
            val_throw(alloc_int(nn_errno()));
            val = alloc_int(999);
        } else {
            val = alloc_socket(ret);
            val_gc((value)&val, finalize_socket);
        }

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
