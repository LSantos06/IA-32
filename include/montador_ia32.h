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
// Montagem em si
void montagem(int argc, char* argv[]);

#endif
