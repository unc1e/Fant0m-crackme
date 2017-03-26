format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	name	 db 64 dup(0)
	serial	 db 128 dup(0)
	namemsg  db 'Enter your name (64 chars max): ', 0
	scform	 db '%s', 0
	prform	 db 'Your serial: %s', 10, 0

section '.code' code executable
startPoint:
	invoke printf, namemsg
	invoke scanf, scform, name

	lea esi, [name]
	lea edi, [serial]

	push esi
	xor ecx, ecx
	@@:
	cmp BYTE[esi], 0x00
	je @f
	inc ecx
	inc esi
	jmp @b
	@@:
	pop esi

	inc ecx
	.swBegin:
	mov ebx, 0x42
	add ebx, ecx
	movzx eax, BYTE[esi]
	inc esi
	xor eax, ebx
	rol eax, 0x05
	shr eax, 0x02
	mov bl, 0x10
	div bl
	.back1:
	add ah, 0x30
	cmp ah, 0x40
	jle @f
	add ah, 0x07
	@@:
	mov BYTE[edi], ah
	inc edi
	cmp al, 0x10
	jge @f
	shl ax, 0x08
	mov al, 0x11
	jmp .back1
	@@:
	dec ecx
	cmp ecx, 0x00
	je @f
	jmp .swBegin
	@@:
	mov BYTE[edi], 0x00

	invoke printf, prform, serial
	jmp startPoint

section '.idata'import data readable
library msvcrt, 'msvcrt.dll'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf'

