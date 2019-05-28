/******************************************************************************
 * Waleed Salem
 * File: palindrome.cpp
 * 05/18/16
 * Implements a recursive function is_palindrome that checks if user input is
 * a palindrome
 * Sketch: Using a function that changes Upper case to lower case, also 
 * skipping special characters, the program utilizes recursion to solve the 
 * problem.
 * 100% completed
 *****************************************************************************/

#include <iostream>
#include <string>
#include <vector>

using namespace std;

//returns true if in range  of ascii chars, false otherwise
bool is_letter(char c)
{
	if((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
		return true;

	return false;
}

//changes upper-case char to lower case char, if lower to begin with, returns
//unmodified char
char to_lower(char c)
{
	if(c >= 'A' && c <= 'Z')
		return c + 32;

	return c;
} 

//recursive function that checks if first and last character match like a
//palindrome, returns true if the string is a palindrome, false otherwise
bool is_palindrome(string s)
{
	string shorter;
	if(s.length() <= 1)
		return true;

	char first = (s[0]);
	if(!is_letter(first)) {
		shorter = s.substr(1);
		return is_palindrome(shorter);
	}

	char last = s[s.length() - 1];
	if(!is_letter(last)) {
		shorter = s.substr(0, s.length() - 2);
		return is_palindrome(shorter);
	}

	first = to_lower(first);
	last = to_lower(last);

	if(first == last) {
		shorter = s.substr(1, s.length() - 2);
		return is_palindrome(shorter);
	}
	return false;
}

main()
{
	cout << "Enter a string: ";
	string input;
	getline(cin, input);
	cout << "\'" << input << "\' is ";
	if(!is_palindrome(input))
		cout << "not ";
	cout << "a palindrome. \n";
}
