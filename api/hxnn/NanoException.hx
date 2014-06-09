package hxnn;

import haxe.PosInfos;
import hxstd.Exception;

/**
 * Exceptions to be thrown when Exceptions from the C FFI need to be wrapped
 * or for any other kind of errors related to nanomsg.
 */
class NanoException extends Exception
{
    /**
     * @{inherit}
     */
    public function new(msg:String = "Exception thrown by nanomsg C FFI", ?info:PosInfos):Void
    {
        super(msg, info);
    }
}
