/*
 * Appropriated From Tong Yu's Online Lecture, and videos
  readers_writers.cpp
  Compile:  g++ -o  readers_writers readers_writers.cpp -lSDL -lpthread
  Execute:  ./readers_writers
*/

#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <signal.h>

using namespace std;

SDL_bool condition = SDL_FALSE;
SDL_mutex *mutex;
SDL_cond *readerQueue;   //condition variable
SDL_cond *writerQueue;   //condition variable

int readers = 0;
int writers = 0;
int counter = 0;
FILE *fp = NULL;
bool quit = false;


int reader ( void *data )
{
	while(!quit){
		SDL_Delay (rand()%3000);
		SDL_LockMutex(mutex);

  SDL_LockMutex ( mutex );
  while ( !(writers == 0) )
    SDL_CondWait ( readerQueue, mutex );

  readers++;
 
  SDL_UnlockMutex ( mutex );
  //read
  int count;
  rewind(fp);
  fscanf(fp,"%d",&count);
  printf("\nThis %s thread: %d\n",(char *)data,count);

  SDL_LockMutex ( mutex );
  printf("\nThis is %s thread\n", (char *) data );
  if ( --readers == 0 )
    SDL_CondSignal ( writerQueue );
  SDL_UnlockMutex ( mutex );
	}
}

int writer ( void *data )
{
	while(!quit){
		SDL_Delay(rand()%3000);
		SDL_LockMutex(mutex);
  while ( !( (readers == 0) && (writers == 0) ) )
    SDL_CondWait ( writerQueue, mutex );

  writers++;
 
  SDL_UnlockMutex ( mutex );
  //write
  counter++;
  rewind(fp);
  fprintf(fp,"%d",counter);
  printf("\nThis is %s thread: %d\n",(char *)data,counter);
  writers--;
  SDL_CondSignal ( writerQueue );
  SDL_CondBroadcast ( readerQueue );
  SDL_UnlockMutex ( mutex );
	}
}

void func(int sig){
	quit = true;
}

int main ()
{
  SDL_Thread *idr[20], *idw[3];          	      //thread identifiers
  char *rnames[] = { "reader 1", "reader 2", "reader 3","reader 4","reader 5"
 ,"reader 6","reader 7","reader 8","reader 9","reader 10","reader 11"
 ,"reader 12","reader 13","reader 14","reader 15","reader 16","reader 17"
 ,"reader 18","reader 19","reader 20" }; //names of threads
  char *wnames[] = { "writer 1", "writer 2", "writer 3" }; //names of threads

  if((fp = fopen( "counter.txt","w+"))==NULL){
	  printf("\nError opening file!\n");
	  return 1;
  }
  const int N = 20;
  mutex = SDL_CreateMutex();
  readerQueue = SDL_CreateCond();
  writerQueue = SDL_CreateCond();
  for ( int i = 0; i < N; i++ ){
    idr[i] = SDL_CreateThread ( reader, rnames[i] );
    if(i >=3) continue;
    idw[i] = SDL_CreateThread ( writer, wnames[i] );
  }
  printf("\nwaiting..\n");
  (void)signal(SIGINT,func); //catch terminal interruptions
  //wait for the threads to exit
  for ( int i = 0; i < N; i++ ){
    SDL_WaitThread ( idr[i], NULL );
    if(i>=3) continue;
    SDL_WaitThread ( idw[i], NULL );
  }
  SDL_DestroyCond ( readerQueue );
  SDL_DestroyCond ( writerQueue );
  SDL_DestroyMutex ( mutex );
  fprintf(fp,"\nDone!\n");
  fclose(fp);
  return 0;
}
