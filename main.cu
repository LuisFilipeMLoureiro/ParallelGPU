#include <iostream>
#include <algorithm>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/device_vector.h>
#include <vector>
#include <string>




using namespace std;

struct custom_transform
{
    __host__ __device__

    double operator()(const char &a, const char &b)
    { 
        if (a == b)
        {
            return 2;

        }

        return -1;
    }
};




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


    int cand_SeqA, cand_SeqB, id, contador, candidato, Asize, Bsize;
    string finalSeqA, finalSeqB; 
    contador = 0;
    cand_SeqA = 0;
    cand_SeqB = 0;
    int match = 0;
   



    // Removing duplicated SeqA
    std::sort(all_SeqA.begin(), all_SeqA.end());
    all_SeqA.erase(std::unique(all_SeqA.begin(), all_SeqA.end()), all_SeqA.end());

    // Removing duplicated SeqB
    std::sort(all_SeqB.begin(), all_SeqB.end());
    all_SeqB.erase(std::unique(all_SeqB.begin(), all_SeqB.end()), all_SeqB.end());

    thrust::device_vector<char> SeqA_GPU(SeqA);
    thrust::device_vector<char> SeqB_GPU(SeqB);
    thrust::device_vector<int> MatchVec(n);


    for(int i = 0; i < n; i++){
        for(int j = i + 1; j < n; j++){

            Asize = j - i;

            for (int i_B = 0; i_B < m; i_B++) {

                for (int j_B = i_B + 1; j_B < m; j_B++){


                    Bsize = j_B - i_B;

                    if (Asize == Bsize) {

                        thrust::transform(SeqA_GPU.begin() + i, SeqA_GPU.begin() + j, SeqB_GPU.begin() + i_B, MatchVec.begin(), custom_transform());

                        int score = thrust::reduce(MatchVec.begin(), MatchVec.end(),0, thrust::plus<int>());
                        
                        if (score > match) {
                            match = score;
                        }
                    }
                }
            }   
        }
    }
    

    

    cout << "Resultados Finais:"<< endl;
    cout << "Match Max:"<< endl;
    cout << match << endl;


    cout << ""<< endl;
    cout << "EOF"<< endl;    

    return 0;
}
