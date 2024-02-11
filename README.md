# OneOS
"One operating system to rule them all"

An operating system designed for compatibility, usability, security, and above all else, transparency.

## Compiling
Compiling is straightforward, simply `make all` in the root directory.
Your targets will end up in the `build/` directory as `build/boot.bin` and `build/disk-full.bin`.

### Testing
If you have Qemu installed on your system, you can test the source by running `make test` in the root directory.
Note that Qemu will NOT beep when the error handler is activated. I have no idea why this happens, feel free to PR to fix it.
