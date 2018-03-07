FROM centos:7
LABEL maintainer "Serg Rolskyi <sergii.rolskyi@linux-tricks.net>"

ENV KIBANA_VERSION 6.2.0

ENV ELASTIC_CONTAINER true

ENV PATH=/usr/share/kibana/bin:$PATH

RUN yum update -y && yum install -y fontconfig freetype

WORKDIR /usr/share/kibana
RUN curl -Ls https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    ln -s /usr/share/kibana /opt/kibana

ADD bin/kibana-docker /usr/local/bin/

RUN groupadd --gid 1000 kibana && \
    useradd --uid 1000 --gid 1000 \
      --home-dir /usr/share/kibana --no-create-home \
      kibana

RUN cd /usr/share/kibana && kibana-plugin install x-pack

USER kibana

EXPOSE 5601

CMD /usr/local/bin/kibana-docker
