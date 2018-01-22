%{
#include <stdio.h>
#include <string.h>

FILE *ff, *fr;


%}

digit [0-9]
word [a-zA-Z]+

%%

{word}  {fprintf(fr,yytext);}
{digit}	{fprintf(fr,yytext);}
.	{fprintf(fr,yytext);}
\n	{fprintf(fr,yytext);}

%%



main(){
	ff=fopen("text1.txt","r+");
	fr=fopen("text2.txt","w+");
	yyin=ff;
	yylex();
}
