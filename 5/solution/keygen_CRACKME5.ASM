format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	name	 db 256 dup(0)
	serial	 db 512 dup(0)
	constkey db "JD39-CK4-5QV345", 0
	namemsg  db 'Enter your name (256 chars max and 3 chars min): ', 0
	scform	 db '%s', 0
	prform	 db 'Your serial: %s', 10, 0

section '.code' code executable
startPoint:
	cinvoke printf, namemsg
	cinvoke scanf, scform, name

	lea esi, [name]
	lea edi, [serial]
	lea edx, [constkey]

	mov ecx, 0x01
	mov ebx, 0x45
	shl ebx, 0x08

	.whBegin:
	mov bl, 0x1a
	xor eax, eax
	mov al, BYTE[esi]
	cmp al, 0x00
	je .whEnd
	inc esi
	cmp BYTE[edx], 0x00
	jne .isNotEndOfConstKey
	lea edx, [constkey]
	.isNotEndOfConstKey:
	xor al, BYTE[edx]
	mul bh
	not ax
	and eax, 0x00000fff
	div bl
	add ah, 0x41
	shl eax, 0x10
	shr eax, 0x18
	push eax
	mov bl, 0x05
	mov eax, ecx
	and eax, 0x00000fff
	div bl
	cmp ah, 0x00
	jne .isNotDashHere
	mov BYTE[edi], 0x2d
	inc edi
	.isNotDashHere:
	pop eax
	mov BYTE[edi], al
	inc edi
	inc edx
	inc ecx
	jmp .whBegin

	.whEnd:
	mov BYTE[edi], 0x00
	cinvoke printf, prform, serial
	jmp startPoint

section '.idata'import data readable
library msvcrt, 'msvcrt.dll'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf'

