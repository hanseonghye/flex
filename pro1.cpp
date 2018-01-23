#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include <deque>

using namespace std;

class fun{
 public:
    string fun_name;
    deque<string> fun_list;
};

int token_count=0;

deque<fun> all;
deque<string> last_q;
ofstream fout;

int print_count=0;

string return_fun_name(string str){
    string re_str=str.substr(1,str.size()-2);
    return re_str;
}

string change_call_fun_name(string str){
    string re_str=str.substr(1);
    int  is_not_fun=0;

    for(int i=0;i<all.size();++i){
        if(re_str==all[i].fun_name) {is_not_fun=1; break;}
    }

    if(is_not_fun==0){return "Q";}

    return str;
}

string is_recursive(string big_name, string s_name){
    string s=s_name.substr(1);
    if(big_name==s) return "R";
    return s_name;
}


void call_function(string str){
    string fun_name=str.substr(1);
    for(int j=0;j<all.size();++j){
        if(all[j].fun_name==fun_name){
            for(int k=0;k<all[j].fun_list.size();++k){
                string ss=all[j].fun_list[k];
                if(ss[0]=='@') call_function(ss);
                else {last_q.push_back(ss); fout<<ss<<"\n"; ++token_count; }
            }
            break;
        }
    }
}


int main(int argc, char* argv[])
{
    ifstream fin;
    fin.open(argv[1]);
    fout.open(argv[2]);
    string fin_str;

    int main_point;

                                                        /* 함수 별로 큐에 넣기 ! */
    while(!fin.eof()){
        fin>>fin_str;

        if(fin_str[0]=='$'){
                fun temp;
                temp.fun_name=return_fun_name(fin_str);

                while(1){
                    fin>>fin_str;
                    if(fin_str=="}") break;
                    temp.fun_list.push_back(fin_str);
                }
                all.push_back(temp);
        }
        else break;
    }

	fin.close();
                                                    // 저장된 함수 제외 함수 key로 변경
    for(int i=0;i<all.size();++i){
        if(all[i].fun_name=="main") main_point=i;
        for(int j=0;j<all[i].fun_list.size();++j){
            string call_fun_name=all[i].fun_list[j];
            if(call_fun_name[0]=='@') { all[i].fun_list[j]=change_call_fun_name(all[i].fun_list[j]); }
            if(call_fun_name[0]=='@') { all[i].fun_list[j]=is_recursive(all[i].fun_name, all[i].fun_list[j]); }
        }
    }

    for(int i=0;i<all[main_point].fun_list.size();++i){
        string last_s=all[main_point].fun_list[i];
        if(last_s[0]=='@'){call_function(last_s);}
        else {last_q.push_back(last_s); fout<<last_s<<"\n"; ++token_count;}
    }
	
	fout.close();


	cout<<argv[1]<<": token is "<<token_count;
/*
    for(int i=0;i<all.size();++i){
        cout<<all[i].fun_name<<"\n";
        for(int j=0;j<all[i].fun_list.size();++j){
            cout.width(15); cout<<all[i].fun_list[j]<<" ";
        }
        cout<<"\n\n\n";
    }
*/

    return 0;
}

