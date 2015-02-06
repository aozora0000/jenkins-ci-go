FROM centos:centos6

# EPEL/REMIインストール
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update && \
    yum -y install ansible && \
    yum -y update gmp

RUN mkdir /tmp/ansible
ADD ./playbook.yml /tmp/ansible/
WORKDIR /tmp/ansible
RUN ansible-playbook playbook.yml

USER worker
ENV HOME /home/worker
WORKDIR /home/worker

RUN curl -L https://raw.github.com/grobins2/gobrew/master/tools/install.sh | sh && \
    echo "export PATH=$HOME/.gobrew/bin:$PATH" > /home/worker/.bashrc && \
    echo 'eval "$(gobrew init -)"' >> /home/worker/.bashrc

RUN source /home/worker/.bashrc && \
    gobrew install 1.4 && \
    gobrew use 1.4

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]
