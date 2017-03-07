default:
	nasm -f bin bootloader.asm -o bootloader.bin

iso:
	mkisofs -R -b bootloader.bin -no-emul-boo -boot-load-size 4 -o bootloader.iso .

floppy: default
	cp bootloader.bin bootloader.img

rm:
	-rm bootloader.bin
	-rm bootloader.img

run:
	# x86?
	qemu-system-i386 bootloader.bin

