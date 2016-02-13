GRAPHC=src/impl/
STRUCT=lib/util/Data_Structures/
INSTALL=/usr/local/

CC=clang
CFLAGS=-g -Wall -std=gnu11
OFLAGS=-c -fPIC

GRAPHICS_SRC=$(wildcard src/impl/graphics_*.c)
GRAPHICS_OBJ=$(addprefix ,$(notdir $(GRAPHICS_SRC:.c=.o)))
GRAPHICS_INC=-Isrc/headers/ -Ilib/util/Data_Structures/

XFLAGS=`pkg-config --libs x11`

all: graphics main

#Build Test code
main: test/test.c
	$(CC) $(CFLAGS) test/test.c -o main -lgraphics

#Data Structure(s) Build
link: $(STRUCT)link.c $(STRUCT)link.h
	$(CC) $(CFLAGS) $(OFLAGS) $(STRUCT)link.c -o link.o

queue: $(STRUCT)queue.c $(STRUCT)queue.h
	$(CC) $(CFLAGS) $(OFLAGS) $(STRUCT)queue.c -o queue.o

sort: $(STRUCT)sorted_list.c $(STRUCT)sorted_list.h
	$(CC) $(CFLAGS) $(OFLAGS) $(STRUCT)sorted_list.c -o sorted_list.o

#Graphics Build
graphics: link sort queue $(GRAPHICS_OBJ) $(GRAPHC)graphics.c
	$(CC) $(CFLAGS) $(OFLAGS) $(GRAPHICS_INC) $(GRAPHC)graphics.c -o graphics.o
	$(CC) -shared -o libgraphics.so $(GRAPHICS_OBJ) link.o sorted_list.o queue.o graphics.o -lpthread -lXpm $(XFLAGS)

$(GRAPHICS_OBJ): $(GRAPHICS_SRC)
	$(CC) $(CFLAGS) $(OFLAGS) $(GRAPHICS_INC) src/impl/$(subst .o,.c,$@) -o $@

# Target to copy the files to the right install locations
install: graphics
	cp libgraphics.so $(INSTALL)/lib
	mkdir -p $(INSTALL)/include/Graphics
	cp src/headers/*.h $(INSTALL)/include/Graphics/
	cp lib/util/Data_Structures/*.h $(INSTALL)include/Graphics

clean:
	rm *.o
	rm *.so
