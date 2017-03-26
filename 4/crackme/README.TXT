 FaNt0m's CrackMe #4
~~~~~~~~~~~~~~~~~~~~~
This crackme is a little more difficult than the previous ones.  It requires
the cracker to aquire a valid serial, patch and keygen.  There is much more
work involved here, however I have not made the protection difficult.  Once
you have completed this crackme, you should review the previous ones because
CrackMe #5 is going to be a big crackme.  It will cover include all of the
protections used up to and including this crackme.

 Rules
~~~~~~~
 - Find a valid serial for your nick/name
 - Patch the crackme to accept any input as valid serial
 - Use any tools at your disposal, however I doubt you'll need anything
   more than SoftIce and W32Dasm
 - Do not tamper with the resources! (I.E. No Resource Editors allowed!)
 - Bonus: write a keygen to produce a valid serial given the user's name

If you have any questions, comments or problems you can contact me on IRC
on the Efnet in #new2cracking or #cracking4newbies.  You can email me, but
I don't check my email very often, your better off seeing me on IRC.

ttyl,
FaNt0m
fant0m@rocketmail.com
http://fant0m.cjb.net

Copyright (C) 2001 FaNt0m -- December 28, 2001

CPU Disasm
CPU Disasm
Address   Hex dump          Command                                  Comments
0040120A  |.  68 84304000   PUSH OFFSET 00403084                     ; ASCII "aaa" name

CPU Disasm
Address   Hex dump          Command                                  Comments
00401221  |.  68 84314000   PUSH OFFSET 00403184                     ; ASCII "bbb" serial



CPU Disasm
Address   Hex dump          Command                                  Comments
004012F9  /$  55            PUSH EBP                                 ; CRACKME4.004012F9(guessed Arg1)
004012FA  |.  8BEC          MOV EBP,ESP
004012FC  |.  56            PUSH ESI
004012FD  |.  57            PUSH EDI
004012FE  |.  8D35 84304000 LEA ESI,[403084]                         ; ASCII "aaa" esi - name pointer
00401304  |.  8D3D 84324000 LEA EDI,[403284]                         ; ASCII "TVT" edi - buf pointer
0040130A  |.  33C0          XOR EAX,EAX
0040130C  |.  33C9          XOR ECX,ECX
0040130E  |.  B3 1A         MOV BL,1A
00401310  |>  803E 00       /CMP BYTE PTR DS:[ESI],0
00401313  |.  74 15         |JE SHORT 0040132A
00401315  |.  8A06          |MOV AL,BYTE PTR DS:[ESI]
00401317  |.  02C1          |ADD AL,CL
00401319  |.  32C1          |XOR AL,CL
0040131B  |.  F6F3          |DIV BL
0040131D  |.  66:C1E8 08    |SHR AX,8
00401321  |.  04 41         |ADD AL,41
00401323  |.  8807          |MOV BYTE PTR DS:[EDI],AL
00401325  |.  47            |INC EDI
00401326  |.  46            |INC ESI
00401327  |.  41            |INC ECX
00401328  |.^ EB E6         \JMP SHORT 00401310
0040132A  |>  C607 00       MOV BYTE PTR DS:[EDI],0
0040132D  |.  33C0          XOR EAX,EAX
0040132F  |.  83F9 00       CMP ECX,0
00401332  |.  74 1A         JE SHORT 0040134E
00401334  |.  68 84324000   PUSH OFFSET 00403284                     ; ASCII "TVT"
00401339  |.  68 84314000   PUSH OFFSET 00403184                     ; ASCII "bbb"
0040133E  |.  E8 A1000000   CALL <JMP.&KERNEL32.lstrcmpA>
00401343  |.  83F8 00       CMP EAX,0
00401346  |.  74 04         JE SHORT 0040134C
00401348  |.  33C0          XOR EAX,EAX
0040134A  |.  EB 02         JMP SHORT 0040134E
0040134C  |>  8BC1          MOV EAX,ECX
0040134E  |>  5F            POP EDI
0040134F  |.  5E            POP ESI
00401350  |.  C9            LEAVE
00401351  \.  C2 0400       RETN 4


format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
        name db 'aaa', 0
        serial db 100
        form db '%d', 0
        aa dd 12

section '.code' code executable
startPoint:
        push esi
        push edi
        push eax
        push ecx
        push ebx

        lea esi, [name]                         ; ASCII "aaa" esi - name pointer
        lea edi, [serial]                       ; ASCII "TVT" edi - buf pointer
        xor eax, eax
        xor ecx, ecx
        mov bl, 0x1a

        .begin:
        cmp BYTE[esi], 0
        je .end
        mov al, BYTE[esi]
        add al, cl
        xor al, cl
        div bl
        shr ax, 8
        add al, 41
        mov BYTE[edi], al
        inc edi
        inc esi
        inc ecx
        jmp .begin

       .end:
        mov BYTE[edi], 0x00

        pop ebx
        pop ecx
        pop eax
        pop edi
        pop esi

        push [aa]
        push form
        call [printf]

        @@: jmp @b



section '.idata'import data readable
library msvcrt, 'msvcrt.dll',\
        kernel32, 'kernel32.dll'

import msvcrt,\
       printf, 'printf'

import kernel32,\
       ExitProcess, 'ExitProcess'


