#include <iostream>
#include <string>
#include <fstream>
using namespace std;

int plus_point=4;
int min_point=4;
int lcs[1001][1001];
int table[1001][1001];

int main(int argc, char* argv[])
{
	ifstream fin_a, fin_b;
	fin_a.open(argv[1]);
	fin_b.open(argv[2]);
	int n=atoi(argv[3]);

	string str_a, str_b;
	string s;
	fin_a>>str_a; fin_b>>str_b;



	while(!fin_a.eof()){
		fin_a>>s;
		str_a=str_a+s;
	}
	
	while(!fin_b.eof()){
		fin_b>>s;
		str_b=str_b+s;
	}

	fin_a.close(); fin_b.close();

	str_a='0'+str_a; str_b='0'+str_b;

	int len_a=str_a.length();
	int len_b=str_b.length();
	int bounce=0;

	if(len_a-len_b>50 || len_b-len_a>50) {}
	else{

	 	for(int i=0;i<len_a;++i){
	 		for(int j=0;j<len_b;++j){
				if(i==0||j==0)	{lcs[i][j]=0; table[i][j]=0; continue;}

				if(str_a[i]==str_b[j]) {
					
					table[i][j]=1;
					int bounce=-1;
					for(int b=1;b<i&&b<j;++b){
						if(table[i-b][j-b]==0) { bounce=b; break; }
					}

					if(bounce==-1){ bounce= i>j ? i :j ; }
					lcs[i][j]=lcs[i-1][j-1]+bounce*4;
					if(str_a[i]=='F' ||str_a[i]=='Y' || str_a[i]=='Z') lcs[i][j]=lcs[i][j]+10;
					else if(str_a[i]=='R') lcs[i][j]=lcs[i][j]+10;
					else if(str_a[i]=='K') lcs[i][j]=lcs[i][j]+5;
				
				}
				else {
					table[i][j]=0;
					if(lcs[i-1][j]>lcs[i][j-1]) lcs[i][j]=lcs[i-1][j];
					else lcs[i][j]=lcs[i][j-1];
					
	
				}

			}

		}
		
		cout<<n<<"%1154  ";
		cout<<"file 1 : " <<argv[1]<<" "<<len_a<<" ";
		cout<<"file 2 : " <<argv[2]<<" "<<len_b<<" ";
		
		cout<<"LCS is "<<lcs[len_a-1][len_b-1];

	}

	return 0;
}
