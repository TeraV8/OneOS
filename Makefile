
SRCDIR=src/386
SRCCOM=src/common
BUILDDIR=build

all: $(BUILDDIR)/disk-full.bin
bootsector: $(BUILDDIR)/boot.bin

$(BUILDDIR):
	mkdir -pv $(BUILDDIR)
$(BUILDDIR)/boot.bin: $(BUILDDIR) $(SRCDIR)/boot.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/boot.bin -l $(BUILDDIR)/boot.l $(SRCDIR)/boot.asm
$(BUILDDIR)/loader.bin: $(BUILDDIR) $(SRCDIR)/loader.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/loader.bin -l $(BUILDDIR)/loader.l $(SRCDIR)/loader.asm
	echo $$(printf '%04x\n' $$(expr $$(dd if=$(BUILDDIR)/loader.bin bs=1 count=508 iseek=4 status=none | cksum -a bsd | cut -c -5) + 0))
$(BUILDDIR)/disk-full.bin: $(BUILDDIR)/boot.bin $(BUILDDIR)/loader.bin
	cp $(BUILDDIR)/boot.bin $(BUILDDIR)/disk-full.bin
	dd status=none if=$(BUILDDIR)/loader.bin of=$(BUILDDIR)/disk-full.bin bs=512 oseek=1

test: $(BUILDDIR)/disk-full.bin
	qemu-system-i386 -drive file=$(BUILDDIR)/disk-full.bin,media=disk,format=raw

clean:
	rm -rf build
