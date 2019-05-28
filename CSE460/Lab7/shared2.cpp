/*
shared2.cpp: Similar to shared1.cpp except that it writes data to
the shared memory.
*/
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <semaphore.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define TEXT_SZ 2048

struct shared_use_st {
int written_by_you;
char some_text[TEXT_SZ];
};

int main() {
	char SEM_NAME[] = "foo";
	sem_t * mutex;
	mutex = sem_open(SEM_NAME, 0, 0644, 0);

	if(mutex == SEM_FAILED) {
		perror("Reader: Can't access semaphore");
		sem_close(mutex);
		exit(-1);
	}

	int running = 1;
	void *shared_memory = (void *)0; 
	struct shared_use_st *shared_stuff;
	char buffer[BUFSIZ];
	int shmid;
	shmid = shmget((key_t)1234, sizeof(struct shared_use_st), 0666 | IPC_CREAT);

	if (shmid == -1) {
		fprintf(stderr, "shmget failed\n");
		exit(EXIT_FAILURE);
	}

	shared_memory = shmat(shmid, (void *)0, 0);
		if (shared_memory == (void *)-1) {
		fprintf(stderr, "shmat failed\n");
		exit(EXIT_FAILURE);
		}

	printf("Memory attached at %X\n", (long)shared_memory);
	shared_stuff = (struct shared_use_st *)shared_memory;

	while(running) {
		while(shared_stuff->written_by_you == 1) {
			sleep(1);
			printf("waiting for client...\n");
		}
		sem_wait(mutex);
		printf("Enter some text: ");
		fgets(buffer, BUFSIZ, stdin);
		strncpy(shared_stuff->some_text, buffer, TEXT_SZ);
		shared_stuff->written_by_you = 1;
		sem_post(mutex);
		
		if (strncmp(buffer, "end", 3) == 0) {
			running = 0;
		}
	}

	if (shmdt(shared_memory) == -1) {
		fprintf(stderr, "shmdt failed\n");
		exit(EXIT_FAILURE);
	}

	sem_close(mutex);
	sem_unlink(SEM_NAME);
	exit(EXIT_SUCCESS);
} 
