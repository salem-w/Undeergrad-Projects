#ifndef STACK_H
#define STACK_H

#include <vector>

using namespace std;

template <typename T>
class Stack
{
    vector<T> container;
public:
    Stack(): container() {}
    void push(T x) { container.push_back(x); }
    void pop()
	{
		if(!container.empty())
			container.pop_back();
	}
    T top()
	{
		if(!container.empty())
 			return container.back();
	}
    bool empty() { return container.empty(); }
};

#endif
