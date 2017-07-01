/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */
#ifndef MONTADOR_H
#define MONTADOR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <err.h>
#include <fcntl.h>
#include <libelf.h>
#include <sysexits.h>
#include <unistd.h>

/*** PRE-MONTAGEM ***/
// Verifica se o arquivo de entrada é válido
void validade_entrada(int argc, char* argv[]);

/*** MONTAGEM ***/

//TODO : Gerar este vetor code a partir do arquivo .s
/* O programa simplesmente SAI e manda 42 para o SO */
unsigned char code_teste[] = {
    0xBB, 0x2A, 0x00, 0x00, 0x00, /* movl $42, %ebx */
    0xB8, 0x01, 0x00, 0x00, 0x00, /* movl $1, %eax */
    0xCD, 0x80            /* int $0x80 */
};
/*endereço virtual onde sera carregado o programa*/
#define LOADADDR    0x08048000

// Montagem em si
unsigned char* montagem(int argc, char* argv[]);
// Geracao do arquivo executavel
void geracao_elf(unsigned char *);

#endif
