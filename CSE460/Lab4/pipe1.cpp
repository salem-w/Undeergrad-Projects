//pipe1.cpp
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <iostream>

using namespace std;

int main(int argc, char *argv[])
{
  FILE *fpi;				//for reading a pipe
 
  if(argc != 3) {
    cout << "Usage: " << argv[0] << "command argument\n";
  }

  char command[15];
  strcpy(command, argv[1]);
  strcat(command, " ");
  strcat(command, argv[2]);
  cout << "Comman: " << command << endl;

  char buffer[BUFSIZ+1];		//BUFSIZ defined in <stdio.h>
  
  int chars_read;
  memset ( buffer, 0,sizeof(buffer));	//clear buffer
  fpi = popen ( command, "r" );	//pipe to command "ps -auxw"
  if ( fpi != NULL ) {
    //read data from pipe into buffer
    chars_read = fread(buffer, sizeof(char), BUFSIZ, fpi );  
    if ( chars_read > 0 ) 
     cout << "Output from pipe: " << buffer << endl;
    pclose ( fpi ); 			//close the pipe
    return 0; 
  }

  return 1;

}