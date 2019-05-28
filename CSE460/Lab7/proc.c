//current process status
int cps() {

	struct proc *p;
	// Enable interrupts on this processor.
	sti();
	int processCounter = 0;
	// Loop over process table looking for process with pid.
	acquire(&ptable.lock);
	cprintf("name \t pid \t state \n");
	
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if ( p->state == SLEEPING ){
			cprintf("%s \t %d \t SLEEPING \n ", p->name, p->pid );
			processCounter++;
		}else if ( p->state == RUNNING ){
			cprintf("%s \t %d \t RUNNING \n ", p->name, p->pid );
			processCounter++;
		}
	}
	
	release(&ptable.lock);
	cprintf("There are %d sleeping or running processes", processCounter);
	return 22;
} 