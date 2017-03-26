format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	fname  db 'CRACKME5.EXE', 0
	fform  db 'rb+', 0
	fd     dd ?
	buf1   db 6 dup(0x90)
	buf2   db 0x38, 0xc0, 0x75, 0x1c, 0x38, 0xe4, 0x90
	errmsg db 'Where is CRACKME5.EXE? o_0', 0
	okmsg  db 'Successfully patched!', 0

section '.code' code executable
startPoint:
	cinvoke fopen, fname, fform
	test eax, eax
	je .err

	mov [fd], eax
	cinvoke fseek, eax, 1379, 0
	cinvoke fwrite, buf1, 6, 1, [fd]
	cinvoke fseek, [fd], 2119, 0
	cinvoke fwrite, buf2, 7, 1, [fd]
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