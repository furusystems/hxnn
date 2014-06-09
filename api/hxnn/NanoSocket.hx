package hxnn;

import hxnn.NanoDomain;
import hxnn.NanoProtocol;
import hxnn.TransportAddress;

/**
 *
 */
class NanoSocket
{
    /**
     * References to the native nanomsg function implementations loaded through C FFI.
     */
    #if cpp
        private static var hxnn_bind:Socket->String->Int    = cpp.Lib.load("nanomsg", "hxnn_bind", 2);
        private static var hxnn_close:Socket->Void          = cpp.Lib.load("nanomsg", "hxnn_close", 1);
        private static var hxnn_connect:Socket->String->Int = cpp.Lib.load("nanomsg", "hxnn_connect", 2);
        private static var hxnn_recv:Socket->Int->String    = cpp.Lib.load("nanomsg", "hxnn_recv", 2);
        private static var hxnn_recv_all:Socket->String     = cpp.Lib.load("nanomsg", "hxnn_recv_all", 1);
        private static var hxnn_send:Socket->String->Int    = cpp.Lib.load("nanomsg", "hxnn_send", 2);
        private static var hxnn_shutdown:Socket->Int->Void  = cpp.Lib.load("nanomsg", "hxnn_shutdown", 2);
        private static var hxnn_socket:Int->Int->Socket     = cpp.Lib.load("nanomsg", "hxnn_socket", 2);
    #elseif neko
        private static var hxnn_bind:Socket->String->Int    = neko.Lib.load("nanomsg", "hxnn_bind", 2);
        private static var hxnn_close:Socket->Void          = neko.Lib.load("nanomsg", "hxnn_close", 1);
        private static var hxnn_connect:Socket->String->Int = neko.Lib.load("nanomsg", "hxnn_connect", 2);
        private static var hxnn_recv:Socket->Int->String    = neko.Lib.load("nanomsg", "hxnn_recv", 2);
        private static var hxnn_recv_all:Socket->String     = neko.Lib.load("nanomsg", "hxnn_recv_all", 1);
        private static var hxnn_send:Socket->String->Int    = neko.Lib.load("nanomsg", "hxnn_send", 2);
        private static var hxnn_shutdown:Socket->Int->Void  = neko.Lib.load("nanomsg", "hxnn_shutdown", 2);
        private static var hxnn_socket:Int->Int->Socket     = neko.Lib.load("nanomsg", "hxnn_socket", 2);
    #end

    /**
     *
     */
    private var handle:Socket;

    /**
     *
     */
    private var conns:Array<Int>;


    // works
    public function new(domain:NanoDomain, protocol:NanoProtocol):Void
    {
        this.handle = NanoSocket.hxnn_socket(domain, protocol);
        this.conns  = new Array<Int>();
    }

    // works
    public function bind(address:TransportAddress):Int
    {
        var cnx:Int = NanoSocket.hxnn_bind(this.handle, address.toString());
        this.conns.push(cnx);

        return cnx;
    }

    public function close():Void
    {
        for (cnx in Lambda.array(this.conns)) {
            this.shutdown(cnx);
        }
        NanoSocket.hxnn_close(this.handle);
    }

    // works
    public function connect(address:TransportAddress):Int
    {
        var cnx:Int = NanoSocket.hxnn_connect(this.handle, address.toString());
        this.conns.push(cnx);

        return cnx;
    }

    private function shutdown(cnx:Int):Void
    {
        NanoSocket.hxnn_shutdown(this.handle, cnx);
        this.conns.remove(cnx);
    }

    // works
    public function read(bytes:Int):String
    {
        return NanoSocket.hxnn_recv(this.handle, bytes);
    }

    // works
    public function readAll():String
    {
        return NanoSocket.hxnn_recv_all(this.handle);
    }

    // works
    public function write(msg:String):Int
    {
        return NanoSocket.hxnn_send(this.handle, msg);
    }
}


/**
 * Local typedef for nanomsg sockets as Int isn't very meaningful.
 */
private typedef Socket = Int;
