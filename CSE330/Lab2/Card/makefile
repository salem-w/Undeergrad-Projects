#Makefile for suit
EXEC=suit_test1
SRCS=card.cpp  suit_test.cpp 
OBJS=$(SRCS:.cpp=.o) 
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) 	
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c  $*.cpp  

clean:
	rm $(OBJS) 


