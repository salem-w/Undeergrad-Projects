#include <iostream>

using namespace std;
class funobj
{
  public:
    int operator()(int a, int b) {
	  return (a % b);
    }
};

main()
{
  funobj f1;
  cout << f1(33, 21) << endl;

}
