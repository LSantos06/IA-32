SECTION TEXT

S_INPUT NOME1,10
C_INPUT SEXO1
C_INPUT ENTER
S_INPUT NOME2,10
C_INPUT SEXO2
C_INPUT ENTER

C_OUTPUT SEXO1
S_OUTPUT NEWLINE, 0XA
S_OUTPUT NOME1, 10
S_OUTPUT NEWLINE, 0XA
C_OUTPUT SEXO2
S_OUTPUT NEWLINE, 0XA
S_OUTPUT NOME2, 10
S_OUTPUT NEWLINE, 0XA
STOP

SECTION DATA
NOME1: SPACE 10
NOME2: SPACE 10
SEXO1: SPACE 1
SEXO2: SPACE 1
ENTER: SPACE 1
NEWLINE: CONST 0xA
