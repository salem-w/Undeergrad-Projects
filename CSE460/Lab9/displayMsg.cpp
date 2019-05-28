#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define MAX_TEXT 512

struct my_msg_st {
	long int my_msg_type;
	char some_text[BUFSIZ];
};

int main() {
	int running = 1;
	int msgid;
	int page, frame, faults;
	struct my_msg_st some_data;
	long int msg_to_receive = 0;

	msgid = msgget( (key_t)1234, 066 | IPC_CREAT);
	if(msgid == -1) {
		fprintf(stderr, "msgget failed with error: %d\n", errno);
		exit(EXIT_FAILURE);
	}
	printf("Page\tFrame\tTotal Faults\n");

	while(running) {
		if(msgrcv(msgid, (void *) &some_data, BUFSIZ, msg_to_receive, 0) == -1) {
			fprintf(stderr, "msgrcv failed with error: %d\n", errno);
			exit(EXIT_FAILURE);
		}

		sscanf(some_data.some_text, "%d, %d, %d", &page, &frame, &faults);
		printf("%4d\t%5d\t%10d\n", page, frame, faults);
		if(strncmp(some_data.some_text, "end", 3) == 0) {
			running = 0;
		}

		if(msgctl(msgid, IPC_RMID, 0) == -1) {
			fprintf(stderr, "msgctl(IPC_RMID) failed\n");
			exit(EXIT_FAILURE);
		}
	}
	exit(EXIT_SUCCESS);
}