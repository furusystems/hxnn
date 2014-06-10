package hxnn;

/**
 * Enum for generic socket options.
 */
@:enum
abstract NanoOption(Int) from Int to Int
{
    // http://nanomsg.org/v0.3/nn_getsockopt.3.html
    var NN_LINGER            = 1;
    var NN_SNDBUF            = 2;
    var NN_RCVBUF            = 3;
    var NN_SNDTIMEO          = 4;
    var NN_RCVTIMEO          = 5;
    var NN_RECONNECT_IVL     = 6;
    var NN_RECONNECT_IVL_MAX = 7;
    var NN_SNDPRIO           = 8;
    var NN_SNDFD             = 10;
    var NN_RCVFD             = 11;
    var NN_DOMAIN            = 12;
    var NN_PROTOCOL          = 13;
    var NN_IPV4ONLY          = 14;
    var NN_SOCKET_NAME       = 15;

    // http://nanomsg.org/v0.3/nn_reqrep.7.html
    var NN_REQ_RESEND_IVL = 1;

    // http://nanomsg.org/v0.3/nn_pubsub.7.html
    var NN_SUB_SUBSCRIBE   = 1;
    var NN_SUB_UNSUBSCRIBE = 2;

    // http://nanomsg.org/v0.3/nn_survey.7.html
    var NN_SURVEYOR_DEADLINE = 1;
}
