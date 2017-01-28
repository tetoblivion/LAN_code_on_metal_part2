
;-------------------------
; Prints a string
; DS:SI  zero terminated string
;-------------------------


Print:
		push bx
		push si
		xor bx,bx
	print1:
		lodsb           ; load next byte from string from SI to AL
		or   al, al     ; Does AL=0?
		jz   PrintDone  ;Yes, null terminator found, exit
		mov  ah, 0eh    ;Print character
		int  10h
		jmp  print1     ; Repeat until null terminator found
	PrintDone:
		pop si
		pop bx
		ret             ; we are done, so return


queryKeyboard:
	    push ax
	    mov bx,1
	    mov ah,0x01
	    int 16h
	    jnz keyDataRedy
	    xor bx,bx
	  keyDataRedy:
	    pop ax
	    ret
