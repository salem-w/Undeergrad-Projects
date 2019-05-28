//util.h
#ifndef UTIL_H
#define UTIL_H
void q2stack( queue<TOKEN> &q, stack<TOKEN> &s );
void reverse_stack( stack<TOKEN> &s, stack<TOKEN> &sr );
bool c_is_an_operator( char c );
void print_queue( queue<TOKEN> q ); 
void print_stack( stack<TOKEN> s ); 

#endif
