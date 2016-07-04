#CD into folder containing the output of the gerb274x-gerbm.cam file with EagleCAD
#docker run -it --rm -v $PWD/:/app/gerber schmorrison/gerbmerge_dockerfile

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
	
WORKDIR /app/gerber

ADD default-layout.cfg /app/gerber/default-layout.cfg
	
RUN pip install SimpleParse \
	&& wget http://www.gedasymbols.org/user/stefan_tauner/tools/gerbmerge/gerbmerge-1.7a.tar.gz \
	&& tar -xf gerbmerge-1.7a.tar.gz \
	&& cd gerbmerge/ \
	&& sed -i -r '/VERSION_MINOR="7a"/c\VERSION_MINOR=7' gerbmerge/gerbmerge.py \
	&& python setup.py install \
	&& sed -i -r '/"Prefix=%(projdir)s/proj1"/c\"Prefix=%(projdir)s/newname"' /app/gerber/default-layout.cfg
	


RUN ls /app \
	&& echo "nextline nextline" \
	&& ls /app/gerber 

#ENTRYPOINT ["/usr/bin/gerbmerge"]
#CMD ["--full-search", "/app/gerber/layout.cfg"]
#ENTRYPOINT ["cat"]
#CMD ["/app/gerber/layout.cfg"]