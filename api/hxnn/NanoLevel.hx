package hxnn;

/**
 *
 */
@:enum
abstract NanoLevel(Int) from Int to Int
{
    // transport-specific levels
    var NN_INPROC     = -1;
    var NN_IPC        = -2;
    var NN_TCP        = -3;

    // generic socket-level
    var NN_SOL_SOCKET = 0;

    // socket-type-specific levels
    var NN_PAIR       = 16;
    var NN_REQ        = 48;
    var NN_REP        = 49;
    var NN_PUB        = 32;
    var NN_SUB        = 33;
    var NN_PUSH       = 80;
    var NN_PULL       = 81;
    var NN_SURVEYOR   = 96;
    var NN_RESPONDENT = 97;
    var NN_BUS        = 112;
}
