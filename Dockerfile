#CD into project folder and move gerber files and layout.cfg into folder called gerber
#docker run -it --rm -v $PWD/gerber/:/app/gerber schmorrison/gerbmerge_dockerfile

FROM alpine:3.3

MAINTAINER schmorrison<schmorrison@gmail.com>

RUN apk add --update \
	openssh-client \
	gcc \
	musl-dev \
	git \
	py-pip \
	python \
	python-dev \
	tar \
	wget
	
RUN pip install SimpleParse \
	&& wget http://www.gedasymbols.org/user/stefan_tauner/tools/gerbmerge/gerbmerge-1.7a.tar.gz \
	&& tar -xf gerbmerge-1.7a.tar.gz \
	&& cd gerbmerge/ \
	&& sed -i -r '/VERSION_MINOR="7a"/c\VERSION_MINOR=7' gerbmerge/gerbmerge.py \
	&& python setup.py install

ADD layout.cfg /app/gerber/layout.cfg

RUN ls /app \
	&& ls /app/gerber 

ENTRYPOINT ["/usr/bin/gerbmerge"]
CMD ["/app/gerber/layout.cfg"]