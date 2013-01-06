
MAJOR_VERSION = 0
EXTRA_VERSION = .0.0
SONAME = liblinenoise.so.$(MAJOR_VERSION)
LIB = $(SONAME)$(EXTRA_VERSION)

export CFLAGS ?= -Os -g
CFLAGS += -Wall -fpic -DUSE_UTF8
LIBDIR ?= /usr/lib
INCLUDEDIR ?= /usr/include

.PHONY: all
all: $(LIB) linenoise_example linenoise_utf8_example linenoise_cpp_example

$(LIB): linenoise.o utf8.o
	$(CC) $(CFLAGS) -shared -Wl,-soname,$(SONAME) $(LDFLAGS) -o $@ $^

linenoise_example: linenoise.h linenoise.c example.c
	$(CC) -Wall -W -Os -g -o $@ linenoise.c example.c

linenoise_utf8_example: linenoise.c utf8.c example.c
	$(CC) -DNO_COMPLETION -DUSE_UTF8 -Wall -W -Os -g -o $@ linenoise.c utf8.c example.c

linenoise_cpp_example: linenoise.h linenoise.c
	g++ -Wall -W -Os -g -o $@ linenoise.c example.c

.PHONY: clean
clean:
	rm -f $(LIB) linenoise_example linenoise_utf8_example linenoise_cpp_example *.o

.PHONY: install
install: $(LIB)
	install -m 0755 -d $(DESTDIR)$(INCLUDEDIR)
	install -m 0644 linenoise.h $(DESTDIR)$(INCLUDEDIR)
	install -m 0755 -d $(DESTDIR)$(LIBDIR)
	install -m 0755 $(LIB) $(DESTDIR)$(LIBDIR)
	ldconfig -n $(DESTDIR)$(LIBDIR)
	ln -s $(LIB) $(DESTDIR)$(LIBDIR)/liblinenoise.so
