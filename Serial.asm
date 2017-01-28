

%define  COM1  0

initSerial:
  mov ah,0x00 ; init comm
  mov al,0xE3 ; 9600 baud, no parity, 1 stop bit, 8 bits word
  mov dx,COM1
  int 14h
  ret


  ;-------------------------
  ; Sends a string to COM1
  ; DS:SI  zero terminated string
  ;-------------------------
sendToSerial:
  	push dx
    push si
  	mov dx,COM1
  send1:
  	lodsb           ; load next byte from string from SI to AL
  	or   al, al     ; Does AL=0?
  	jz   sendDone  ;Yes, null terminator found, exit
    mov ah,0x01
  	int 14h
  	jmp  send1     ; Repeat until null terminator found
  sendDone:
    pop si
  	pop dx
  	ret             ; we are done, so return


querySerial:
    push dx
    push ax
    mov bx,1
    mov ah,0x03
    mov dx,COM1
    int 14h
    and ah,1        ;data ready
    jnz dataRedy
    xor bx,bx
  dataRedy:
    pop ax
    pop dx
    ret
