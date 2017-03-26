format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	name	db 100 dup(0)
	serial	db 100 dup(0)
	namemsg db 'Enter your name (100 chars max): ', 0
	scform	db '%s', 0
	prform	db 'Your serial: %s', 10, 0

section '.code' code executable
startPoint:
	invoke printf, namemsg
	invoke scanf, scform, name

	lea esi, [name]
	lea edi, [serial]

	xor eax, eax
	xor ecx, ecx
	mov bl, 0x1a

	.whBegin:
	cmp BYTE[esi], 0x00
	je .whEnd
	mov al, BYTE[esi]
	add al, cl
	xor al, cl
	div bl
	shr ax, 0x08
	add al, 0x41
	mov BYTE[edi], al
	inc edi
	inc esi
	inc ecx
	jmp .whBegin

	.whEnd:
	mov BYTE[edi], 0x00
	invoke printf, prform, serial

	jmp startPoint

section '.idata'import data readable
library msvcrt, 'msvcrt.dll'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf'

