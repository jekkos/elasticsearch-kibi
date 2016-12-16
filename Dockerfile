# Linux OS
FROM ubuntu:16.04
# Maintainer
MAINTAINER Jeroen Peelaerts <jeroen.peelaerts@infrabel.be>

RUN groupadd -r kibi && useradd -r -m -g kibi kibi

# Setup Packages & Permissions
RUN apt-get update && apt-get clean \
 && apt-get install -y wget curl unzip \
 && wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /dumb-init \
 && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
 && apt-get install -y nodejs \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
RUN cd /opt && wget https://download.support.siren.solutions/kibi/community?file=kibi-community-standalone-4.5.4-linux-x64.zip -O kibi-4.5.4-linux-x64.zip \
 && unzip kibi-4.5.4-linux-x64.zip \
 && rm -rf /opt/kibi-4.5.4-linux-x64.zip \
 && mv kibi-community-standalone-4.5.4-linux-x64 kibi \
 && chown -R kibi:kibi /opt/kibi
 
ADD entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh
ENV PATH /opt/kibi/kibi/bin:$PATH

# Expose Default Port
EXPOSE 5601 5606
EXPOSE 8899

# Exec on start
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/opt/entrypoint.sh"]
