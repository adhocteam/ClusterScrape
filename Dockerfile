FROM amazonlinux:2017.03

RUN yum -y update

RUN yum install -y -v python27-pip sudo findutils gcc python27-devel "@Development tools"

RUN yum install -y -v libffi-devel openssl-devel

RUN pip install ansible

COPY ops/deps/otp_src_20.0.tar.gz otp_src_20.0.tar.gz
COPY ops/deps/elixir-1.5.0.tar.gz elixir-1.5.0.tar.gz
ADD ops/playbook.yml playbook.yml
ADD ops/playbook-erlang.yml playbook-erlang.yml

RUN ansible-playbook playbook.yml
RUN ansible-playbook playbook-erlang.yml -vvv

ADD . /app

RUN ansible-playbook app/ops/playbook-build.yml -vvv
