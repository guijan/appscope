FROM centos:7

RUN yum -y update
RUN yum -y install centos-release-scl
RUN yum -y install libtool
RUN yum -y groupinstall "Development Tools"
RUN yum -y install flex-devel

RUN yum -y install devtoolset-7  wget automake

RUN yum -y install rh-python36

RUN mkdir /opt/test-runner/
RUN mkdir /opt/test-runner/logs/

RUN source scl_source enable rh-python36 && virtualenv /opt/test-runner/

RUN mkdir -p /opt/test

RUN cd /opt/test &&  wget https://github.com/linux-test-project/ltp/archive/master.zip && unzip master.zip && rm master.zip && mv ltp-master ltp

RUN cd /opt/test/ltp && make autotools && ./configure && make -j

#ADD http://cdn.cribl.io/dl/scope/latest/linux/libscope.so /usr/lib/libscope.so
#COPY ./libscope.so /usr/lib/libscope.so
#RUN chmod 755 /usr/lib/libscope.so
ENV SCOPE_LOG_LEVEL=info
ENV SCOPE_METRIC_DEST=udp://localhost:8125
ENV SCOPE_METRIC_VERBOSITY=4
ENV SCOPE_EVENT_LOGFILE=true
ENV SCOPE_EVENT_CONSOLE=true
ENV SCOPE_EVENT_METRIC=true
ENV SCOPE_EVENT_HTTP=true
#ENV SCOPE_EVENT_DEST=tcp://172.16.198.132:9109
ENV SCOPE_THREAD_DELAY="dup205"
COPY ./interposed_func/altp /opt/test/altp
RUN cd /opt/test/altp && make -j

COPY ./test_runner/requirements.txt /opt/test-runner/requirements.txt
RUN /opt/test-runner/bin/pip install -r /opt/test-runner/requirements.txt

COPY ./test_runner /opt/test-runner/
COPY ./interposed_func/syscall_tests_conf.json /opt/test-runner/syscall_tests_conf.json

ENTRYPOINT ["/opt/test-runner/bin/python", "/opt/test-runner/app.py", "--target", "syscalls","-l","/opt/test-runner/logs/", "--syscalls_tests_config", "/opt/test-runner/syscall_tests_conf.json"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
