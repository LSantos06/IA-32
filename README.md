# [IA-32](https://github.com/LSantos06/IA-32)
### Trabalho 2 de Software Básico 1/2017
O trabalho consiste em duas partes:
1.  Implementar em C um método de tradução de uma linguagem de montagem simples para uma representação de código objeto e _IA-32_; 
2.  Implementar um programa em C um arquivo executável em formato _ELF32_ (Bônus).

### Parte 1
O programa ligador (__tradutor.c__) deve receber um arquivo (__arquivo.asm__) como argumento. Este arquivo deve estar na linguagem _Assembly Hipotética_ vista em sala de aula, separado em seções de _dados_ e _códigos_. 
__Não__ será feita detecção de erros léxicos, semânticos ou sintáticos. 
A linguagem _Assembly Hipotética_ é formada por um conjunto de instruções e diretivas mostradas na tabela a seguir:




O programa deve entregar como saída um arquivo em formato texto (__arquivo.s__) que deve ser a tradução do programa de entrada em _Assembly IA-32_.

### Parte 2
Realizar um programa carregador, chamado __montador ia32.c__, que receba o arquivo de saída da parte 1 e gere um arquivo binário (__arquivo.bin__). O arquivo binário deve conter instruções (Opcodes) da linguagem _Assembly IA-32_. Esse arquivo deve ser um arquivo executável em formato _ELF32_ capaz de ser executado em qualquer máquina _INTEL 386_ ou superior, rodando _SO
LINUX_. Para isso recomenda-se o uso da biblioteca _libelf_ para a criação do arquivo _ELF32_.

### Integrantes do grupo
* Davi Rabbouni - 15/0033010
  - [X] _Versão do gcc_: gcc version 6.2.0 20161005 (Ubuntu 6.2.0-5ubuntu12) 
  - [X] _Sistema Operacional_: Ubuntu 16.10 (64-bit) "yakkety"
* Lucas Santos - 14/0151010
  - [X] _Versão do gcc_: gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) 
  - [X] _Sistema Operacional_: elementary OS 0.4 Loki (64-bit) Built on "Ubuntu 16.04.2 LTS"
