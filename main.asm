
bits 16             ; We are in 16 bit Real Mode

org  0x7c00         ; We are loaded by BIOS at 0x7C00

start:  jmp loader  ; jump over OEM block

;	This here is just for floppy or CD emulated floppy
bpbOEM			            DB "LAN play   "
bpbBytesPerSector:      DW 512
bpbSectorsPerCluster:   DB 1
bpbReservedSectors:     DW 1
bpbNumberOfFATs:        DB 2
bpbRootEntries:         DW 224
bpbTotalSectors:        DW 2880
bpbMedia:               DB 0xF0
bpbSectorsPerFAT:       DW 9
bpbSectorsPerTrack:     DW 18
bpbHeadsPerCylinder:    DW 2
bpbHiddenSectors:       DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber:          DB 0
bsUnused:               DB 0
bsExtBootSignature:     DB 0x29
bsSerialNumber:         DD 0xa0a1a2a3
bsVolumeLabel:          DB "LAN FLOPPY "
bsFileSystem:           DB "FAT12   "


	%include "LAN.asm"


loader:
	xor ax,ax
	mov ds,ax
	mov	es,ax

	call initSerial


	call transmitExample

wait_on_reboot:
	call rebootOnKeypressOrSerial
	jmp wait_on_reboot

;--------------------------------

rebootOnKeypressOrSerial:
	push bx
	call querySerial
	cmp bx,1
	jz reboot
	call queryKeyboard
	cmp bx,1
	jz reboot
	pop bx
	ret


reboot:
	jmp 0FFFFh:0    ;reboot

halt:
	cli                      ; Clear all Interrupts
	hlt                      ; halt the system

	times 510 - ($-$$) DB 0  ; Clear the rest of the 512 bytes with 0
	DW 0xAA55                ; Boot Signiture
