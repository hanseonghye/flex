%{
#include <stdio.h>
#include <string.h>
FILE *ff;

int fun_start=0;
int bra_num=0;
int count=0;
int PRINT_ENTER=4;
int macro_start=0;

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
	else 	{ printf("\n"); count=0; } 

	char *fun_name;
	char _name[15];
	char *name=s;
	char str[30]="$";
	int len, point=0;
	int i;
	
	name=strtok(name,"("); 
	len=strlen(name);
	
	for(i=len-1;i>0;--i){
		if(name[i]!=' ') {point=i; break; }
	}
	name=substr(name,0,point);
	
	len=strlen(name);
	for(i=len-1;i>0;--i){
		if(name[i]==' ') { point=i+1; break; }
		if(name[i]==':') { point=i+1; break; }
		if(name[i]=='	') { point=i+1; break; }
	}
	if(i==0) fun_name=name;
	else fun_name=substr(name,point,strlen(name));

	strcat(fun_name,"{");
	strcat(str,fun_name);
	
	printf("%-30s",str); printf("\n"); count=0; 
}


void define_fun2(char* s)						//define function
{ 
	if(s[0]=='\n') {}
	else 	{ printf("\n"); count=0; } 

	char *fun_name;
	char _name[15];
	char *name=s;
	char str[30]="$";
	int len, point=0;
	int i;
	
	name=strtok(name,"("); 
	len=strlen(name);
	
	for(i=len-1;i>0;--i){
		if(name[i]!=' ') {point=i; break; }
	}
	name=substr(name,0,point);
	
	len=strlen(name);
	for(i=len-1;i>0;--i){
		if(name[i]=='&') { point=i+1; break; }
		if(name[i]=='*') { point=i+1; break; }
		if(name[i]==':') { point=i+1; break; }
	}

	if(i==0) fun_name=name;
	else fun_name=substr(name,point,strlen(name));

	strcat(fun_name,"{");
	strcat(str,fun_name);
	
	printf("%-30s",str); printf("\n"); count=0; 
}

void print_fun(char* s)						//call function
{	if(fun_start==1 || macro_start==1){
		char *fun_name=s;
		char str[30]="@";

		fun_name=strtok(fun_name,"(");		
		strcat(str,fun_name); 
		count_print(); printf("%30s",str); 
	}
}

void my_print(char* str)			
{ if(fun_start==1 || macro_start==1) {count_print(); printf("%30s",str);}  }

void count_print(){
	if(count==PRINT_ENTER) { count=0; printf("\n"); }
	++count;
}

	


%}
comment1		"//".*\n|"//".*\r
comment2		"/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*"*"+"/"
digit 			(([0-9]+)|([0-9]*"."[0-9]+)([eE][-+]?[0-9]+)?)[;]?|"true"|"false"
string			\"[a-zA-Z0-9_\.\/]+[" "\t\n]*\"
ID			[\*&]*[a-zA-Z_]+[0-9]*("["([\*&]*[a-zA-Z_0-9]*)"]")*"->"?"."?

MACRO_FUN		"#define"[" "\t]*[a-zA-Z_]+[0-9]*\(([" "]*|([" "a-zA-Z0-9]+([," "\t]+[a-zA-Z0-9]+)*)+)\)

parameter		[" "]*|[" "]*"void"[" "]*|([" "]*[a-zA-Z]*[" "]*)[a-zA-Z_0-9\*]+(<[a-zA-Z_0-9" "]+>)*[" "\n\t\r\*&]+[a-zA-Z_0-9\*&\[\]]+(<[a-zA-Z_0-9" "]+>)*([" ",\n\t\r]+([" "]*[a-zA-Z]*[" "]*)[a-zA-Z_]+[a-zA-Z_0-9\<\>\*]*[" "\r\n\t*&]+[\n\ta-zA-Z_0-9\*&\<\>\[\]]+)*[" "\n\t\r]*

call_fun 		[a-zA-Z_]+[a-zA-Z_0-9]*[" "]*\({parameter}\)
call_fun2 		[a-zA-Z_]+[a-zA-Z_0-9]*[" "]*\(
define_fun 		[a-zA-Z_]+[" "]*[&\*]*[" "]+[a-zA-Z0-9_]*"::"?{call_fun}
define_fun2 		[a-zA-Z_]+[" "]*[&\*]+[a-zA-Z0-9_]*"::"?{call_fun}
class_define_fun	[a-zA-Z0-9_]*::{call_fun}
fun_end 		[" "\n\t\r]*"const"?[" "\n\t\r]*\{


bit_op			<<|>>|&|\^|\|~|\|
relational_op		<=|>=|>|<|==|!=|\?|:
arithm_op		\+|-|\*|\/|%
assignment_op		\+=|-=|\*=|\/=|%=|<<=|>>=|&=|^=|\|=
assign			=
increment_op		\+\+
decrement_op		--
logical_op		&&|\|\||!


keyword			asm|auto|bool|case|catch|char|class|const|const_cast|default|delete|do|double|else|enum|explicit|export|extern|float|goto|friend|inline|int|long|namespace|new|NULL|operator|private|protected|public|register|short|signed|sizeof|static|string|struct|switch|this|typeded|try|throw|typeid|typename|union|unsigned|using|virtual|void|volatile

keyword2		continue|break|return

IF_FOR_WHILE		(if|for|while|switch)+[" "\t]*\(





%%

{comment1}		;
{comment2}		;

{MACRO_FUN}		{ define_fun(yytext); macro_start=1;}


{define_fun}{fun_end}	{ define_fun(yytext);  fun_start=1; my_print("Y");}

{define_fun2}{fun_end}	{ define_fun2(yytext); fun_start=1;  my_print("Y"); }
	
\{			{ my_print("Y"); if(fun_start==1) ++bra_num;	}
\}			{ 
				if(fun_start==1){
					my_print("Z");
					if(bra_num==0){ my_print("}"); printf("\n"); fun_start=0; count=0;}
					else --bra_num; 			
			  	}
			}


{increment_op}		{ my_print("1"); }
{decrement_op}		{ my_print("2"); }
{assignment_op}		{ my_print("3"); }
{bit_op}		{ my_print("4"); }
{relational_op}		{ my_print("5"); }
{logical_op}		{ my_print("6"); }
{assign}		{ my_print("7"); }
{arithm_op}		{ my_print("8"); }

{IF_FOR_WHILE}		{ my_print("F");    }
{call_fun2}		{ print_fun(yytext);  }			//call function


{string}		{ my_print("S");  }
{digit}			{ my_print("N");  }
{keyword2}		{ my_print("K");  }
{keyword}		{ my_print("E");  }
{ID}			{ my_print("I");   }
\n			{ if(macro_start==1) {  my_print("}"); printf("\n"); macro_start=0; count=0; } }
.			;




%%


main(int argc, char *argv[]){
	ff=fopen(argv[1],"r+");
	yyin=ff;
	yylex();
	fclose(ff);
}



