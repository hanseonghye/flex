%{
#include <stdio.h>
int temp;
%}

digit [0-9]

%%
{digit}+ {temp=atoi(yytext);
		printf("%d*2=%d\n",temp,my_double(temp)); }
.+	;

^\n	exit(0);
%%

int my_double(int digit)
{
	return (digit*2);
}
