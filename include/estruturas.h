#ifndef ESTRUTURAS_H
#define ESTRUTURAS_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/* Modulo com estruturas para serem usadas
 * pelo tradutor
*/

typedef enum{
  ADD = 1, SUB, MULT, DIV, JMP,
  JMPN, JMPP, JMPZ, COPY,
  LOAD, STORE, INPUT, OUTPUT,
  STOP, C_INPUT, C_OUTPUT, H_INPUT,
  H_OUTPUT, S_INPUT, S_OUTPUT,
  SECTION, SPACE, CONST, EQU, IF
} OPCODES;

// Definicao da Tabela de Instrucoes e respectiva instanciacao
typedef struct{
	char nome[10];
	int ops, opcode;
} opTab;

extern const opTab tabela_instrucoes_diretivas[25];

// Funcoes de encapsulamento de instrucoes e diretivas
int opcode(char *simbolo);

/*************************** Listas **************************/
typedef struct lista{
  char *id;
  char *tamanho;
  struct lista *proximo;
} lista_t;

extern lista_t *lista_bss;

//Funcoes de manipulacao das listas
void cria_lista();
void inicializa_lista(lista_t *lista);
int vazia_lista(lista_t *lista);
void insere_elemento(lista_t *lista, char *id, char *tamanho);
void exibe_lista(FILE* fp, lista_t *lista);
void libera_lista(lista_t *lista);


#endif /*ESTRUTURAS_H*/
