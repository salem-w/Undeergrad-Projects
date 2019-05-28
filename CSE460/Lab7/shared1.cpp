//shared1.cpp
/* After the headers the shared memory segment
(the size of our shared memory structure) is created with a call to shmget,
with the IPC_CREAT bit specified. It reads data from the shared memory. */
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
	mutex = sem_open(SEM_NAME, O_CREAT, 0644, 1);

	if (mutex == SEM_FAILED) {
		perror("Cannot create semaphore");
		sem_unlink(SEM_NAME);;
		exit(-1);
	}

	int running = 1;
	void *shared_memory = (void *)0;
	struct shared_use_st *shared_stuff;
	int shmid;
	srand((unsigned int)getpid());
	shmid = shmget((key_t)1234, sizeof(struct shared_use_st), 0666 | IPC_CREAT);
	
	if (shmid == -1) {
		fprintf(stderr, "shmget failed\n");
		exit(EXIT_FAILURE);
	}

	/* We now make the shared memory accessible to the program. */
	shared_memory = shmat(shmid, (void *)0, 0);
	if (shared_memory == (void *)-1) {
		fprintf(stderr, "shmat failed\n");
		exit(EXIT_FAILURE);
	}

	printf("Memory attached at %X\n", (long)shared_memory);
	/* The next portion of the program assigns the shared_memory segment to shared_stuff,
	which then prints out any text in written_by_you. The loop continues until end is foun
	d
	in written_by_you. The call to sleep forces the consumer to sit in its critical sectio
	n,
	which makes the producer wait. */
	shared_stuff = (struct shared_use_st *)shared_memory;
	shared_stuff->written_by_you = 0;

	while(running) {
		if (shared_stuff->written_by_you) {
			sem_wait(mutex);
			printf("You wrote: %s", shared_stuff->some_text);
			sleep( rand() % 4 ); /* make the other process wait for us ! */ 
			shared_stuff->written_by_you = 0;
			sem_post(mutex);
			if (strncmp(shared_stuff->some_text, "end", 3) == 0) {
				running = 0;
			}
		}
	}

	/* Lastly, the shared memory is detached and then deleted. */
	if (shmdt(shared_memory) == -1) {
		fprintf(stderr, "shmdt failed\n");
		exit(EXIT_FAILURE);
	}

	if (shmctl(shmid, IPC_RMID, 0) == -1) {
		fprintf(stderr, "shmctl(IPC_RMID) failed\n");
		exit(EXIT_FAILURE);
	}
	
	sem_close(mutex);
	sem_unlink(SEM_NAME);
	exit(EXIT_SUCCESS);
} 
