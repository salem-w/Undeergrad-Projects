#include <queue>
#include <iostream>
#include <vector>
#include <string>
#include <fstream>

using namespace std;


/**class Message {
protected:
  string msg;
  int	 priority;
public:
  //contructor
  Message ( string m = "", int p = 0 ) : msg( m ), priority ( p ){}
  bool operator () ( const Message m1, const Message m2 )
  {
    return m1.priority < m2.priority;
  }

  const string getMessage() 
  {
    return msg;
  }
};

*/

template <class T>
void print(vector<T> &a)
{
	int i;
	for(i = 0; i < a.size(); i++)
		cout << a[i] << " ";
	cout << "\n";
}

main()
{
	ifstream is("input.txt");
	string word;
	priority_queue<string> pq;
	vector<string> v;

	while(is >> word)
	{
		pq.push(word);
	}

	while(!pq.empty())
	{	
		v.push_back(pq.top());
		pq.pop();
	}
	
	ofstream of;
	of.open("output.txt");

	while(!v.empty())
	{
		of << v.back() << " ";
		v.pop_back();
	}
	print(v);
}
