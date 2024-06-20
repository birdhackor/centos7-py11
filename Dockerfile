FROM centos:7

RUN yum -y groupinstall "Development Tools" && \
    yum -y install xcb-util-renderutil libxcb libxcb-devel libXrender libXrender-devel xcb-util-wm xcb-util-wm-devel xcb-util xcb-util-devel xcb-util-image xcb-util-image-devel xcb-util-keysyms xcb-util-keysyms-devel

ADD https://www.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz /tmp

RUN tar -xzvf /tmp/openssl-1.1.1w.tar.gz -C /tmp

WORKDIR /tmp/openssl-1.1.1w

RUN ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl && \
    make -j $(nproc) && make install && make clean && \
    echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1w.conf && ldconfig

RUN ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl

RUN yum install -y gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel tk-devel libffi-devel xz-devel

ADD https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz /tmp

RUN tar -xzvf /tmp/Python-3.11.9.tgz -C /tmp

WORKDIR /tmp/Python-3.11.9

RUN ./configure --prefix=/usr/local/python3.11 --with-openssl=/usr/local/ssl --enable-optimizations --with-zlib --enable-shared && \
    make install && make clean

RUN ln -s /usr/local/python3.11/bin/python3 /usr/bin/python3

RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python3.11/lib/

WORKDIR /root
