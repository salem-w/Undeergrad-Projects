#include <cstdio>
#include <cstdlib>
#include "reader.h"

reader::reader()
{
	this->file = "";
	this->is = NULL;
}

reader::reader(string filename)
{
	this->file = filename;
	ifstream newIs(filename.c_str());
	this->is = newIs;
}

int reader::loc()
{
	int c, lines;
	lines = 0;
	FILE *f = fopen(file, "r")
	if(f == NULL)
		return lines;
	while(!feof(f))
	{
		c = fgetc(f);
		if(c == '\n')
			lines++;
	}
	return lines;
}

