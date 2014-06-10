package hxnn;

/**
 * Enum for generic socket options (NN_SOL_SOCKET level).
 *
 * @link http://nanomsg.org/v0.3/nn_getsockopt.3.html
 */
@:enum
abstract NanoOption(Int) to Int
{
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
}
