import hxnn.*;
import hxstd.vm.Thread;

class Pipeline
{
    public static function main():Void
    {
        var s1   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PUSH);
        var s2   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PULL);
        var s3   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PULL);
        var addr = new IPCAddress("/tmp/hxnn.sock");

        s1.bind(addr);
        s2.connect(addr);
        s3.connect(addr);

        var parent:Thread = Thread.current();
        Thread.create(function():Void {
            for (i in 0...1000) {
                s1.write("Hey from Pusher");
            }
            s1.close();
            parent.sendMessage(null);
        });
        Thread.create(function():Void {
            for (i in 0...1000) {
                trace(s2.readAll());
            }
            s2.close();
            parent.sendMessage(null);
        });
        Thread.create(function():Void {
            for (i in 0...1000) {
                trace(s3.readAll());
            }
            s3.close();
            parent.sendMessage(null);
        });

        Thread.readMessage(true);
        Thread.readMessage(true);
        Thread.readMessage(true);
    }
}
