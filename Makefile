OBJS   := syntaxes/asmatt.l.o main.c.o
TARGET := genhl 

CFLAGS := -Wall -O2

all: ${TARGET}

${TARGET}: ${OBJS}
	${CC} ${CFLAGS} -o $@ $^

%.c.o: %.c
	${CC} ${CFLAGS} -c -o $@ $^

%.l.o: %.l
	lex -t $^ | ${CC} ${CFLAGS} -c -x c -o $@ -

clean:
	rm -rf ${TARGET} ${OBJS}

install:
	install ${TARGET} /usr/local/bin/${TARGET} 