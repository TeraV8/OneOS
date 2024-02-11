
SRCDIR=src
BUILDDIR=build

all: $(BUILDDIR)/boot.bin

$(BUILDDIR):
	mkdir -pv $(BUILDDIR)
$(BUILDDIR)/boot.bin: $(BUILDDIR) $(SRCDIR)/boot.asm $(SRCDIR)/boot-core.asm
	nasm -f bin -i $(SRCDIR) -o $(BUILDDIR)/boot.bin $(SRCDIR)/boot.asm

test: $(BUILDDIR)/boot.bin
	qemu-system-i386 $(BUILDDIR)/boot.bin

clean:
	echo "Nothing to clean!"
