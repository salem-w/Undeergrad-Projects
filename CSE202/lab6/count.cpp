/******************************************************************************
 * Waleed Salem
 * count.cpp
 * 5/5/16
 * An implementation of the wc command, outputs the amount of lines, words, and
 * characters in the file, allows opening multiple files.
 * Sketch: Uses an input file stream to open files, and then a string stream 
 * to get one word at a time and incrementing the word counter.
 * 100% completed
 *****************************************************************************/
#include <fstream>
#include <iostream>
#include <string>
#include <sstream>

using namespace std;

main()
{
	ifstream in;
    string word, line;
    int chars = 0, words = 0, lines = 0;

	string file_name;

	cout << "Enter a file name:\n";
	cin >> file_name;
	in.open(file_name.c_str());

	while(!cin.eof()) {
		if(in.fail()) return 1;
	
    	getline(in, line);
    	while (!in.eof()) {

        	lines++;

        	chars += line.length() + 1; // + 1 for new-line

        	istringstream line_string(line);
        	while (line_string >> word)//one word at a time
        	    words++;

        	getline(in, line);
    	}
		cout << lines << ' ' << words << ' ' << chars << endl;
		cout << "Enter a file name:\n";
		cin >> file_name;
		in.close();
		in.open(file_name.c_str());
		chars = 0;//reset variables
		words = 0;
		lines = 0;

	}//end outer loop
	in.close();
}

