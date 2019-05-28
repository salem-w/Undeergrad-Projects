#Makefile for find_pat
SRCS=str_main.cpp text_processing.cpp util.cpp
OBJS=$(SRCS:.cpp=.o) 
EXEC=find_pat
INCLS=-I/usr/include/ncurses
LIBS=-lncurses
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) $(LIBS)	
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c  $*.cpp $(INCLS) 

clean:
	rm $(OBJS) 

