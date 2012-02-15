VER =           perl-5.12.3
TARBALL=$(VER).tar.gz

all: $(VER)/perldtrace.h
	(cd $(VER); gmake )

test: all
	(cd $(VER); gmake test)


install: all
	(cd $(VER);\
	    rm -f ${ROOT}/usr/perl5/5.12/lib/i86pc-solaris-64int/.packlist;\
	    DESTDIR=${ROOT} \
	    gmake install)

$(VER):
	gtar -zxf $(TARBALL)

$(VER)/cflags: $(VER)
	(cd $(VER) && \
	cp -f ../config.sh ./config.sh && \
	./Configure -S )

$(VER)/perldtrace.h: $(VER)/cflags
	(cd $(VER) && \
	/usr/sbin/dtrace -h -s perldtrace.d -o perldtrace.h)


clean:
	rm -rf $(VER)

