package hxnn;

import hxnn.TransportAddress;

/**
 * Inter-process transport allows for sending messages between processes within a single box.
 *
 * The implementation uses native IPC mechanism provided by the local operating system and
 * the IPC addresses are thus OS-specific.
 *
 * @link http://nanomsg.org/v0.3/nn_ipc.7.html
 */
class IPCAddress extends TransportAddress
{
    /**
     * Constructor to initialize a new IPCAddress.
     *
     * @param String address the address to use
     */
    public function new(address:String):Void
    {
        super(address);
    }

    /**
     * @{inherit}
     */
    override public function toString():String
    {
        return "ipc://" + this.address;
    }
}
