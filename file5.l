%{
#include <stdio.h>
#include <string.h>

FILE *ff, *fr;

int fun_start=0;
int bra_num=0;
int vector_=0, cstring_=0;
%}

digit 	[0-9]+
word	[a-zA-Z_]+[a-zA-Z_0-9\[\]]*
call_fun [a-zA-Z_]+[a-zA-Z_0-9]*\([a-zA-Z_0-9" "]*\)
define_fun 	[a-z]+[" "\n]+[a-zA-Z_]+[a-zA-Z_0-9]*\([a-zA-Z_0-9" "]*\)
fun_end [" "\n]*\{
vector	push_back{inja};*|pop_back{inja};|vector[" "]*<[" "]*{word}[" "]*>
inja	[" "]*\([a-zA-Z_0-9" "]*\)
include	#include[" "]+
cstring size\(\)
bit_op	<<|>>|&|\^|\|~|\|
relational_op	<=|>=|>|<|==|!=
arithm_op	\+|-|\*|\/|%
assignment_op	\+=|-=|\*=|\/=|%=|<<=|>>=|&=|^=|\|=
assign		=
increment_op	\+\+
decrement_op	--
logical_op	&&|\|\||!
comma		,
pointer		\*{word}
address		&
keyword		asm|auto|bool|break|case|catch|char|class|const|const_cast|continue|default|delete|do|double|else|enum|explicit|export|extern|false|float|for|goto|if|friend|inline|int|long|namespace|new|operator|private|protected|public|register|return|short|signed|sizeof|static|struct|switch|this|true|typeded|try|throw|typeid|typename|union|unsigned|using|virtual|void|volatile|while|#define
string		\".*\"




%%

{include}<vector>	{vector_=1;}
{include}<cstring>	{cstring_=1;}
{include}<iostream>	;
{include}<algorithm>	;
{include}<fstream>	;
{vector}		{ if(vector_==1) my_print2("function"); }
{cstring};		{ if(cstring_==1) my_print2("function"); }

{increment_op}		{ my_print2("incre"); }
{decrement_op}		{ my_print2("decre"); }
{assignment_op}		{ my_print2("as_op"); }
{bit_op}		{ my_print2("bit_op"); }
{relational_op}		{ my_print2("re_op"); }
{logical_op}		{ my_print2("lo_op"); }
{assign}		{ my_print2("as_op"); }
{arithm_op}		{ my_print2("ar_op"); }

{define_fun};		;
{define_fun}{fun_end}	{my_print(); fun_start=1; }
\{			{ if(fun_start==1) ++bra_num;}
\}			{ if(fun_start==1){
			if(bra_num==0){ fun_start=0; my_print(); fprintf(fr,"\n"); }
			else --bra_num; 			
			  }
			}
{call_fun};		{ my_print(); }
{string}		{ my_print2("string"); }
{digit}			{ my_print2("num"); }
{keyword}		{ my_print2("KEY"); }
{word}			{ my_print2("ID"); }



%%


main(){
	ff=fopen("input3.txt","r+");
	fr=fopen("output3.txt","w+");
	yyin=ff;
	yylex();
}

void my_print(void)
{ fprintf(fr,"$"); fprintf(fr,yytext); fprintf(fr," "); }

void my_print2(char* str)
{ fprintf(fr,"$"); fprintf(fr,str); fprintf(fr," "); }
