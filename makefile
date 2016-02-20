GRAPHC=src/impl/
INSTALL=/usr/local/

CC=clang
CFLAGS=-g -Wall -std=gnu11
OFLAGS=-c -fPIC

LIBS=-lpthread -lXpm -ldata

GRAPHICS_SRC=$(wildcard src/impl/graphics_*.c)
GRAPHICS_OBJ=$(addprefix ,$(notdir $(GRAPHICS_SRC:.c=.o)))

XFLAGS=`pkg-config --libs x11`

all: graphics

#Build Test code
main: test/test.c
	$(CC) $(CFLAGS) test/test.c -o main -lgraphics

#Graphics Build
graphics: $(GRAPHICS_OBJ) $(GRAPHC)graphics.c
	$(CC) $(CFLAGS) $(OFLAGS) -Isrc/headers/ $(GRAPHC)graphics.c -o graphics.o
	$(CC) -shared -o libgraphics.so $(GRAPHICS_OBJ) graphics.o $(LIBS) $(XFLAGS)

$(GRAPHICS_OBJ): $(GRAPHICS_SRC)
	$(CC) $(CFLAGS) $(OFLAGS) -Isrc/headers/ src/impl/$(subst .o,.c,$@) -o $@

# Target to copy the files to the right install locations
install: graphics
	cp libgraphics.so $(INSTALL)lib
	mkdir -p $(INSTALL)include/Graphics
	cp src/headers/*.h $(INSTALL)include/Graphics/

clean:
	rm *.o
	rm *.so
