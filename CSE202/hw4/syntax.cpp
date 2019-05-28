/******************************************************************************
 * Waleed Salem
 * File: syntax.cpp
 * Date: 6/5/16
 * Checks if each opening parenthesis/bracket/brace has a matching pair, then
 * tells the user whether the file is balanced.
 * Sketch: The program uses an ifstream to read the file, the program then uses
 * a stack of type char to check if each opening parenthesis/bracket/brace has
 * a closing pair. This is done through use of the push() and pop() functions.
 * 100% Completed
 *****************************************************************************/

#include <iostream>
#include <stack>
#include <string>
#include <fstream>

using namespace std;

//helper function that checks if the params are pairs
bool pair(char first, char last)
{
	if(first == '(' && last == ')')
		return true;
	if(first == '[' && last == ']')
		return true;
	if(first == '{' && last == '}')
		return true;

	return false;
}
//uses a stack to push opening parenthesis to the top of stack, and pops if a
//a pair is complete. Returns true if the file is balanced, false otherwise.
bool is_balanced(string s)
{
	stack<char> c;

	for(int i = 0; i < s.length(); i++)
	{
		if(s[i] == '(' || s[i] == '[' || s[i] == '{')
			c.push(s[i]);//push opening parenthesis to stack

		if(s[i] == ')' || s[i] == ']' || s[i] == '}') {
			//if the stack is empty or no pair exists return false
			if(!pair(c.top(), s[i]) || c.empty())
				return false;
			else
				c.pop();//found a pair
		}
	}

	return c.empty();
}

main()
{
	string input;
	string syntax;
	fstream in;
	cout << "Enter a file name.\n";
	cin >> input;

	in.open(input.c_str());

	if(!in.is_open()) {
		cout << "Could not open file\n";
		return 1;
	}

	
	while( getline(in, input) ) {
		syntax.append(input);
	}

	if(!is_balanced(syntax))
		cout << "Not ";

	cout << "Balanced\n";

}