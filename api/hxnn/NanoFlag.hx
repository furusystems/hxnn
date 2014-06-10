package hxnn;

/**
 *
 */
@:enum
abstract NanoFlag(Int) to Int
{
     // for: nn_recv
    var NN_DONTWAIT = 1;

    // http://nanomsg.org/v0.3/nn_reqrep.7.html
    var NN_REQ_RESEND_IVL  = 1;

    // http://nanomsg.org/v0.3/nn_pubsub.7.html
    var NN_SUB_SUBSCRIBE   = 1;
    var NN_SUB_UNSUBSCRIBE = 2;

    // http://nanomsg.org/v0.3/nn_survey.7.html
    var NN_SURVEYOR_DEADLINE = 1;
}
