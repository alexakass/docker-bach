FROM php:8-cli

# Meta data
LABEL decription="Ssecurelabs bach image is to be used to verify that your php project does not contain any deepency vunerabilities. Part of the Ssecurelabs security image series."

LABEL version="1.0" maintainer="Alex Akass <alex@akass.com>"
LABEL com.seccurelabs.bach.version="0.0.1-beta"
LABEL vendor1="Ssecurelabs"
LABEL vendor2="Ttestlabs"
LABEL com.seccurelabs.bach.release-date="2021-04-03"
LABEL com.seccurelabs.bach.version.is-production="False"

# Elovate our user
USER root

#Update debian 10 and make sure the dependacies we need are installed
RUN apt-get update && apt-get upgrade -y && \
		apt-get install -y curl git unzip

# Install composer
RUN cd /tmp && curl -sS https://getcomposer.org/installer -o composer-setup.php && \
		php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#Install bach
RUN git clone https://github.com/sonatype-nexus-community/bach.git /usr/bin/bach && cd /usr/bin/bach && composer install && chmod +x /usr/bin/bach/bach

#user a non elovated user from this point onwards
RUN adduser bach
USER bach

#Set the project folder
WORKDIR /home/bach/app

#  entry point to use bach
ENTRYPOINT ["php", "/usr/bin/bach/bach"]
CMD ["composer", "composer.json"]
