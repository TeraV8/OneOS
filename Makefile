
SRCDIR=src
BUILDDIR=build

all: $(BUILDDIR)/boot.bin

$(BUILDDIR):
	mkdir -pv $(BUILDDIR)
$(BUILDDIR)/boot.bin: $(BUILDDIR) $(SRCDIR)/boot.asm $(SRCDIR)/boot-core.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/boot.bin $(SRCDIR)/boot.asm
$(BUILDDIR)/disk-full.bin: $(BUILDDIR)/boot.bin
	cp $(BUILDDIR)/boot.bin $(BUILDDIR)/disk-full.bin
	dd bs=512 count=2047 oseek=1 if=/dev/zero of=$(BUILDDIR)/disk-full.bin

test: $(BUILDDIR)/disk-full.bin
	qemu-system-i386 -drive file=$(BUILDDIR)/disk-full.bin,media=disk,format=raw

clean:
	rm -rf build
