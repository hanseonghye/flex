#include <iostream>
#include <string>
#include <fstream>
#include <errno.h>
using namespace std;

int plus_point=3;
int min_point=2;
int lcs[1301][1301];


int lcs_max=0;

int main(int argc, char* argv[])
{

	ifstream fin_a, fin_b;
	fin_a.open(argv[1]);
	fin_b.open(argv[2]);
	int n=atoi(argv[3]);

	string str_a, str_b;
	string s;
	fin_a>>str_a; fin_b>>str_b;
	
//	cout<<str_a<<"\n	"; cout<<str_b<<"\n";

/*

	while(!fin_a.eof()){
		fin_a>>s;
		str_a=str_a+s;
	}
	
	while(!fin_b.eof()){
		fin_b>>s;
		str_b=str_b+s;
	}
*/
	fin_a.close(); fin_b.close();

	str_a='0'+str_a; str_b='0'+str_b;

	int len_a=str_a.length();
	int len_b=str_b.length();
	int bounce=0;

	//if(len_a-len_b>50 || len_b-len_a>50) {}
	//else{

	 	for(int i=0;i<len_a;++i){
	 		for(int j=0;j<len_b;++j){
				if(i==0||j==0)	{lcs[i][j]=0;  continue;}

				if(str_a[i]==str_b[j]) {
					lcs[i][j]=lcs[i-1][j-1]+plus_point;
					if(str_a[i]=='F' ||str_a[i]=='Y' || str_a[i]=='Z') lcs[i][j]=lcs[i][j]+6;
					else if(str_a[i]=='R') lcs[i][j]=lcs[i][j]+6;
					else if(str_a[i]=='K') lcs[i][j]=lcs[i][j]+2;
					if(lcs_max<lcs[i][j]) lcs_max=lcs[i][j];
				
				}
				else {
					int num1=lcs[i-1][j-1]-plus_point;
					int num2;

					if(lcs[i-1][j]>lcs[i][j-1]) num2=lcs[i-1][j]-min_point;
					else num2=lcs[i][j-1]-min_point;
					lcs[i][j]= ( num1>num2 ? num1 : num2 ) ;
					if(lcs[i][j]<0) lcs[i][j]=0;
	
				}

			}

		}
		
		cout<<n<<"% ";
		cout<<"file 1 : " <<argv[1]<<" "<<len_a<<" ";
		cout<<"file 2 : " <<argv[2]<<" "<<len_b<<" ";
		
		cout<<"LCS is "<<lcs_max;

//	}

	return 0;
}
