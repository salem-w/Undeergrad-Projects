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
#define SIZE 1024
using namespace std;char SEM_NAME[]= "SEM";
char modif_buffer[SIZE];
int main() {
int running = 1;
char ch;
int shmid;
key_t key;
char *shm,*s;
sem_t *mutex;
key = 1000;
//names the shared memory segment
//creates and initializes semaphore
mutex = sem_open(SEM_NAME, 0, 0644, 0);
if(mutex == SEM_FAILED) {
perror("Unable to execute semaphore");
sem_close(mutex);
exit(-1);
}
//creates the shared memory segment with this key
shmid = shmget(key, SHMSZ, 0666);
if(shmid < 0) {
perror("Failure in shmget");
exit(-1);
}
shm = (char*) shmat(shmid, NULL, 0);
//attach to virtual mem
int size;
while (running) {
sem_wait(mutex);
for (s = shm; *s != 0; s++) {
modif_buffer[size++] = *s;
printf("%s\n", modif_buffer);
if (modif_buffer == "quit") {
running = 0;
break;
}
}
sem_post(mutex);
}
*shm = '*';
sem_close(mutex);
shmctl(shmid, IPC_RMID, 0);
exit(0);
}
