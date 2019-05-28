//util.h
#ifndef	UTIL_H
#define	UTIL_H


#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>
#include <curses.h>

using namespace std;

void usage ( char program_name[] );
void clear_screen();
void print_text( const char *s );
void print_text_inverse( const char *s );
void get_input_text( char *s, int max_len );
void restore_screen();
#endif
