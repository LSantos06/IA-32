#include "estruturas.h"

const opTab tabela_instrucoes_diretivas[25] = {
	{"ADD", 1, 1}, {"SUB", 1, 2},
	{"MULT", 1, 3}, {"DIV", 1, 4},
	{"JMP", 1, 5}, {"JMPN", 1, 6},
	{"JMPP", 1, 7}, {"JMPZ", 1, 8},
	{"COPY", 2, 9}, {"LOAD", 1, 10},
	{"STORE", 1, 11}, {"INPUT", 1, 12},
	{"OUTPUT", 1, 13}, {"STOP", 0, 14},
  {"C_INPUT", 1, 15}, {"C_OUTPUT", 1, 16},
  {"H_INPUT", 1, 17}, {"H_OUTPUT", 1, 18},
  {"S_INPUT", 2, 19}, {"S_OUTPUT", 2, 20},
  {"SECTION", 1, 21}, {"SPACE", 1, 22},
  {"CONST", 1, 23}, {"EQU", 1, 24},
  {"IF", 1, 25}
};

lista_t *lista_bss;

//Funcoes da tabela de instrucoes/diretivas
/*
 *  opcode()
 *
 *  Retorna o opcode de uma instrucao
 */
int opcode(char *simbolo){
	int i, achou = 0, retorno = 0;

	for (i = 0; i<25; i++){
		//Se achou a instrucao
		if(!(strcmp(simbolo, tabela_instrucoes_diretivas[i].nome))){
			achou = 1;
			retorno = tabela_instrucoes_diretivas[i].opcode;
		} // if
	} // for

	//Se nao achou instrucao
	if(achou == 0){
		return -1;
	}

	return retorno;
}


//Funcoes de lista
/*
 *  cria_lista()
 *
 *  Inicializacao e instanciamento da lista global
 */
void cria_lista(){
  lista_bss = (lista_t*)  malloc(sizeof(lista_t));
	inicializa_lista(lista_bss);
}

/*
 *  inicializa_lista()
 *
 *  Inicializacao de uma lista
 */
void inicializa_lista(lista_t *lista){
	lista->proximo = NULL;
}

/*
 *  vazia_lista()
 *
 *  Verifica se a lista esta vazia
 */
int vazia_lista(lista_t *lista){
	if(lista->proximo == NULL)
		return 1;
	else
		return 0;
}

/*
 *  insere_elemento()
 *
 *  Insercao de um elemento na lista
 */
 void insere_elemento(lista_t *lista, char *id, char *valor){
   lista_t *novo;
   char *aux1 = strdup(id);
   char *aux2 = strdup(valor);
   novo = (lista_t *) malloc (sizeof (lista_t));

 	// Tira \n
 	if(aux1[strlen(id)-1] < 48
 	|| aux1[strlen(id)-1] > 122){
 		 aux1[strlen(id)-1] = '\0';
 	}
 	if(aux2[strlen(valor)-1] < 48
 	|| aux2[strlen(valor)-1] > 122){
 		 aux2[strlen(valor)-1] = '\0';
 	}

 	novo->id = aux1;
 	novo->tamanho = aux2;
 	novo->proximo = lista->proximo;

 	lista->proximo = novo;
 }

/*
 *  exibe_lista()
 *
 *  Exibicao de todos os elementos de uma lista no arquivo
 */
void exibe_lista(FILE* fp, lista_t *lista){
	if(vazia_lista(lista)){
		return;
	}

	lista_t *aux = lista->proximo;

	while(aux!=NULL){
		fprintf(fp, "%s resd %s\n", aux->id, aux->tamanho);
		aux = aux->proximo;
	}
	fprintf(fp, "\n\n");
}

/*
 *  libera_lista()
 *
 *  Libera a memoria alocada para uma lista
 */
void libera_lista(lista_t *lista){
	if(!vazia_lista(lista)){
		lista_t *proximoNo, *noAtual;

		noAtual = lista->proximo;
		while(noAtual != NULL){
			proximoNo = noAtual->proximo;
			free(noAtual);
			noAtual = proximoNo;
		}
	}
}
