# Examples

> Various ready-to-use code examples showing how to use the `hxnn` library.

```haxe
import hxnn.*;
import hxstd.vm.Thread;

class Debug
{
    public static function main():Void
    {
        /* NN_PAIR */
        var s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PAIR);
        var s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PAIR);
        var addr = new InProcAddress("hxnn");

        s1.bind(addr); s2.connect(addr);

        s1.write("Hello from s1 to s2, sent via NN_PAIR");
        trace(s2.readAll());
        s2.write("Hello from s2 to s1, sent via NN_PAIR");
        trace(s1.readAll());

        s1.close();
        s2.close();

        /* NN_REQREP */
        s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_REQ);
        s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_REP);
        addr = new InProcAddress("hxnn");

        s2.bind(addr); s1.connect(addr);
        // s1.setOption(NanoLevel.NN_REQ, NanoOption.NN_REQ_RESEND_IVL, 5); // wait 5sec for reply before resending

        s1.write("Request from s1 to s2, sent via NN_REQ");
        trace(s2.readAll());
        s2.write("Reply from s2 to s1, sent via NN_REQ");
        trace(s1.readAll());

        s1.close();
        s2.close();

        /* PUBSUB
        s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PUB);
        s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_SUB);
        addr = new InProcAddress("hxnn");

        s1.bind(addr); s2.connect(addr);
        // TODO: how does this work?
        s2.setOption(NanoLevel.NN_SUB, NanoOption.NN_SUB_SUBSCRIBE, "A");

        s1.write("Publication from s1 to NN_SUBs, sent via NN_PUT");
        trace(s2.readAll());

        s1.close();
        s2.close();*/

        /* SURVEY */
        s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_SURVEYOR);
        s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_RESPONDENT);
        addr = new InProcAddress("hxnn");

        s1.bind(addr); s2.connect(addr);
        s1.setOption(NanoLevel.NN_SURVEYOR, NanoOption.NN_SURVEYOR_DEADLINE, 500); // wait half a second for votes

        s1.write("Question from s1 to s2, sent by NN_SURVEYOR");
        trace(s2.readAll());
        s2.write("Reply from s2 to s1, sent by NN_RESPONDENT");
        trace(s1.readAll());

        s1.close();
        s2.close();

        /* PIPELINE */
        s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PUSH);
        s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PULL);
        var s3 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_PULL);
        addr = new InProcAddress("hxnn");

        s1.bind(addr); s2.connect(addr); s3.connect(addr);

        s1.write("Push from s1 to s2/s3, sent by NN_PUSH");
        s1.write("Push from s1 to s2/s3, sent by NN_PUSH");
        trace(s2.readAll());
        // trace(s2.readAll()); // will not work; load balaced to s3
        trace(s3.readAll());

        s1.close();
        s2.close();
        s3.close();

        /* BUS */
        s1 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_BUS);
        s2 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_BUS);
        s3 = new NanoSocket(NanoDomain.AF_SP, NanoProtocol.NN_BUS);
        addr = new InProcAddress("hxnn");

        s1.bind(addr); s2.connect(addr); s3.connect(addr);

        s1.write("Broadcast from s1 to s2/s3, sent by NN_BUS");
        trace(s2.readAll());
        trace(s3.readAll());

        s1.close();
        s2.close();
        s3.close();
    }
}
```
