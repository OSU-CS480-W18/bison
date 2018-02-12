all: scanner

scanner.cpp: scanner.l
	flex -o scanner.cpp scanner.l

scanner: scanner.cpp
	g++ scanner.cpp -o scanner

clean:
	rm -f scanner scanner.cpp
