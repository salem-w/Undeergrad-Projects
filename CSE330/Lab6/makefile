EXEC=mergesort
SRCS=mergemain.cpp mergesort.cpp  Card.cpp
OBJS=$(SRCS:.cpp=.o) 
LIBOBJS=mergsort.o 

$(EXEC): $(OBJS) 
	g++ -o $@ $(OBJS) 	

$(OBJS): 
	g++ -c  $*.cpp $(INCLS) 

clean:
	rm $(OBJS) 


