//text_processing.h
#ifndef TEXT_PROCESSING_H
#define TEXT_PROCESSING_H

#include <string>
#include <fstream>

using namespace std;
int process_text( fstream &ifs, fstream &ofs, char target[], char replacement[] );

#endif

