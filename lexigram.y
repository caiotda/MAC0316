%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *oper(char op, char *l, char *r) {
	/* Função que recebe dois operandos l r e uma operação e retorna uma 
	string na forma (op l r) */
	char *res = malloc(strlen(l)+strlen(r)+6);
	sprintf(res, "(%c %s %s)", op, l, r);
	return res;
}
char *functionPrint(char *name, char *param) {
	/* Função que recebe uma função name com parametros "param" e retorna uma 
	string na forma (call name param) */
	char *res = malloc(strlen("call") + strlen(name) + strlen(param) + 6);
	sprintf(res, "(%s %s %s)", "call", name, param);
	return res;
}
char *ifPrint(char *cond, char *t, char *f) {
	/* Função que recebe uma condição True (t), uma condição False(f) e retorna
	uma string na forma (if (cond) (t) (f)) */
	char *res = malloc(strlen(cond) + strlen(t) + strlen(f) + 8);
	sprintf(res, "(if %s %s %s)", cond, t, f);
	return res;
}
char *dup(char *orig) {
	/* Função que devolve orig*/
	char *res = malloc(strlen(orig)+1);
	strcpy(res,orig);
	return res;
}
int yylex();
void yyerror(char *);
%}

%union {
	char *val;
	char *fun;
}

%token	<val> NUM
%token  ADD SUB MUL DIV MOD FUN IF COL QTN PRINT OPEN CLOSE
%type	<val> exp
%type	<fun> FUN 


%left ADD SUB
%left MUL DIV
%left NEG

/* Gramatica */
%%

input: 		
		| 		exp{ puts($1);}
		| 		error  	{ fprintf(stderr, "Entrada inválida\n"); }
;

exp: 			NUM 		{ $$ = dup($1); }
		|		IF OPEN exp CLOSE QTN exp COL exp{ $$ = ifPrint($3, $6, $8);}
		|		FUN OPEN exp CLOSE{ $$ = functionPrint($1, $3);}
		| 		exp ADD exp	{ $$ = oper('+', $1, $3);}
		| 		exp SUB exp	{ $$ = oper('-', $1, $3);}
		| 		exp MUL exp	{ $$ = oper('*', $1, $3);}
		|		exp DIV exp { $$ = oper('/', $1, $3);}
		|		exp MOD exp { $$ = oper('%', $1, $3);}
		| 		SUB exp %prec NEG  { $$ = oper('~', $2, "");} 
		| 		OPEN exp CLOSE	{ $$ = dup($2);}
;

%%

void yyerror(char *s) {
  fprintf(stderr,"%s\n",s);
}