#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <semaphore.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <iostream>

#define SHMSZ 27
#define TEXT_SZ 2048
char SEM_NAME[] = "SEM";
struct shared_use_st {
int written_by_you;
char some_text[TEXT_SZ];
};
int main() {
int running = 1;
void *shared_memory = (void *)0;
struct shared_use_st *shared_stuff;
char buffer[BUFSIZ];
int shmid;
key_t key;
char *shm,*s;
sem_t *mutex;
key = 1000;
//creates and initializes semaphore
mutex = sem_open(SEM_NAME, O_CREAT, 0644, 1);
if (mutex == SEM_FAILED) {
perror("Unable to create semaphore");
sem_unlink(SEM_NAME);
exit(-1);
}
shm = (char*) shmat(shmid, NULL, 0);
//attach to shared mem
shmid = shmget(key, SHMSZ, IPC_CREAT | 0666);
if(shmid < 0) {
perror("Failure in shmget");
exit(-1);
}
shmid = shmget((key_t)1234, sizeof(struct shared_use_st), 0666 |
IPC_CREAT);if (shmid == -1) {
fprintf(stderr, "shmget failed\n");
exit(EXIT_FAILURE);
}
shared_memory = shmat(shmid, (void *)0, 0);
if (shared_memory == (void *)-1) {
fprintf(stderr, "Failure\n");
exit(EXIT_FAILURE);
}
shared_stuff = (struct shared_use_st *)shared_memory;
while(running) {
while(shared_stuff->written_by_you == 1) {
sleep(1);
}
sem_wait(mutex);
printf("Enter some text: ");
fgets(buffer, BUFSIZ, stdin);
strncpy(shared_stuff->some_text, buffer, TEXT_SZ);
shared_stuff->written_by_you = 1;
sem_post(mutex);
if (strncmp(buffer, "quit", 3) == 0) {
running = 0;
}
}
if (shmdt(shared_memory) == -1) {
fprintf(stderr, "shmdt failed\n");
exit(EXIT_FAILURE);
}
sem_close(mutex);
sem_unlink(SEM_NAME);
shmctl(shmid, IPC_RMID, 0);
exit(0);
}
