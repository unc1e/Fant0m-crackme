format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	fname  db 'CRACKME3.EXE', 0
	fform  db 'rb+', 0
	fd     dd ?
	buf    db 0x39, 0xc0, 0x90
	errmsg db 'Where is CRACKME3.EXE? o_0', 0
	okmsg  db 'Successfully patched!', 0

section '.code' code executable
startPoint:
	cinvoke fopen, fname, fform
	test eax, eax
	je .err

	mov [fd], eax
	cinvoke fseek, eax, 1537, 0
	cinvoke fwrite, buf, 3, 1, [fd]
	cinvoke fclose, [fd]
	cinvoke printf, okmsg
	jmp .exit

	.err:
	cinvoke printf, errmsg
	.exit:
	invoke Sleep, 3000
	invoke ExitProcess, 0


section '.idata'import data readable
library msvcrt, 'msvcrt.dll',\
	kernel32, 'kernel32.dll'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf',\
       fopen, 'fopen',\
       fseek, 'fseek',\
       fwrite, 'fwrite',\
       fclose, 'fclose'

import kernel32,\
       Sleep, 'Sleep',\
       ExitProcess, 'ExitProcess'