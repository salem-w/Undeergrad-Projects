multiply: main.o print.o product.o
	g++ -o multiply main.o print.o product.o

main.o: main.cpp
	g++ -c main.cpp

print.o: print.cpp
	g++ -c print.cpp

product.o: product.cpp
	g++ -c product.cpp

clean:
	rm multiply *.o
