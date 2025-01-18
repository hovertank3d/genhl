OBJS   := syntaxes/asmatt.l.o syntaxes/cc.l.o main.c.o
TARGET := genhl 

CFLAGS := -Wall -O2

all: ${TARGET}

${TARGET}: ${OBJS}
	${CC} ${CFLAGS} -o $@ $^

%.c.o: %.c
	${CC} ${CFLAGS} -c -o $@ $^

%.l.o: %.l
	lex -P "$(shell basename $@ .l.o)" -t $^ | ${CC} ${CFLAGS} -c -x c -o $@ -

clean:
	rm -rf ${TARGET} ${OBJS}

install:
	install ${TARGET} /usr/local/bin/${TARGET} 