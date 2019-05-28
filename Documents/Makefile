EXEC=strs_demo
SRCS=str.cpp strs.cpp strs_demo.cpp 
OBJS=$(SRCS:.cpp=.o) 
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) 	
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c  $*.cpp  

clean:
	rm $(OBJS) 

