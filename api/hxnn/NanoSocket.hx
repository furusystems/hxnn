package hxnn;

#if cpp
    import cpp.Lib;
#elseif neko
    import neko.Lib;
#end
import hxnn.NanoDomain;
import hxnn.NanoException;
import hxnn.NanoFlag;
import hxnn.NanoLevel;
import hxnn.NanoOption;
import hxnn.NanoProtocol;
import hxnn.TransportAddress;

/**
 * Wrapper class around the native nanomsg functions provided through the Haxe C FFI:
 *
 * @link http://nanomsg.org/
 */
class NanoSocket
{
    /**
     * References to the native nanomsg function implementations loaded through C FFI.
     */
    #if cpp
        private static var hxnn_bind:Socket->String->Connection         = cpp.Lib.load("nanomsg", "hxnn_bind", 2);
        private static var hxnn_close:Socket->Void                      = cpp.Lib.load("nanomsg", "hxnn_close", 1);
        private static var hxnn_connect:Socket->String->Connection      = cpp.Lib.load("nanomsg", "hxnn_connect", 2);
        private static var hxnn_getsockopt:Socket->Int->Int->Int        = cpp.Lib.load("nanomsg", "hxnn_getsockopt", 3);
        private static var hxnn_recv:Socket->Int->NanoFlag->String      = cpp.Lib.load("nanomsg", "hxnn_recv", 3);
        private static var hxnn_recv_all:Socket->NanoFlag->String       = cpp.Lib.load("nanomsg", "hxnn_recv_all", 2);
        private static var hxnn_send:Socket->String->NanoFlag->Int      = cpp.Lib.load("nanomsg", "hxnn_send", 3);
        private static var hxnn_setsockopt:Socket->NanoLevel->NanoOption->Int->Void = cpp.Lib.load("nanomsg", "hxnn_setsockopt", 4);
        private static var hxnn_shutdown:Socket->Connection->Void       = cpp.Lib.load("nanomsg", "hxnn_shutdown", 2);
        private static var hxnn_socket:NanoDomain->NanoProtocol->Socket = cpp.Lib.load("nanomsg", "hxnn_socket", 2);
    #elseif neko
        private static var hxnn_bind:Socket->String->Connection         = neko.Lib.load("nanomsg", "hxnn_bind", 2);
        private static var hxnn_close:Socket->Void                      = neko.Lib.load("nanomsg", "hxnn_close", 1);
        private static var hxnn_connect:Socket->String->Connection      = neko.Lib.load("nanomsg", "hxnn_connect", 2);
        private static var hxnn_getsockopt:Socket->Int->Int->Int        = neko.Lib.load("nanomsg", "hxnn_getsockopt", 3);
        private static var hxnn_recv:Socket->Int->NanoFlag->String      = neko.Lib.load("nanomsg", "hxnn_recv", 3);
        private static var hxnn_recv_all:Socket->NanoFlag->String       = neko.Lib.load("nanomsg", "hxnn_recv_all", 2);
        private static var hxnn_send:Socket->String->NanoFlag->Int      = neko.Lib.load("nanomsg", "hxnn_send", 3);
        private static var hxnn_setsockopt:Socket->NanoLevel->NanoOption->Int->Void = neko.Lib.load("nanomsg", "hxnn_setsockopt", 4);
        private static var hxnn_shutdown:Socket->Connection->Void       = neko.Lib.load("nanomsg", "hxnn_shutdown", 2);
        private static var hxnn_socket:NanoDomain->NanoProtocol->Socket = neko.Lib.load("nanomsg", "hxnn_socket", 2);
    #end

    /**
     * Stores the underlaying nanomsg Socket.
     *
     * @var hxnn.NanoSocket.Socket;
     */
    private var handle:Null<Socket>;

    /**
     * Stores the Connections the Socket has been binded/connected to.
     *
     * @var Array<hxnn.NanoSocket.Connection>
     */
    private var conns:Array<Connection>;


    /**
     * Constructor to initialize a new NanoSocket instance.
     *
     * @param hxnn.NanoDomain   domain the domain type to use
     * @param hxnn.NanoProtocol protocol the protocol to use
     */
    public function new(domain:NanoDomain, protocol:NanoProtocol):Void
    {
        try {
            this.handle = NanoSocket.hxnn_socket(domain, protocol);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
        this.conns  = new Array<Connection>();
    }

    /**
     * Binds the Socket to the given address.
     *
     * @param hxnn.TransportAddress address the address to bind to
     *
     * @return hxnn.NanoSocket.Connection the opened Connection
     */
    public function bind(address:TransportAddress):Connection
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            var cnx:Connection = NanoSocket.hxnn_bind(this.handle, Lib.haxeToNeko(address.toString()));
            this.conns.push(cnx);

            return cnx;
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Closes the Socket and all open Connections it has.
     */
    public function close():Void
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        for (cnx in Lambda.array(this.conns)) { // make sure we iterate over copy
            this.shutdown(cnx);
        }

        try {
            NanoSocket.hxnn_close(this.handle);
            this.handle = null;
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Connects to the given TransportAddress.
     *
     * @param hxnn.TransportAddress address the address to connect to
     *
     * @return hxnn.NanoSocket.Connection
     */
    public function connect(address:TransportAddress):Connection
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            var cnx:Int = NanoSocket.hxnn_connect(this.handle, Lib.haxeToNeko(address.toString()));
            this.conns.push(cnx);

            return cnx;
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Returns the value of the given option.
     *
     * @param hxnn.NanoLevel  level  the level on which the option is valid
     * @param hxnn.NanoOption option the option to get the value for
     *
     * @return Int the option's value
     */
    public function getOption(level:NanoLevel, option:NanoOption):Int
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            return NanoSocket.hxnn_getsockopt(this.handle, level, option);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Reads n bytes from the Socket's input stream.
     *
     * If the 'NN_DONTWAIT' flag is passed, the action will be performed in non-blocking mode.
     *
     * @param Int           bytes the number of bytes to read
     * @param hxnn.NanoFlag flags flags defining how to receive the message
     *
     * @return String the read message
     */
    public function read(bytes:Int, flags:NanoFlag = 0):String
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            return Lib.nekoToHaxe( NanoSocket.hxnn_recv(this.handle, bytes, flags) );
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Reads everything from the Socket.
     *
     * If the 'NN_DONTWAIT' flag is passed, the action will be performed in non-blocking mode.
     *
     * @param hxnn.NanoFlag flags flags defining how to receive the message
     *
     * @return String
     */
    public function readAll(flags:NanoFlag = 0):String
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            return Lib.nekoToHaxe( NanoSocket.hxnn_recv_all(this.handle, flags) );
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Sets the value of the given option.
     *
     * @param hxnn.NanoLevel  level  the level on which the option is valid
     * @param hxnn.NanoOption option the option to set the value for
     * @param Int             value  the value to set for the option
     */
    public function setOption(level:NanoLevel, option:NanoOption, value:Int):Void
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            NanoSocket.hxnn_setsockopt(this.handle, level, option, value);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Closes the open Connection and removes it from Socket.
     *
     * @param hxnn.NanoSocket.Connection cnx the Connection to shutdown
     */
    public function shutdown(cnx:Connection):Void
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            NanoSocket.hxnn_shutdown(this.handle, cnx);
            this.conns.remove(cnx);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Writes the provided message to the Socket.
     *
     * If the 'NN_DONTWAIT' flag is passed, the action will be performed in non-blocking mode.
     *
     * @param String        msg   the message to write
     * @param hxnn.NanoFlag flags flags defining how to send the message
     *
     * @return Int the number of written bytes
     */
    public function write(msg:String, flags:NanoFlag = 0):Int
    {
        if (this.handle == null) {
            throw new NanoException("NanoSocket not available");
        }

        try {
            return NanoSocket.hxnn_send(this.handle, Lib.haxeToNeko(msg), flags);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }
}


/**
 * Typedef for nanomsg connections as Int isn't very meaningful.
 */
private typedef Connection = Int;

/**
 * Typedef for nanomsg sockets as Int isn't very meaningful.
 */
private typedef Socket = Int;
