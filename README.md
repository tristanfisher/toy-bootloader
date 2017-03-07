# a silly toy bootloader

#### why does this exist?

i played [TIS-100](http://store.steampowered.com/app/370360/) and had some assembly FAQs on my local machine while travelling/away from internet-access, so i wrote this instead of doing "real work" ;)

#### i want to run it

i'm not sure why you'd want that, but: 

> i'm on OS X: 

use the makefile to make a .img that can be mounted as a floppy in virtualbox:

    make floppy

then start up virtualbox, make a blank fake machine, add a floppy drive, attach the bootloader.img to it. 

> i'm on linux: 

you can probably just `qemu-system` the `.bin`

#### what's with the python scripts

they're little helpers for hex-math (not required to run example)



~ gl;hf
