import hxnn.*;
import hxstd.vm.Thread;

class Pair
{
    public static function main():Void
    {
        var s1   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PAIR);
        var s2   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PAIR);
        var addr = new IPCAddress("/tmp/hxnn.sock");

        s1.bind(addr);
        s2.connect(addr);

        var parent:Thread = Thread.current();
        Thread.create(function():Void {
            for (i in 0...1000) {
                s1.write("Hey from 1st Thread");
                trace(s1.readAll());
            }
            s1.close();
            parent.sendMessage(null);
        });
        Thread.create(function():Void {
            for (i in 0...1000) {
                s2.write("Hey from 2nd Thread");
                trace(s2.readAll());
            }
            s2.close();
            parent.sendMessage(null);
        });

        Thread.readMessage(true);
        Thread.readMessage(true);
    }
}
