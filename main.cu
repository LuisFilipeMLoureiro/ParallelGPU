#include <iostream>
#include<random>
#include <algorithm>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/device_vector.h>


using namespace std;


struct Indexes{

    int i;
    int j;
    int size;
};



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

vector<Indexes> index_generator(string DNA, int size)
{

    vector<Indexes> IndexList;
    Indexes index;

    for (int i = 0; i < size; i++)
    {
        for (int j = i + 1; j < size; j++)
        {
            index.i = i;
            index.j = j;
            index.size = j - i;

            IndexList.push_back(index);
        }
    }


    return IndexList;

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


    vector<Indexes> IndexSeqA = index_generator(SeqA, n);
    vector<Indexes> IndexSeqB = index_generator(SeqB, m);


    vector<char> VSeqA;
    vector<char> VSeqB;

    for(auto&A:SeqA){
    	VSeqA.push_back(A);		
    }
    for(auto&B:SeqB){
    	VSeqB.push_back(B);
    }


    thrust::device_vector<char> SeqA_GPU(VSeqA);
    thrust::device_vector<char> SeqB_GPU(VSeqB);
    thrust::device_vector<int> MatchVec(m);



    for (auto&Seq_A:IndexSeqA)
    {
        for(auto&Seq_B:IndexSeqB)
        {
            if (Seq_A.size == Seq_B.size)
            {
                thrust::transform(SeqA_GPU.begin() + Seq_A.i, SeqA_GPU.begin() + Seq_A.j, SeqB_GPU.begin() + Seq_B.i, MatchVec.begin(), custom_transform());

                int score = thrust::reduce(MatchVec.begin(), MatchVec.end(),0, thrust::plus<int>());
                
                if (score > match)
                {
                    match = score;
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

