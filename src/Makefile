CC= gcc

CFLAGS=	-g -I$(IDIR)

ODIR = obj
LDIR = ../lib
IDIR = ../include

LIBS= -lm

_DEPS =	tradutor.h montador_ia32.h

DEPS =	$(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = tradutor.o montador_ia32.o main.o

OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.c $(DEPS)

	$(CC) -c -o $@ $< $(CFLAGS)

prog: $(OBJ)

	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

.PHONY:
	clean

clean:
	rm -f $(ODIR)/*.o *~ core $(IDIR)/*~
