%{
#include <stdio.h>
#include <string.h>

FILE *ff, *fr;
int is_start=0;
int fun_start=0;
int bra_num=0;
int vector_=0, cstring_=0;
%}

digit 	[0-9]+
eol 	\n
word	[a-zA-Z_]+[a-zA-Z_0-9]*
define_fun 	[a-z]+[" "\n]+[a-zA-Z_]+[a-zA-Z_0-9]*\([a-zA-Z_0-9" "]*\)
call_fun [a-zA-Z_]+[a-zA-Z_0-9]*\([a-zA-Z_0-9" "]*\)
fun_end [" "\n]*\{
mytype 	if|while|for
vector	push_back{inja}*|pop_back{inja}
inja	[" "]*\([a-zA-Z_0-9" "]*\)
include	#include[" "]+
cstring size\(\)
shift	<<|>>
comp	<=|>=|>|<|==|!=




%%
{include}<vector>	{vector_=1;}
{include}<cstring>	{cstring_=1;}
{include}<iostream>	;
{include}<algorithm>	;
{include}<fstream>	;
{vector};	{ if(vector_==1) my_print2("function"); }
{cstring};	{ if(cstring_==1) my_print2("function"); }
std;		{ is_start=1; }
{define_fun};	;
{define_fun}{fun_end}	{my_print(); fun_start=1; }
ifstream	;
\{		{ if(fun_start==1) ++bra_num;}
\}		{ if(fun_start==1){
			if(bra_num==0){ fun_start=0; my_print(); fprintf(fr,"\n"); }
			else --bra_num; 			
		  }
		}
{call_fun};	{ my_print(); }
{mytype}	{ my_print(); }
{digit}		{ if(fun_start==1) my_print("num"); }
{word}		{ if(fun_start==1) my_print("ID"); }



%%


main(){
	ff=fopen("input2.txt","r+");
	fr=fopen("output2.txt","w+");
	yyin=ff;
	yylex();
}

void my_print(void)
{ fprintf(fr,"$"); fprintf(fr,yytext); fprintf(fr," "); }

void my_print2(char* str)
{ fprintf(fr,"$"); fprintf(fr,str); fprintf(fr," "); }
