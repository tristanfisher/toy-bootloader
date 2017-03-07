bits 16     ; tell nASM assemble to 16 bit real mode (we'll have ax, bx registers)
org 0x7c00  ; first sector offset segment of boot device. BIOS looks here for code

jmp main

; ax is full 16 bit register (x 12 34)
; ah is high bits 8 through 15 (12)
; al is lower (least significant) 8 bits (34)


; declare bytes variables for our messages, null terminated
MsgHelloWorld db "Hello, world", 0
MsgReboot db "Press any key to reboot.", 0

reboot:
    mov si, MsgReboot       ; store msg in source index
    call put_nullt_string
    call get_key

    ; step to the end of our memory to trigger a reboot by declaring bytes 
    ; declare words to point us to 0xffff(2**16 - 1):0x0000
    db 0x0ea
    dw 0x0000
    dw 0xffff

get_key:
    mov ah, 0
    int 0x16                ; jump to BIOS keyboard interrupt.  this waits.
        ret

put_nullt_string:
    lodsb                   ; pop message ref f/ stack (implicitly [ds:si])
                            ; FLAGS increment if clear/decrement if set
    cmp al, 0               
    jz call_put_newline     ; jump to newline if AL is zero/null
    mov ah, 0x0e            ; else, print char and flow through loop
    int 0x10                ; BIOS paint screen from video memory
    jmp put_nullt_string

call_put_newline:
    call put_newline

put_newline:
    mov al, 0               ; set al register to null
    stosb

    mov ah, 0x0e
    mov al, 0x0d
    int 0x10
    mov al, 0x0a
    int 0x10
        ret

main:
    cli                     ; disable interrupts
    ; set up stack segments
    mov ax, cs              ; code segment (cs) to accumulator (ax) register
    mov ds, ax              ; ax to data segment (ds) (initialize)
    mov es, ax              ; ax to extra segment (es) (initialize)
    mov ss, ax              ; ax to stack segment (ss) (initialize) (make room for si)
    sti                     ; enable interrupts

    mov si, MsgHelloWorld   ; place the reference to our message onto the stack
    call put_nullt_string

    call reboot

    ;  0-fill first 510 bytes to move us up to 510 to place the magic number. 
    ; (ostensibly not required with new devices, but good practice)
    ; $ is & of current statement, $$ current section. $-$$ is size of program
    times 510 - ($-$$) db 0

    ; magic word. bios int 0x19 looks for 2 bytes, byte 511 == AA and 512 == 55
    ; if found, program gets moved into memory and executed
    dw 0xAA55