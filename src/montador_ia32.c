/*
 *  Projeto 2
 *  Software Básico
 *  1/2017
 *
 *  Davi Rabbouni 15/0033010
 *  Lucas Santos 14/0151010
 */
#include "montador_ia32.h"

/*** PRE-MONTAGEM ***/
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

/*** MONTAGEM ***/
/*
 * Campo po (Primary Opcode):
 *  0 = EAX
 *  1 = ECX
 *  2 = EDX
 *  3 = EBX
 *  4 = ESP
 *  5 = EBP
 *  6 = ESI
 *  7 = EDI
 *
 * Campo o (Register/Opcode Field):
 *  0-7 = extensao do opcode
 *        00, Reg 0-7, 000
 *  r   = ModR/M byte contem um operando registrador e um operando r/m (endereco de memoria armazenado em um reg)
 *        Mod 00, Reg 0-7, R/M 5
 */
unsigned char* montagem(int argc, char *argv[]){

}


//TODO : Gerar este vetor code a partir do arquivo .s
/* O programa simplesmente SAI e manda 42 para o SO */
unsigned char code_teste[] = {
    0xBB, 0x2A, 0x00, 0x00, 0x00, /* movl $42, %ebx */
    0xB8, 0x01, 0x00, 0x00, 0x00, /* movl $1, %eax */
    0xCD, 0x80            /* int $0x80 */
};
/*endereço virtual onde sera carregado o programa*/
#define LOADADDR    0x08048000
/* ELF FORMAT

EHDR: a tabela de cabeçalho do arquivo ELF com informações gerais
PHDR: a tablea de cabeçalho do Programa com informações específicas do programa

+----------------------------------+  <- LOADADDR (0x08048000) Endereço a ser carregado (virtual)
|  The ELF Exec Header.            |
+----------------------------------+
|  The ELF PHDR Table.             |
+----------------------------------+ <- ehdr->e_entry, DEVE apontar a esta região do arquivo.
|  The ".text" section.            |
+----------------------------------+ <- O final da região a ser carregada deste objeto.
|  The section name string table   |
|  (optional).                     |
+----------------------------------+
|  Section headers:                |
|  - Header for section ".text".   |
|  - Section name string table     |
|    header.                       |
+----------------------------------+
*/
void geracao_elf(unsigned char* code){
  int           fd;
  Elf           *e;
  Elf_Scn       *scn;
  Elf_Data      *data;
  Elf32_Ehdr    *ehdr;
  Elf32_Phdr    *phdr;
  Elf32_Shdr    *shdr;

  size_t ehdrsz, phdrsz;

  if (elf_version(EV_CURRENT) == EV_NONE)
    errx(EX_SOFTWARE,"elf_version is ev_none? %s\n",elf_errmsg(-1));
  if ((fd = open("arquivo.bin", O_WRONLY | O_CREAT, 0777)) < 0)
    errx(EX_OSERR, "open %s\n",elf_errmsg(-1));
  if ((e = elf_begin(fd, ELF_C_WRITE, NULL)) == NULL)
    errx(EX_SOFTWARE,"elf_begin %s\n",elf_errmsg(-1));
  if ((ehdr = elf32_newehdr(e)) == NULL)
    errx(EX_SOFTWARE,"elf32_newehdr %s\n",elf_errmsg(-1));

  ehdr->e_version = 1;

  /*O código a ser executado deve ser colocado após a tabela PHDR, logo devemos calcular o tamanho das tabelas EHDR e PHDR*/
  ehdrsz = elf32_fsize(ELF_T_EHDR, 1, EV_CURRENT);
  phdrsz = elf32_fsize(ELF_T_PHDR, 1, EV_CURRENT);

  /*Indica que a codificação é complemento de 2 com o byte menos significativo ocupando o endereço menor.
  Pode ser mudado para ELFDATA2MSB onde o byte mais significativo deve ocupar o endereço menor*/
  ehdr->e_ident[EI_DATA] = ELFDATA2LSB;
  /*Identifica que eh ELF de 32 bits*/
  ehdr->e_ident[EI_CLASS] = ELFCLASS32;
  /*Identifica a arquitetura necessária para rodar o arquivo, neste casso INTEL 80386*/
  ehdr->e_machine = EM_386;
  /*Identifica que é um arquivo executavél*/
  ehdr->e_type = ET_EXEC;
  /*Aponta o lugar onde começa o código (endereço virtual + tamanho de EHDR + tamanho de PHDR*/
  ehdr->e_entry = LOADADDR + ehdrsz + phdrsz;

  if ((phdr = elf32_newphdr(e,1)) == NULL)
    errx(EX_SOFTWARE,"elf32_newphdr %s\n",elf_errmsg(-1));

  if ((scn = elf_newscn(e)) == NULL)
    errx(EX_SOFTWARE,"elf32_newscn %s\n", elf_errmsg(-1));

  if ((data = elf_newdata(scn)) == NULL)
    errx(EX_SOFTWARE,"elf32_newdata %s\n", elf_errmsg(-1));

  /*data é da bibleoteca libelf, usada para colocar os dados nas seções*/
  /*Liga a seção a sua respectiva SHDR*/
  data->d_align = 1;
  data->d_off = 0LL;
  /*ponteiro ao inicio do codigo*/
  data->d_buf = code_teste;
  /*O codigo vai usar dados no formato ELF_T_BYTE*/
  data->d_type = ELF_T_BYTE;
  /*Tamanho do codigo*/
  data->d_size = sizeof(code_teste);
  data->d_version = EV_CURRENT;

  if ((shdr = elf32_getshdr(scn)) == NULL)
    errx(EX_SOFTWARE,"elf32_getshdr %s\n", elf_errmsg(-1));

  /*SHDR é a tabela de seção, cada seção deve ter sua SHDR para serem ligadas (linking) no arquivo objeto, mas são opcionais no arquivo executavél*/
  /*Especifica o nome da seção*/
  shdr->sh_name = 1;
  /*Identifica o tipo de seção, neste caso bits protegidos. Que não devem ser ligados nem modificados*/
  shdr->sh_type = SHT_PROGBITS;
  /*ponteiros que indicam que esta seção possui dados de execução e que devem ser alocados em memória*/
  shdr->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
  /*sh_addr é ponteiro para a seção*/
  shdr->sh_addr = LOADADDR + ehdrsz + phdrsz;

  if ((phdr = elf32_newphdr(e,1)) == NULL)
    errx(EX_SOFTWARE,"elf32_newphdr %s\n", elf_errmsg(-1));

  /*Descreve o tipo de segmento a ser interpretado, neste caso: SEGMENTO CARREGAVEL*/
  phdr->p_type = PT_LOAD;
  phdr->p_offset = 0;
  /*Indica o tamanho da da imagem, tamanho das tabelas + tamanho do código*/
  phdr->p_filesz = ehdrsz + phdrsz + sizeof(code);
  /*Tamanho de bytes necessário em memória para carregar a imagem*/
  phdr->p_memsz = phdr->p_filesz;
  /*endereço virtual onde o primeiro byte do programa deve estar em memória*/
  phdr->p_vaddr = LOADADDR;
  /*endereço físico (normalmente ignorado já que é utilizado o endereço virtual)*/
  phdr->p_paddr = phdr->p_vaddr;
  /*Valores 0 e 1 indicam que não precisa de alinhamento, se não deve ser potencia de 2*/
  phdr->p_align = 4;
  /*Flags para o tipo TEXT*/
  phdr->p_flags = PF_X | PF_R;

  elf_flagphdr(e, ELF_C_SET, ELF_F_DIRTY);

  if (elf_update(e, ELF_C_WRITE) < 0 )
    errx(EX_SOFTWARE,"elf32_update_2 %s\n",elf_errmsg(-1));

  elf_end(e);
  close(fd);
}
