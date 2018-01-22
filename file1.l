%{
#include <stdio.h>
int temp;
%}

digit [0-9]

%%
{digit}+ {temp=atoi(yytext);
		printf("%d*2=%d\n",temp,my_double(temp)); }

	
%%

main(){
	yyin=fopen("test.txt","a+");
	yylex();
}
	
int my_double(int digit)
{
	return (digit*2);
}
