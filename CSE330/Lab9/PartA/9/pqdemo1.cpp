//pqdemo1.pq : demo 2 of using priority queue
#include <queue>
#include <iostream>
#include <vector>
#include <string>

using namespace std;

//a function object class
class Message {
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

int main()
{
  /*
   The constructor 
    	1) puts element of type Message in queue,
  	2) implements queue with help of vector
	3) makes comparisons with a function object of type Message
  */
  priority_queue<Message, vector<Message>, Message> pq;
  string s = "This is a normal message";
  pq.push ( Message( s, 2 ) );		//put Message object in priority queue
  s = "This is an important message";
  pq.push ( Message( s, 5 ) );		//put Message object in priority queue
  s = "This is an urgent message";
  pq.push ( Message( s, 10 ) );		//put Message object in priority queue

  //now prints out messages with those urgent ones printed first
  while ( !pq.empty() ){
    Message a = pq.top();
    cout << a.getMessage() << endl;
    pq.pop();		//remove front element
  }
  cout << endl;
}
