#include <iostream>
#include <cstdlib>
#include "LinkedList.h"

//basic constructor for linkedlist
LinkedList::LinkedList() {
	this->first = NULL;
}

//computes the size of the linked list
int LinkedList::size() {
	node * new_node = new_node;
	if(this->first == NULL)
		return 0;

	int num = 1;
	new_node = this->first;
	while(new_node->next != NULL) {
		new_node = new_node->next;
		num++;
	}
	return num;
}

//inserts a value at the end of the list
void LinkedList::insert(float x_val, float y_val) {
	
	if(this->first==NULL) {
		node* a_node = new node();
		a_node->x_value = x_val;
		a_node->y_value = y_val;
		this->first	= a_node;
		return;
	}
	node* n = new node();
	n = this->first;
	node* new_node = new node();
	new_node->x_value = x_val;
	new_node->y_value = y_val;
	while(n->next != NULL) {
		n = n->next;
	}
	new_node->next = n->next;
	n->next = new_node;

}

//deletes a value at a specified index
void LinkedList::del(int index) {
	node* n = this->first;
	node* prev = new node();
	prev = n;//in case if it is the first value

	for(int j = 0; j < index; j++) {
		prev = n;
		n = n->next;
	}
	prev->next = n->next;
}

//returns the x-value at a specified index
float LinkedList::xValue(int index) {
	node* n = this->first;
	for(int num = 0; num < index; num++) {
		n = n->next;
	}
	return n->x_value;
}

//returns the y-value at a specified index
float LinkedList::yValue(int index) {
	node* n = this->first;
	for(int num = 0; num < index; num++) {
		n = n->next;
	}
	return n->y_value;
}

//reads the entire linked list
void LinkedList::read() {
	node* n = this->first;
	int i = 1;
	while(n != NULL) {
		std::cout << i << ". (" << n->x_value << ", " << n->y_value << ")" 
		<< std::endl;
		n = n->next;
		i++;
	}
}

//searches the linked list for a value, returns the index
int LinkedList::search(float val) {
	int i = 0;
	node* n = this->first;
	while(n != NULL) {
		if(n->x_value == val or n->y_value == val)
			return i;
		else {
			n = n->next;
			i++;	
		}
	}
	return -1;
}
