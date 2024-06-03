FROM jblaisdell/openresty:latest

RUN apt-get update && apt-get install -y cpanminus perl-doc lsb-release
RUN ["cpan", "-T", "YAML"]
RUN ["cpan", "-T", "IPC::Run"]
RUN ["cpan", "-T", "Test::Nginx"]
RUN ["luarocks", "install", "busted"]
WORKDIR "/opt"