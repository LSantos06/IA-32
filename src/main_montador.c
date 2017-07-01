/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */

#include "montador_ia32.h"

int main(int argc, char* argv[]){
  unsigned char *code;

  validade_entrada(argc, argv);
  code = montagem(argc, argv);

  return 0;
}
