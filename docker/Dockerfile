FROM jenkins/jenkins:lts
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip \
    && unzip /tmp/terraform.zip -d /bin
USER jenkins
COPY user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
