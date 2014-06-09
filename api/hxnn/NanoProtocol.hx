package hxnn;

/**
 * Enum for the scalability protocols nanomsg supports.
 */
@:enum
abstract NanoProtocol(Int) to Int
{
     // http://nanomsg.org/v0.3/nn_pair.7.html
    var NN_PAIR = 16;

    // http://nanomsg.org/v0.3/nn_reqrep.7.html
    var NN_REQ = 48;
    var NN_REP = 49;

    // http://nanomsg.org/v0.3/nn_pubsub.7.html
    var NN_PUB = 32;
    var NN_SUB = 33;

    // http://nanomsg.org/v0.3/nn_survey.7.html
    var NN_SURVEYOR   = 96;
    var NN_RESPONDENT = 97;

    // http://nanomsg.org/v0.3/nn_pipeline.7.html
    var NN_PUSH = 80;
    var NN_PULL = 81;

    // http://nanomsg.org/v0.3/nn_bus.7.html
    var NN_BUS = 112;
}
