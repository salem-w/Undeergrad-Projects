//util.cpp

#include "util.h"

void usage ( char program_name[] )
{
  cout << "Usage: " << program_name << " infile outfile search_string replacement_string" <<  endl;
   cout << "The program searches for patterns in strings. It reads strings " <<
		   "from an input file, one line at a time and highlights the " <<
		   "patterns found on the screen. To advance to the next line, you " << 
           "have to hit Enter. It also replaces the pattern with a string and " <<
           "sends the result to an output file" << endl;
  return;
}

/*
  The following are some curses functions. You can find
  the details by the command "man ncurses". But its use
  can be transparent to you.

*/
void clear_screen()
{
 initscr();
 scrollok ( stdscr,  true );	//allow window to scroll
}

void print_text ( const char *s )
{
  printw("%s", s );
  refresh();
}

void print_text_inverse( const char *s )
{
  attron( A_REVERSE );
  printw("%s", s );
  attroff( A_REVERSE );
  refresh();  
}

void get_input_text( char *s, int max_len )
{
  getnstr( s, max_len );
}

void restore_screen()
{
  endwin();
}

