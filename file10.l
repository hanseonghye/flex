%{
#include <stdio.h>
#include <string.h>
FILE *ff, *fr;

int fun_start=0;
int bra_num=0;
int count=0;
int PRINT_ENTER=6;

char *substr(char *input, int i_begin, int i_end)
{
     int cnt = 0;
     int size = (i_end - i_begin)+2;
     char *str = (char*)malloc(size);

     memset(str, 0, size);

     for(int i = i_begin; i <= i_end; i++)
     {
          str[cnt] = input[i];
          cnt++;
     }

     return str;
}


void define_fun(char* s)						//define function
{ 
	if(s[0]=='\n') {}
	else 	{ fprintf(fr,"\n"); count=0; } 

	char *fun_name;
	char _name[15];
	char *name=s;
	char str[30]="$";
	int len, point;
	int i;
	
	name=strtok(name,"("); 
	len=strlen(name);
	
	for(i=len-1;i>0;--i){
		if(name[i]!=' ') {point=i; break; }
	}
	name=substr(name,0,point);

	for(i=len-1;i>0;--i){
		if(name[i]==' ') { point=i+1; break; }
		if(name[i]==':') { point=i+1; break; }
	}
	
	fun_name=substr(name,point,strlen(name));
	strcat(fun_name,"{");
	strcat(str,fun_name);
	
	fprintf(fr,"%-20s",str); fprintf(fr,"\n"); count=0; 
}

void print_fun(char* s)						//call function
{	if(fun_start==1){
		char *fun_name=s;
		char str[30]="@";

		fun_name=strtok(fun_name,"(");		
		strcat(str,fun_name); 
		count_print(); fprintf(fr,"%20s",str); 
	}
}

void my_print(char* str)			
{ if(fun_start==1) {count_print(); fprintf(fr,"%20s",str);}  }

void count_print(){
	if(count==PRINT_ENTER) { count=0; fprintf(fr,"\n"); }
	++count;
}

	


%}
comment1		"//".*\n
comment2		"/*"([^*]|[\r\n]|"/*")*"*"+"/"
digit 			-?(([0-9]+)|([0-9]*"."[0-9]+)([eE][-+]?[0-9]+)?)[;]?
string			\".*[\\n]*\"
ID			[\*&]*[a-zA-Z_0-9]+("["([\*&]*[a-zA-Z_0-9]*)"]")*"->"?"."?

MACRO_FUN		"#define"[" "\t]+[a-zA-Z0-9_]+\(([a-zA-Z0-9_]*[" ",]*[a-zA-Z0-9_]*)*)\)

parameter		[" "]*|[" "]*"void"[" "]*|([" "]*[a-zA-Z]*[" "]*)[a-zA-Z_0-9\<\>\*]*([" "\n\t\*&]*)+[a-zA-Z_0-9\*&\<\>\[\]]+([" ",\n\t]+([" "]*[a-zA-Z]*[" "]*)[a-zA-Z_]+[a-zA-Z_0-9\<\>\*]*[" "\n\t*&]+[\n\ta-zA-Z_0-9\*&\<\>\[\]]+)*[" "\n\t]*
call_fun 		[a-zA-Z_]+[a-zA-Z_0-9]*[" "]*\({parameter}\)
call_fun2 		[a-zA-Z_]+[a-zA-Z_0-9]*[" "]*\(
define_fun 		[a-z]+[" "]*[&\*]*[" "]+[a-zA-Z0-9_]*"::"?{call_fun}
class_define_fun	[a-zA-Z0-9_]*::{call_fun}
fun_end 		[" "\n]*\{


bit_op			<<|>>|&|\^|\|~|\|
relational_op		<=|>=|>|<|==|!=|\?|:
arithm_op		\+|-|\*|\/|%
assignment_op		\+=|-=|\*=|\/=|%=|<<=|>>=|&=|^=|\|=
assign			=
increment_op		\+\+
decrement_op		--
logical_op		&&|\|\||!


keyword			asm|auto|bool|break|case|catch|char|class|const|const_cast|continue|default|delete|do|double|else|enum|explicit|export|extern|false|float|goto|friend|inline|int|long|namespace|new|operator|private|protected|public|register|return|short|signed|sizeof|static|struct|switch|this|true|typeded|try|throw|typeid|typename|union|unsigned|using|virtual|void|volatile

IF_FOR_WHILE		(if|for|while)+[" "\t]*\(




%%

{comment1}		;
{comment2}		;

{class_define_fun}{fun_end} |					//define function
{define_fun}{fun_end}	{ define_fun(yytext); fun_start=1; }
	
\{			{ if(fun_start==1) ++bra_num;}
\}			{ if(fun_start==1){
			if(bra_num==0){ my_print("}"); fprintf(fr,"\n"); fun_start=0; count=0;}
			else --bra_num; 			
			  }
			}

{increment_op}		{ my_print("OP_INC"); }
{decrement_op}		{ my_print("OP_DEC"); }
{assignment_op}		{ my_print("OP_AS1"); }
{bit_op}		{ my_print("OP_BIT"); }
{relational_op}		{ my_print("OP_REL"); }
{logical_op}		{ my_print("OP_LOG"); }
{assign}		{ my_print("OP_AS2"); }
{arithm_op}		{ my_print("OP_ARI"); }

{IF_FOR_WHILE}		{ my_print("KEY");  }
{call_fun2}		{ print_fun(yytext);      }			//call function


{string}		{ my_print("STR");  }
{digit}			{ my_print("NUM");  }
{keyword}		{ my_print("KEY");  }
{ID}			{ my_print("ID");   }


%%


main(){
	ff=fopen("input8.txt","r+");
	fr=fopen("output8.txt","w+");
	yyin=ff;
	yylex();
}




