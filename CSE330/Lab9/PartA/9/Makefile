#Makefile 
#make MAIN=xxxx

EXEC=tree_test
MAIN=main0
SRCS=bst.cpp util.cpp  $(MAIN).cpp 
OBJS=$(SRCS:.cpp=.o) 
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) 	
	rm util.o
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c -D$(MAIN)  $*.cpp  
clean:
	rm bst.o $(MAIN).o 


