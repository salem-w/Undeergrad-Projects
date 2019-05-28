#Makefile 
#make MAIN=xxxx

EXEC=calc
MAIN=main
SRCS=in2postd.cpp evaluate.cpp util.cpp  $(MAIN).cpp 
OBJS=$(SRCS:.cpp=.o) 
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) 	
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c  $*.cpp  

clean:
	rm $(OBJS) 

