%if M == 1
mov dword [OLD_DATA],eax
%endif

section .text
global _start
_start:
mov eax,[OLD_DATA]
L1: idiv dword [DOIS]
mov dword [NEW_DATA],eax
imul dword [DOIS]
mov dword [TMP_DATA],eax
mov eax,[OLD_DATA]
sub dword EAX, [TMP_DATA]
mov dword [TMP_DATA],eax
mov dword [NEW_DATA],[OLD_DATA]
mov eax,[OLD_DATA]
jg L1

mov eax,1
mov ebx,0
int 80h

section .data
DOIS: dd 2

section .bss
TMP_DATA: resd 1
NEW_DATA: resd 1
OLD_DATA: resd 1


