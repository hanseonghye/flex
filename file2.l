%{
#include <stdio.h>
#include <math.h>
%}

digit	[0-9]
id	[a-z][a-z0-9]*

%%

{digit}+ {printf("an integer: %s %d\n",yytext,atoi(yytext));}
{digit}+"."{digit}* { printf("a float:%s %g\n",yytext,atof(yytext));}
if |then |begin {printf("a keyword: %s\n",yytext); }
{id} {printf("an identifier: %s\n",yytext); }
"+"|"-"|"*"|"/" {printf("an operator : %s\n",yytext); }

%%

main(){

	yyin=fopen("test.txt","r");
	yylex();
}

