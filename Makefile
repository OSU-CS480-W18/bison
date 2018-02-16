all: parser parser-push

parser.cpp parser.hpp: parser.y
	bison -d -o parser.cpp parser.y

scanner.cpp: scanner.l
	flex -o scanner.cpp scanner.l

parser: main.cpp parser.cpp scanner.cpp
	g++ main.cpp parser.cpp scanner.cpp -o parser

parser-push.cpp parser-push.hpp: parser-push.y
	bison -d -o parser-push.cpp parser-push.y

scanner-push.cpp: scanner-push.l
	flex -o scanner-push.cpp scanner-push.l

parser-push: main-push.cpp parser-push.cpp scanner-push.cpp
	g++ main-push.cpp parser-push.cpp scanner-push.cpp -o parser-push

clean:
	rm -f parser scanner.cpp parser.cpp parser.hpp
