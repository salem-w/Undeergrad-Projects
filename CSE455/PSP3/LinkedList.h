#ifndef LINKEDLIST_H
#define LINKEDLIST_H

struct node
	{
		float x_value;
		float y_value;
		node *next;

	};

class LinkedList
{

	
public:
	node *first;

	LinkedList();
	virtual int size();
	virtual void insert(float x_val,float y_val);
	virtual void del(int index);
	virtual float xValue(int index);
	virtual float yValue(int index);
	virtual void read();
	virtual int search(float val);

	
};

#endif