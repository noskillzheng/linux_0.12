AS := as --32
LD := ld -m elf_i386

LDFLAG := -T boot.ld -s --oformat binary

image : linux.img

linux.img : tools/build bootsect setup kernel/system
	./tools/build bootsect setup kernel/system > $@
	truncate -s 1474560 $@

tools/build : tools/build.c
	gcc -o $@ $<

kernel/system : kernel/head.S kernel/*.c
	cd kernel; make system; cd ..

bootsect : bootsect.o
	$(LD) $(LDFLAG) -o $@ $<

bootsect.o : bootsect.S
	$(AS) -o $@ $<

setup : setup.o
	$(LD) $(LDFLAG) -e _start_setup -o $@ $<

setup.o : setup.S
	$(AS) -o $@ $<

clean:
	rm -f *.o
	rm -f bootsect
	rm -f setup
	rm -f tools/build
	rm -f linux.img
	cd kernel; make clean; cd ..


