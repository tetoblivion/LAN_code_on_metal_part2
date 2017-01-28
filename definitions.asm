
;right way to get base addresses is to read
;x86 PCI configuration space.
;Alternatively go to
;Device Manager -> Network adapters->
;Resources  -> I/O Range
;to get these IO port addresses
%define  NIC1_base    0xE000
%define  NIC2_base    0xE400
%define  NIC3_base    0xE800

;Media Status Register
%define  MSR_offset     0x0058
  ;Bit 2, Inverse of Link status. 0 = Link OK. 1 = Link Fail.
  %define  LINKB_bitmask  0x0004


;Transmit Status of Descriptor 0 (trasmit status register 0)
%define TSD0_offset 0x10
  ;Bit 15 Transmit OK
  %define TSDTOK_bitmask 0x8000
  ;Bit 13
  %define OWN_bitmask 0x2000
  ;Bits 12-0 are size of packet
  %define SIZE 16


;Transmit Start Address of Descriptor0
%define TSAD0_offset 0x20


;Receive(Rx) Buffer Start Address
%define RBSTART_offset 0x30


;Command Register
%define CR_offset 0x37
  ;Bit 4, Reset
  %define RST_bitmask 0x10
  ;Bit 3, Receiver Enable
  %define RE_bitmask 0x08
  ;Bit 2, Trasmitter Enable
  %define TE_bitmask 0x04


;Interrupt Mask Register
%define IMR_offset 0x3C


;Interrupt Status Register
%define ISR_offset 0x3E
  ;Bit 2, Transmit (Tx) OK
  %define ISRTOK_bitmask 0x04
  ;Bit 0, Receive (Rx) OK
  %define ROK_bitmask 0x01


;Receive Configuration Register
%define RCR_offset 0x44
  ;Bits 5 4 3 2 1 0 ; AER AR AB AM APM AAP
  %define acceptEveryPacket_bitmask 0x3F



;RAM (guaranteed free for use) Conventional memory
%define  receiveAddress 0x7E00
