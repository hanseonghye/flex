%{
int charcount=0, wordcount=0, linecount=0;
%}

word	[^ \t\n]+
eol	\n
%%

{word}	{wordcount++; charcount+=yyleng;}
{eol}	{charcount++; linecount++;}
.	charcount++;

%%

main()
{
	yylex();
	printf("total line : %d\n",linecount);
	printf("total char : %d\n",charcount);
	printf("total word : %d\n",wordcount);
}
