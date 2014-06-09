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

        Thread.create(function():Void {
            while (true) {
                s1.write("Hey from 1st Thread");
                trace(s1.readAll());
            }
        });
        Thread.create(function():Void {
            while (true) {
                s2.write("Hey from 2nd Thread");
                trace(s2.readAll());
            }
        });

        Sys.sleep(10);
    }
}
