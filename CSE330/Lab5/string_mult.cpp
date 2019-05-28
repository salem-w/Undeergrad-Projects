#include <iostream>
#include <string>
#include <stdlib.h>

using namespace std;


class Multiply {

private:
   string s;
public:

   Multiply (string s1): s(s1) {  }
 
   string operator*(const int n) const{
   string lhs = s;
   string product;
   for(int i = 0; i < n; i++)
      product += lhs;
   return product;
  }
};


int main(int argc, char* argv[]){
  if(argc != 3){
     cout << "please enter a string and a number for the program" << endl; 
  	 return 1;
  }
  int m = strtol(argv[2], NULL, 10);
  Multiply k(argv[1]);
  cout << (k * m) << endl;

  return 0;
}
