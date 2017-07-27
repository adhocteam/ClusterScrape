FROM amazonlinux:2017.03

RUN yum -y update

RUN yum install -y -v python27-pip sudo git ncurses-devel findutils gcc python27-devel openssl-devel libffi-devel rpm2cpio "@Development tools" rpm-build ruby-devel

RUN gem install --no-ri --no-rdoc fpm

RUN pip install ansible awscli boto

ADD ops/deps/packer_1.0.3_linux_amd64.zip packer.zip

RUN unzip packer.zip
RUN mv packer /usr/bin/packer

COPY ops/deps/otp_src_20.0.tar.gz otp_src_20.0.tar.gz
COPY ops/deps/elixir-1.5.0.tar.gz elixir-1.5.0.tar.gz

ADD ops/playbooks/erlang.yml playbook-erlang.yml

RUN ansible-playbook playbook-erlang.yml -vvv

ADD . /app

ENTRYPOINT ["ansible-playbook", "app/ops/playbooks/build.yml", "-vvv"]
