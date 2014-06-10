# hxstd [![Build Status](https://ci.rackster.ch/buildStatus/icon?job=hxstd)](https://ci.rackster.ch/job/hxstd/)

> A completing yet alternative standard library for Haxe.

## Compilation Flags

`-D HXSTD_DEBUG` which enables debug mode. Setting this flag will tell the `Exceptions` to include full Call- and ExceptionStack information. Though this can be helpful during development, it should not be enabled for production/releases as the operations are expensive.

`-D HXSTD_INLINE` which will inline various helper methods such as `isEmpty()` etc. Enabling this _may_ increase performance but prevent you from overriding those methods in subclasses.

`-D HXSTD_WIN` which will tell the library that we are compiling on a Windows system. This flag is used in `hxstdm.vm.Lock` class, as `SemaphoreSlim` doesn't work on non-Windows environments.

## License

The MIT License (MIT)

Copyright (c) 2014 Michel Käser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



