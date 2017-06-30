/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */

#include "tradutor.h"

char *tokens_linha[100];

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

   // Se o arquivo de entrada nao contem a extensao valida, ERROR -2
   char *validade_entrada_asm = ".asm";
   if((strstr(argv[1], validade_entrada_asm))==NULL){
     printf("Erro Terminal: Arquivo a ser traduzido nao contem extensao '.asm'!\n");
     exit(-2);
   }

    //Caso nao tenha erros terminais, chama funcao principal do tradutor
    main_tradutor(argv[1]);
 }

void corta_asm(char *str){
  char *aux = strstr(str, ".asm");
  //Apos loop, aponta pro .
  while(*aux!='\0' && *aux!='.') { aux++; }
  aux++;
  *aux = 's';
  aux++;
  *aux = '\0';
}

/*
 *  scanner()
 *
 *  Verifica erros lexicos no programa
 *
 *  Erros: Lexico (token '%s' inicia com digito)
 *         (excedeu numero de tokens)
 */
void scanner(char *linha, int contador_linha, char *delimitador){
	if(linha == NULL){
		return;
	}

	char *token;
	int i = 0;

	//Espacao como caractere limitador
	token = strtok(linha, delimitador);

	while(token!=NULL){
		tokens_linha[i] = strdup(token);

		if(i>98){
				printf("\nErro! Excedeu numero de tokens! (linha %d)\n", contador_linha);
		}
		// printf("<%s>\n", token);
		i++;
		//Avanca pro proximo token
		token = strtok(NULL, delimitador);
	}
	tokens_linha[i] = "\0";

}

//Funcao principal de traducao (possui o SWITCH de
//instrucoes e diretivas)
void main_tradutor(char *nome_arq){
   char linha[TLINHA];
   char *instrucao;
   int i = 0;
   int flag_if = 0;
   int start_flag = 0;
   int def_sec_data = 0, def_sec_text = 0;

   char* nome_saida;
   FILE* arq_saida;
   int contador_linha = 1;

   FILE *arq_entrada = fopen(nome_arq, "r");
    // Se o arquivo nao conseguiu ser aberto, ERROR -3
   if(arq_entrada == NULL){
     printf("Erro Terminal: Erro na abertura do arquivo!\n");
     exit(-3);
   }
   //Coloca nome do arquivo de saida com .s
   nome_saida = strdup(nome_arq);
   corta_asm(nome_saida);
   //Abertura do arquivo de saida
   arq_saida = fopen(nome_saida, "w");

   //Cria a lista de elementos bss
   cria_lista();
   while(!feof(arq_entrada)){
			// Funcao fgets() lê até TLINHA caracteres ou até o '\n'
			instrucao = fgets(linha, TLINHA, arq_entrada);

			if(instrucao==NULL){
	    	break;
	    }

      scanner(instrucao, contador_linha, " ,\t\n");
      //Analisar todos os tokens da linha
      for(i=0; tokens_linha[i]!="\0" && tokens_linha[i]!=NULL; i++){
        //Se for ;, pula pra proxima linha
        if(strstr(tokens_linha[i], ";")!=NULL){
          break;
        }
        string_alta(tokens_linha[i]);

        //Verifica se eh um opcode para imprimi-lo
        switch(opcode(tokens_linha[i])){
          case ADD:
            fprintf(arq_saida, "add dword EAX, [%s]\n", string_operando(tokens_linha[i+1]));
          break;
          case SUB:
            fprintf(arq_saida, "sub dword EAX, [%s]\n", string_operando(tokens_linha[i+1]));
          break;
          case MULT:
            //Multiplicacao com sinal
            fprintf(arq_saida, "imul dword [%s]\n", string_operando(tokens_linha[i+1]));
          break;
          case DIV:
            fprintf(arq_saida, "idiv dword [%s]\n", string_operando(tokens_linha[i+1]));
          break;
          case JMP:
            fprintf(arq_saida, "jmp %s\n", string_operando(tokens_linha[i+1]));
          break;
          case JMPN:
            fprintf(arq_saida, "jl %s\n", string_operando(tokens_linha[i+1]));
          break;
          case JMPP:
            fprintf(arq_saida, "jg %s\n", string_operando(tokens_linha[i+1]));
          break;
          case JMPZ:
            fprintf(arq_saida, "je %s\n", string_operando(tokens_linha[i+1]));
          break;
          case COPY:
            fprintf(arq_saida, "push ebx\n");
            fprintf(arq_saida, "mov ebx, [%s]\n", tokens_linha[i+1]);
            fprintf(arq_saida, "mov dword [%s], ebx\n", tokens_linha[i+2]);
            fprintf(arq_saida, "pop ebx\n");
          break;
          case LOAD:
            fprintf(arq_saida, "mov eax,[%s]\n", string_operando(tokens_linha[i+1]));
          break;
          case STORE:
            fprintf(arq_saida, "mov dword [%s],eax\n", string_operando(tokens_linha[i+1]));
          break;
          case INPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call LerInteiro\n");
          break;
          case OUTPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call EscreverInteiro\n");
          break;
          case STOP:
            //Chamada pro kernel de fim
            fprintf(arq_saida, "\nmov eax,1\nmov ebx,0\nint 80h\n");
          break;
          case C_INPUT:
            fprintf(arq_saida, "push %s\n", string_operando(tokens_linha[i+1]));
            fprintf(arq_saida, "call LerChar\n");
          break;
          case C_OUTPUT:
            fprintf(arq_saida, "push %s\n", string_operando(tokens_linha[i+1]));
            fprintf(arq_saida, "call EscreverChar\n");
          break;
          case H_INPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call LerHexa\n");
          break;
          case H_OUTPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call EscreverHexa\n");
          break;
          case S_INPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+2]);
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call LerString\n");
          break;
          case S_OUTPUT:
            fprintf(arq_saida, "push %s\n", tokens_linha[i+2]);
            fprintf(arq_saida, "push %s\n", tokens_linha[i+1]);
            fprintf(arq_saida, "call EscreverString\n");
          break;
          case SECTION:
            string_baixa(tokens_linha[i+1]);
            fprintf(arq_saida, "\nsection .%s\n", tokens_linha[i+1]);
            if(!strcmp(tokens_linha[i+1], "text")){
              def_sec_text = 1;
              def_sec_data = 0;
              if(!start_flag){
                fprintf(arq_saida, "global _start\n_start:\n");
                start_flag = 1;
              } //if start_flag
            } //if strcmp
            else if(!strcmp(tokens_linha[i+1], "data")){
              def_sec_text = 0;
              def_sec_data = 1;
            }
          break;
          case SPACE:
            //Se tiver operando
            if(flag_if){
               fprintf(arq_saida, "section .bss\n");
              if(tokens_linha[i+1]!="\0" && tokens_linha[i+1]!=NULL && (strstr(tokens_linha[i+1], ";")==NULL)){
                fprintf(arq_saida, "%s resd %s\n", tokens_linha[i-1], tokens_linha[i+1]);
              }
              //Se n tiver operando
              else{
                fprintf(arq_saida, "%s resd 1\n", tokens_linha[i-1]);
              }
              if(def_sec_data){
                fprintf(arq_saida, "section .data\n");
              }
              else if(def_sec_text){
                fprintf(arq_saida, "section .text\n");
              }
            }
            else{
                if(tokens_linha[i+1]!="\0" && tokens_linha[i+1]!=NULL && (strstr(tokens_linha[i+1], ";")==NULL)){
                    insere_elemento(lista_bss, tokens_linha[i-1], tokens_linha[i+1]);
                    }
                //Se n tiver operando
                else{
                  insere_elemento(lista_bss, tokens_linha[i-1], "1");
                }
              } //else (flag_if)
          break;
          case CONST:
            fprintf(arq_saida, "dd %s\n", tokens_linha[i+1]);
          break;
          case EQU:
            fprintf(arq_saida, "EQU %s\n", tokens_linha[i+1]);
          break;
          case IF:
            fprintf(arq_saida, "%%if %s == 1\n", tokens_linha[i+1]);
            flag_if = 2;
          break;
          default:
          break;

        } //switch
        //Se for label, imprime-o
				if(strstr(tokens_linha[i], ":")){
            //Se opcode for SPACE, n escreve label pois estara em uma lista
            if((opcode(tokens_linha[i+1])) != SPACE){
					       fprintf(arq_saida, "%s ", tokens_linha[i]);
               }
				}
      } //For (todos os tokens de uma linha)
        //Se flag_if n for 0, decrementa
        if(flag_if){
          flag_if--;
          //Se apos o decremento for 0, escrever %endif
          if(!flag_if){
            fprintf(arq_saida, "%%endif\n");
          }
        }
      contador_linha++;
		} //while (!feof)

    //Apos terminar a leitura do arquivo, escrever os elementos bss:
    fprintf(arq_saida, "\nsection .bss\n");
    exibe_lista(arq_saida,lista_bss);

    escreve_funcoes(arq_saida);

    libera_lista(lista_bss);
    fclose(arq_saida);
    fclose(arq_entrada);
 }


//Funcao que escreve no arquivo de saida todas as funcoes feitas em assembly
 void escreve_funcoes(FILE *arq_saida){
   char *string = "../asm/todas_funcoes.asm";
   char linha[TLINHA];
   char *instrucao;
   FILE *arq_funcoes = fopen(string, "r");

   if(arq_funcoes == NULL){
     printf("Erro terminal: erro ao abrir arquivo %s\n", string);
     exit(-3);
   } //if

   while(!feof(arq_funcoes)){
			// Funcao fgets() lê até TLINHA caracteres ou até o '\n'
			instrucao = fgets(linha, TLINHA, arq_funcoes);
      if(instrucao!=NULL){
        fprintf(arq_saida, "%s", instrucao);
      }

    } // while

 }

 char* int_para_string(int i, char* b){
     char const digito[] = "0123456789";
     //b serve como modelo do tamanho de string para p
     char* p = b;

     int shifter = i;
     do{
         p++;
         shifter = shifter/10;
     }while(shifter);
     *p = '\0';
     do{ //Move de tras pra frente, colocando os digitos como chars
         *--p = digito[i%10];
         i = i/10;
     }while(i);
     return b;
 }

char* string_operando(char *operando){
  //Passa para caixa alta
  string_alta(operando);

  char *depois_mais;
  char *resultado = strdup(operando);
  int depois_mais_num;

  depois_mais = strstr(resultado, "+");

  //Se possuir mais, entao eh vetor
  if(depois_mais != NULL){
    //Vai pro numero (pula o +)
    depois_mais++;
    //Multiplica por 4, pois eh um deslocamento
    //de 32 bits por elemento
    depois_mais_num = 4*atoi(depois_mais);

    depois_mais = int_para_string(depois_mais_num, depois_mais);
  }

  return resultado;
}



/*
 *	pega_antes_mais()
 *
 *  Pega label ate '+'
 */
char* pega_antes_mais(char *token){
	int i = 0;
	char *resultado = token;

		for(i=0; i<strlen(token); i++){
			if(token[i]=='+'){
				resultado[i] = '\0';
				break;
			}
			resultado[i] = token[i];
		}
	return resultado;
}

 /*
  *  string_alta()
  *
  *  Funcao que passa uma string para caixa alta
  */
 void string_alta(char *s){
 	for(; *s; s++){
 		if(('a' <= *s) && (*s <= 'z'))
 			*s = 'A' + (*s - 'a');
 		}
 }

 /*
  *  string_baixa()
  *
  *  Funcao que passa uma string para caixa baixa
  */
 void string_baixa(char *s){
 	for(; *s; s++)
 		if(('A' <= *s) && (*s <= 'Z'))
 			*s = 'a' + (*s - 'A');
 }
