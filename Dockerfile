FROM centos:7
LABEL maintainer "Vladimir Goldetsky <goldetsky@gmail.com>"

ENV KIBANA_VERSION 5.5.2

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/kibana/bin:$PATH

RUN yum update -y && yum install -y fontconfig freetype && yum clean all

WORKDIR /usr/share/kibana
RUN curl -Ls https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    ln -s /usr/share/kibana /opt/kibana

ADD bin/kibana-docker /usr/local/bin/

RUN groupadd --gid 993 kibana && \
    useradd --uid 995 --gid 993 \
      --home-dir /usr/share/kibana --no-create-home \
      kibana
USER kibana

EXPOSE 5601

CMD /usr/local/bin/kibana-docker
