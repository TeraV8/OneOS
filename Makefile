
SRCDIR=src
BUILDDIR=build

all: $(BUILDDIR)/disk-full.bin
bootsector: $(BUILDDIR)/boot.bin

$(BUILDDIR):
	mkdir -pv $(BUILDDIR)
$(BUILDDIR)/boot.bin: $(BUILDDIR) $(SRCDIR)/boot.asm $(SRCDIR)/boot-core.asm $(SRCDIR)/boot-supp.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/boot.bin -l $(BUILDDIR)/boot.l $(SRCDIR)/boot.asm
$(BUILDDIR)/boot-ext.bin: $(BUILDDIR) $(BUILDDIR)/boot.l $(SRCDIR)/boot-supp.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/boot-ext.bin -l $(BUILDDIR)/boot-ext.l $(SRCDIR)/boot-supp.asm
$(BUILDDIR)/disk-full.bin: $(BUILDDIR)/boot.bin $(SRCDIR)/part1.bin
	cp $(BUILDDIR)/boot.bin $(BUILDDIR)/disk-full.bin
	truncate --size=32K $(BUILDDIR)/disk-full.bin
	dd bs=512 status=none oseek=64 if=$(SRCDIR)/part1.bin conv=sync of=$(BUILDDIR)/disk-full.bin
	truncate --size=1M $(BUILDDIR)/disk-full.bin

test: $(BUILDDIR)/disk-full.bin
	qemu-system-i386 -drive file=$(BUILDDIR)/disk-full.bin,media=disk,format=raw

clean:
	rm -rf build
