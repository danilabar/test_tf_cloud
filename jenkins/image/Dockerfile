FROM jenkins/jenkins:lts

USER root

RUN apt-get update -y && \
apt-get install -y --no-install-recommends \
ca-certificates \
curl \
gnupg \
lsb-release && \
rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN chmod a+r /etc/apt/keyrings/docker.gpg && apt-get -y update && \
apt-get install -y --no-install-recommends \
docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN apt-get install -y --no-install-recommends apt-transport-https && \
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
apt-get -y update && \
apt-get install  -y --no-install-recommends kubectl

RUN usermod -a -G docker jenkins

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
chmod 700 get_helm.sh && \
./get_helm.sh && \
rm get_helm.sh

#USER jenkins

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

RUN jenkins-plugin-cli --plugins configuration-as-code:1569.vb_72405b_80249 && \
jenkins-plugin-cli --plugins cloudbees-folder:6.800.v71307ca_b_986b && \
jenkins-plugin-cli --plugins timestamper:1.21 && \
jenkins-plugin-cli --plugins gradle:2.2 && \
jenkins-plugin-cli --plugins git:5.0.0 && \
jenkins-plugin-cli --plugins ssh-slaves:2.854.v7fd446b_337c9 && \
jenkins-plugin-cli --plugins github-branch-source:1701.v00cc8184df93 && \
jenkins-plugin-cli --plugins ws-cleanup:0.44 && \
jenkins-plugin-cli --plugins antisamy-markup-formatter:155.v795fb_8702324 && \
jenkins-plugin-cli --plugins build-timeout:1.28 && \
jenkins-plugin-cli --plugins pipeline-github-lib:38.v445716ea_edda_ && \
jenkins-plugin-cli --plugins matrix-auth:3.1.6 && \
jenkins-plugin-cli --plugins authorize-project:1.4.0 && \
jenkins-plugin-cli --plugins credentials-binding:523.vd859a_4b_122e6 && \
jenkins-plugin-cli --plugins pipeline-stage-view:2.30 && \
jenkins-plugin-cli --plugins pam-auth:1.10 && \
jenkins-plugin-cli --plugins mailer:438.v02c7f0a_12fa_4 && \
jenkins-plugin-cli --plugins pipeline-milestone-step:111.v449306f708b_7 && \
jenkins-plugin-cli --plugins pipeline-build-step:2.18 && \
jenkins-plugin-cli --plugins pipeline-model-api:2.2118.v31fd5b_9944b_5 && \
jenkins-plugin-cli --plugins pipeline-model-extensions:2.2118.v31fd5b_9944b_5 && \
jenkins-plugin-cli --plugins workflow-multibranch:716.vc692a_e52371b_ && \
jenkins-plugin-cli --plugins pipeline-stage-tags-metadata:2.2118.v31fd5b_9944b_5 && \
jenkins-plugin-cli --plugins pipeline-model-definition:2.2118.v31fd5b_9944b_5 && \
jenkins-plugin-cli --plugins pipeline-stage-step:305.ve96d0205c1c6 && \
jenkins-plugin-cli --plugins pipeline-build-step:2.18 && \
jenkins-plugin-cli --plugins basic-branch-build-strategies:71.vc1421f89888e

COPY casc.yaml /var/jenkins_home/casc.yaml
COPY jobs/ /var/jenkins_home/jobs/