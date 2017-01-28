
%include "print.asm"
%include "serial.asm"
%include "definitions.asm"

lineBreak db  10,13,0
isrmsg    db  10,13,"ISR_ROK",0
nisrmsg   db  10,13,"NOT_ROK",0

align 4
;must be alligned to 4 bytes
dataToTransmit db 10,13,"Hello Rx/Tx !",0

transmitExample:

;-------------------Reset NICs

  mov dx, NIC1_base
  add dx, CR_offset   ;Command Register
	mov ax, RST_bitmask ;reset NIC1
	out dx, ax

  mov dx, NIC2_base
  add dx, CR_offset   ;Command Register
	mov ax, RST_bitmask ;reset NIC2
	out dx, ax

wait_on_reset_1:
  mov dx, NIC1_base
	add dx, CR_offset   ;Command Register
	in  ax, dx
	and ax, RST_bitmask
	jnz wait_on_reset_1

wait_on_reset_2:
  mov dx, NIC2_base
	add dx, CR_offset   ;Command Register
	in  ax, dx
	and ax, RST_bitmask
	jnz wait_on_reset_2


  ;-------------------Configure

  mov dx, NIC1_base
	add dx, CR_offset   ;Command Register
	mov ax, TE_bitmask  ;enable tx
	out dx, ax

  mov dx, NIC2_base
	add dx, CR_offset   ;Command Register
  mov ax, RE_bitmask  ;enable rx
	out dx, ax

  mov dx, NIC1_base
 	add dx, IMR_offset  ;Interrupt Mask Register
  xor ax, ax          ;disable interrupts
  out dx, ax

  mov dx, NIC2_base
	add dx, IMR_offset  ;Interrupt Mask Register
  xor ax,ax           ;disable interrupts
  out dx,ax


  ;--

  mov  dx, NIC2_base
	add edx, RBSTART_offset  ;Receive(Rx) Buffer Start Address
	mov eax, receiveAddress
	out  dx, eax

  mov  dx, NIC2_base
	add edx, RCR_offset
	mov eax, acceptEveryPacket_bitmask
	out  dx, eax

  ;-------------------Transmit

  mov  dx, NIC1_base
  add edx, TSAD0_offset    ;address of data0/descriptor0 to transmit
  mov eax, dataToTransmit
  out  dx, eax

  mov  dx, NIC1_base
  add  dx, TSD0_offset     ;Transmit Status of Descriptor 0
	mov eax, SIZE            ;resetting own bit in TSD starts transmittion and
  out  dx, eax             ;at the same time we write size of packet to TSD



wait_OWN:
	in   eax, dx
	test eax, OWN_bitmask
	jz   wait_OWN


  ;-------------------Wait
	mov ecx, 0x1000000
delay:
	nop
	nop
  db 0x67 ;address size override prefix ;use ecx instead of cx
	loop delay


  ;-------------------Receive

  mov  dx, NIC2_base
	add  dx, ISR_offset    ;Interrupt Status Register
	in   ax, dx
	test ax, ROK_bitmask
	jnz  receiveOK

	mov	 si, nisrmsg       ;Receive not OK
	call Print
  call sendToSerial

ret

receiveOK:
	mov	 si, isrmsg
	call Print
  call sendToSerial

  ;-------------------Print and Send Frame/Packet

	mov	 si, receiveAddress+4
	call Print
  call sendToSerial

  ;receiveAddress + 0 is RSR (Receive Status Register in Rx Packet Header)
  ;receiveAddress + 2 is packetLength
  ;receiveAddress + 4 is the start of packet
  ;receiveAddress + packetLength - 4 is CRC checksum

ret
