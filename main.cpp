#include <iostream>
#include<random>
#include <algorithm>

using namespace std;

int calcula_valor(char a, char b){
    if(a==b){
        return 2;
    }else{
        return -1;
    }
}



// https://stackoverflow.com/questions/15726641/find-all-possible-substring-in-fastest-way
vector<string> subs_generator(string DNA, int size){
    vector<string> lista_subs;
    
    for(int i = 0; i < size; i++){
        for(int j = i + 1; j < size; j++){

            string x = DNA.substr(i,j);           
            lista_subs.push_back(x);
            
        }
        
        lista_subs.push_back(DNA);
        
    }
    return lista_subs;
}

int calculadora(string seqA, string seqB){
  int valor = 0;
  int contador = seqA.size();
  for (int i = 0; i < contador; i++){
    valor += calcula_valor(seqA[i], seqB[i]);
  }
  return valor;
}

int main()
{

    int n, m;    
    string SeqA, SeqB;

    cout << "Size Sequence A" << endl;
    cin >> n;
    cout << "Size Sequence B" << endl;
    cin >> m;
    cout << "Sequence A" << endl;
    cin >> SeqA;
    cout << "Sequence B" << endl;
    cin >> SeqB;

    vector<string> all_SeqA;
    vector<string> all_SeqB;

    int max;

    if(n>m){
        max = m;
    }else{
        max = n;
    }

    all_SeqA = subs_generator(SeqA, n);
    all_SeqB = subs_generator(SeqB, m);


    int cand_SeqA, cand_SeqB, match, id, contador, candidato;
    string finalSeqA, finalSeqB; 
    contador = 0;
    cand_SeqA = 0;
    cand_SeqB = 0;
   



    // Removing duplicated SeqA
    std::sort(all_SeqA.begin(), all_SeqA.end());
    all_SeqA.erase(std::unique(all_SeqA.begin(), all_SeqA.end()), all_SeqA.end());

    // Removing duplicated SeqB
    std::sort(all_SeqB.begin(), all_SeqB.end());
    all_SeqB.erase(std::unique(all_SeqB.begin(), all_SeqB.end()), all_SeqB.end());


    for (string i: all_SeqA){
        for (string j: all_SeqB){

            if(i.size() == j.size()){
                candidato = calculadora(i,j);
                if(contador == 0){
                    match = candidato;
                    finalSeqA = i;
                    finalSeqB = j;

                }else if(candidato>match){
                    match = candidato;
                    finalSeqA = i;
                    finalSeqB = j;

                }
            }
            contador ++;
                
            }
        
        
    }
    

    

    cout << "Resultados Finais:"<< endl;
    cout << "Match Max:"<< endl;
    cout << match << endl;
    cout << "Substrings que maximizaram o match:"<< endl;
    cout << "Seq A:"<< endl;
    cout << finalSeqA << endl;
    cout << "Seq B:"<< endl;
    cout << finalSeqB << endl;

    cout << ""<< endl;
    cout << "EOF"<< endl;    

    return 0;
}
