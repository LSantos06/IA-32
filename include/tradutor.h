/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */

#ifndef TRADUTOR_H
#define TRADUTOR_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "estruturas.h"

// Definicao do tamanho maximo de uma linha
#define TLINHA 100

/*
 *  Modulo que realiza a traducao da linguagem Assembly Hipotetica vista em aula
 * para a linguagem Assembly IA-32
 *
 *  Entrada:
 * - Arquivo .asm na linguagem Assembly Hipotetica vista em aula
 *
 *  Saida:
 * - Arquivo .s na linguagem Assembly IA-32
 */

/*** PRE-TRADUCAO ***/
// Verifica se o arquivo de entrada é válido
void validade_entrada(int argc, char* argv[]);



/*** TRADUCAO ***/
//Separa os tokens de uma linha do arquivo de entrada
void scanner(char *linha, int contador_linha, char *delimitador);
//Funcao principal do tradutor, contem o switch de opcodes
void main_tradutor(char *nome_arq);

/*** FUNCOES AUXILIARES A TRADUCAO ***/
//Corta .asm do argumento de entrada pra escrever em .s
void corta_asm(char *str);
//Retorna string do operando, que pode ser um elemento de vetor
char* string_operando(char *operando);
//Funcao que escreve funcoes feitas em assembly no arquivo de saida
void escreve_funcoes(FILE *arq_saida);

//Passa uma string para caixa alta
void string_alta(char *s);
//Passa uma string para caixa baixa
void string_baixa(char *s);

#endif
