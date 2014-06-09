import hxnn.*;
import hxstd.vm.Thread;

class Survey
{
    public static function main():Void
    {
        var s1   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_SURVEYOR);
        var s2   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_RESPONDENT);
        var s3   = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_RESPONDENT);
        var addr = new InProcAddress("/tmp/hxnn.sock");

        s1.bind(addr);
        s2.connect(addr);
        s3.connect(addr);

        var parent:Thread = Thread.current();
        Thread.create(function():Void {
            s1.write("Hey from surveyor Thread");
            trace(s1.readAll());
            trace(s1.readAll());
            s1.close();
            parent.sendMessage(null);
        });
        Thread.create(function():Void {
            trace(s2.readAll());
            s2.write("Hey back to surveyor Thread");
            s2.close();
            parent.sendMessage(null);
        });
        Thread.create(function():Void {
            trace(s3.readAll());
            s3.write("Hey back to surveyor Thread");
            s3.close();
            parent.sendMessage(null);
        });

        Thread.readMessage(true);
        Thread.readMessage(true);
        Thread.readMessage(true);
    }
}
