#include <iostream>

using namespace std;

int main()
{
#ifdef DEBUG
  cout << "Compiled: " << __DATE__ << " at " << __TIME__ << endl;
  cout << "This is line " << __LINE__ << ", of file " << __FILE__ << endl;
#endif
  cout << "If I am elected, there will be no new homework ..." << endl;
}
