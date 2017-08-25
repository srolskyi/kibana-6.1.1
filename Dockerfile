FROM centos:7
LABEL maintainer "Serg Rolskyi <sergii.rolskyi@linux-tricks.net>"

ENV KIBANA_VERSION 5.5.2

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/kibana/bin:$PATH

RUN yum update -y && yum install -y fontconfig freetype && yum clean all

WORKDIR /usr/share/kibana
RUN curl -Ls https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf - && \
    ln -s /usr/share/kibana /opt/kibana

ADD bin/kibana-docker /usr/local/bin/

RUN groupadd --gid 1000 kibana && \
    useradd --uid 1000 --gid 1000 \
      --home-dir /usr/share/kibana --no-create-home \
      kibana

# SENTINL
ENV SENTINL_SMPT localhost
ENV EMAIL_ACTIVE false
ENV EMAIL_SSL false
ENV REPORT_ACTIVE false
ENV REPORT_PATH /var/tmp/

RUN echo 'sentinl:\n\
  settings:\n\
    email:\n\
      active: ${EMAIL_ACTIVE}\n\
      host: ${SENTINL_SMPT}\n\
      ssl: ${EMAIL_SSL}\n\
    report:\n\
      active: ${REPORT_ACTIVE}\n\
      tmp_path: ${REPORT_PATH}\n'\
    >> /opt/kibana/kibana.yml 

USER kibana

EXPOSE 5601

CMD /usr/local/bin/kibana-docker
