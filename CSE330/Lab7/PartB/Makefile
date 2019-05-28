EXEC=course_registration
SRCS=course.cpp student.cpp util.cpp main.cpp 
OBJS=$(SRCS:.cpp=.o) 
$(EXEC): $(OBJS)
	g++ -o $@ $(OBJS) 	
#$< evaluates to the target's dependencies, 
#$@ evaluates to the target

$(OBJS): 
	g++ -c  $*.cpp  

clean:
	rm $(OBJS) 

