EXEC = 1 2 3

all:
	nimble build

%: src/d%.nim
	nimble build $*

clean:
	rm -rf $(EXEC)
