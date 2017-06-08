/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */

#include "tradutor.h"

 /*
  *  validade_entrada()
  *
  *  Funcao responsavel pela checagem da extensao argumento de entrada
  * do programa de traducao
  *
  *  Erros: Terminal (numero de argumentos na chamada do programa eh invalido!)
  *         Terminal (arquivo de entrada nao contem extensao '.asm'!)
  */
 void validade_entrada(int argc, char* argv[]){

   // Se o arquivo de entrada nao contem a extensao valida, ERROR -1
   char *validade_entrada_asm = ".asm";
   if((strstr(argv[1], validade_entrada_asm))==NULL){
     printf("Erro Terminal: Arquivo a ser traduzido nao contem extensao '.asm'!\n");
     exit(-1);
   }

 }
