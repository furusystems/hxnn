package hxnn;

import haxe.PosInfos;
import hxnn.NanoException;

/**
 * Exceptions to be thrown when Exceptions from the C FFI need to be wrapped
 * or for any other kind of errors related to nanomsg.
 */
class NativeNanoException extends NanoException
{
    /**
     * @{inherit}
     */
    public function new(msg:String = "Exception thrown by called FF", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
