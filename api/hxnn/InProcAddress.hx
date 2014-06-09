package hxnn;

import hxnn.TransportAddress;

/**
 * In-process transport allows to send messages between threads or modules inside a process.
 *
 * In-process address is an arbitrary case-sensitive string preceded by inproc:// protocol specifier.
 * All in-process addresses are visible from any module within the process.
 * They are not visible from outside of the process.
 *
 * @link http://nanomsg.org/v0.3/nn_ipc.7.html
 */
class InProcAddress extends TransportAddress
{
    /**
     * Constructor to initialize a new InProcAddress.
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
        return "inproc://" + this.address;
    }
}
