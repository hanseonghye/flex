%{
#include <stdio.h>
int lineno=1;
%}

line .*\n
%option noyywrap
%%
{line} {printf("%5d %s",lineno++,yytext);}
%%

main()
{ yylex(); return 0; }
