EXEC = hufexe
OBJ0 =  hufmain.o huftree.o fbitios.o util.o
HEADER = fbitios.h huftree.h atom.h util.h

$(EXEC): $(OBJ0)
	@echo "linking.." $(OBJ0)
	g++ -o $@ $(OBJ0)

$(OBJ0): $(HEADER)
	g++ -c $*.cpp

clean: 
	rm $(OBJ0)
