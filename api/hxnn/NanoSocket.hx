package hxnn;

import hxnn.NanoDomain;
import hxnn.NanoException;
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
        private static var hxnn_recv:Socket->Int->String                = cpp.Lib.load("nanomsg", "hxnn_recv", 2);
        private static var hxnn_recv_all:Socket->String                 = cpp.Lib.load("nanomsg", "hxnn_recv_all", 1);
        private static var hxnn_send:Socket->String->Int                = cpp.Lib.load("nanomsg", "hxnn_send", 2);
        private static var hxnn_shutdown:Socket->Connection->Int        = cpp.Lib.load("nanomsg", "hxnn_shutdown", 2);
        private static var hxnn_socket:NanoDomain->NanoProtocol->Socket = cpp.Lib.load("nanomsg", "hxnn_socket", 2);
    #elseif neko
        private static var hxnn_bind:Socket->String->Connection         = neko.Lib.load("nanomsg", "hxnn_bind", 2);
        private static var hxnn_close:Socket->Void                      = neko.Lib.load("nanomsg", "hxnn_close", 1);
        private static var hxnn_connect:Socket->String->Connection      = neko.Lib.load("nanomsg", "hxnn_connect", 2);
        private static var hxnn_recv:Socket->Int->String                = neko.Lib.load("nanomsg", "hxnn_recv", 2);
        private static var hxnn_recv_all:Socket->String                 = neko.Lib.load("nanomsg", "hxnn_recv_all", 1);
        private static var hxnn_send:Socket->String->Int                = neko.Lib.load("nanomsg", "hxnn_send", 2);
        private static var hxnn_shutdown:Socket->Connection->Int        = neko.Lib.load("nanomsg", "hxnn_shutdown", 2);
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
     * @var hxnn.NanoDomain   domain the domain type to use
     * @var hxnn.NanoProtocol protocol the protocol to use
     */
    public function new(domain:NanoDomain, protocol:NanoProtocol):Void
    {
        this.handle = NanoSocket.hxnn_socket(domain, protocol);
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
            var cnx:Connection = NanoSocket.hxnn_bind(this.handle, address.toString());
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
            var cnx:Int = NanoSocket.hxnn_connect(this.handle, address.toString());
            this.conns.push(cnx);

            return cnx;
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
        try {
            NanoSocket.hxnn_shutdown(this.handle, cnx);
            this.conns.remove(cnx);
        } catch (ex:Dynamic) {
            if (ex != 35 && ex != 60) { // TODO: resource temporary unavailable (35)
                throw new NanoException(ex);
            }
        }
    }

    /**
     * Reads n bytes from the Socket's input stream.
     *
     * @param Int bytes the number of bytes to read
     *
     * @return String the read message
     */
    public function read(bytes:Int):String
    {
        try {
            return NanoSocket.hxnn_recv(this.handle, bytes);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Reads everything from the Socket.
     *
     * @return String
     */
    public function readAll():String
    {
        try {
            return NanoSocket.hxnn_recv_all(this.handle);
        } catch (ex:Dynamic) {
            throw new NanoException(ex);
        }
    }

    /**
     * Writes the provided message to the Socket.
     *
     * @param String msg the message to write
     *
     * @return Int the number of written bytes
     */
    public function write(msg:String):Int
    {
        try {
            return NanoSocket.hxnn_send(this.handle, msg);
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
