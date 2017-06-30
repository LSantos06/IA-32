/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */

#include "montador_ia32.h"

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

  // Numero de argumentos invalido, ERROR -1
  if(argc!=2 || argc==0){
     printf("Erro Terminal: numero de argumentos na chamada do programa eh invalido!\nObteve-se %d argumentos.\n", argc-1);
     exit(-1);
   }

  // Se o arquivo de entrada nao contem a extensao valida, ERROR -1
  char *validade_entrada_asm = ".asm";
  char *validade_entrada_s = ".s";
  if((strstr(argv[1], validade_entrada_asm))==NULL && (strstr(argv[1], validade_entrada_s))==NULL){
    printf("Erro Terminal: Arquivo a ser montado nao contem extensao '.asm' ou '.s'!\n");
    exit(-1);
  }

   // Caso nao tenha erros terminais, chama funcao principal de montagem
}
