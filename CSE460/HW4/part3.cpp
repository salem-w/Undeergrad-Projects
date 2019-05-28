#include <iostream>
#include <fstream>
#include <sstream>
#include <SDL/SDL.h>
#include <SDL/SDL_thread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

using namespace std;

SDL_mutex *mutex;
SDL_cond *reader_queue;
SDL_cond *writer_queue;
int readers = 0;
int writers = 0;
int reader(void* data) {
	while(true) { 
		SDL_Delay(rand() % 1000);
		SDL_LockMutex(mutex);

		while(writers != 0)
			SDL_CondWait(reader_queue, mutex);

		++readers;
		SDL_UnlockMutex(mutex);
		ifstream file("counter.txt");

		if(file.good()) {
			int counter;
			file >> counter;
			cout << *((string*) data) << " with counter value " << counter << endl;
			file.close();
		} else
			cout << *((string*)data) << " unable to read counter" << endl;

		SDL_LockMutex(mutex);

		if(--readers == 0)
			SDL_CondSignal(writer_queue);

		SDL_UnlockMutex(mutex);
	}			
}

int writer(void* data) {

	while(true) { 
		SDL_Delay(rand() % 1000);
		SDL_LockMutex(mutex);

		while(writers != 0 and readers != 0)
			SDL_CondWait(writer_queue, mutex);

		++writers;
		SDL_UnlockMutex(mutex);
		int counter = -1;
		ifstream file("counter.txt");

		if(file.good()) {
			file >> counter;
			file.close();
		}

		++counter;
		ofstream file_write("counter.txt", std::ofstream::trunc);
		file_write << counter;
		file_write.close();

		cout << *((string*)data) << "with counter value " << counter << endl;
		SDL_LockMutex(mutex);
		--writers;
		SDL_CondSignal(writer_queue);
		SDL_CondSignal(reader_queue);
		SDL_UnlockMutex(mutex);
		}
}

int main() {
	SDL_Thread* reader_thread[20];
	SDL_Thread* writer_thread[3];

	mutex = SDL_CreateMutex();
	reader_queue = SDL_CreateCond();
	writer_queue = SDL_CreateCond();

	for(int i = 0; i < 3; i++) {
		stringstream ss;
		ss << "writer " << i;
		string* name = new string(ss.str());
		writer_thread[i] = SDL_CreateThread(writer, (void*) name);
	}

	for(int i = 0; i < 20; i++) {
		stringstream ss;
		ss << "reader " << i;
		string* name = new string(ss.str());
		reader_thread[i] = SDL_CreateThread(reader, (void*)name);
	}

	SDL_DestroyCond(reader_queue);
	SDL_DestroyCond(writer_queue);
	SDL_DestroyMutex(mutex);
	return 0;
}
