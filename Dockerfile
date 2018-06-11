FROM alpine:3.6

MAINTAINER Tang Jiujun <jiujun.tang@gmail.com>

ENV LANG=en_US.UTF-8 \
    JAVA_HOME=/usr/local/jvm/default \
    PATH=$PATH:/usr/local/jvm/default/bin:/opt/jprofiler/bin

RUN set -ex && { \
        echo 'http://mirrors.aliyun.com/alpine/v3.6/main'; \
        echo 'http://mirrors.aliyun.com/alpine/v3.6/community'; \
    } > /etc/apk/repositories \
    && apk update && apk add wget ca-certificates curl bash libstdc++ && \
    # glibc
    wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk -O /tmp/glibc-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk -O /tmp/glibc-bin-2.25-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk -O /tmp/glibc-i18n-2.25-r0.apk && \
    apk add --allow-untrusted /tmp/*.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo "export LANG=en_US.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    # jre
    mkdir -p /usr/local/jvm && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/server-jre-8u171-linux-x64.tar.gz -O /tmp/server-jre-8u171-linux-x64.tar.gz && \
    tar zxvf /tmp/server-jre-8u171-linux-x64.tar.gz -C /usr/local/jvm && \
    ln -s /usr/local/jvm/jdk1.8.0_171 $JAVA_HOME && \
    # jprofiler
    mkdir -p /opt && \
    wget https://download-keycdn.ej-technologies.com/jprofiler/jprofiler_linux_9_2_1.tar.gz -O /tmp/jprofiler_linux_9_2_1.tar.gz && \
    tar -xzf /tmp/jprofiler_linux_9_2_1.tar.gz -C /opt && \
    mv /opt/jprofiler9 /opt/jprofiler && \
    find /opt/jprofiler -mindepth 1 | grep -v -E '/bin$|/bin/agent.jar|/bin/attach.jar|/bin/jpenable|/bin/linux-x64|/bin/linux-x86|/lib$|/lib/attachTools.jar|/lib/attachProviders$|/lib/attachProviders/attachProviderLinux.jar|/\.install4j$|/\.install4j/MessagesDefault|/\.install4j/e962e03d.lprop|/\.install4j/i4jruntime.jar' | xargs -r rm -rf && \
    # clean
    apk del wget ca-certificates glibc-i18n && \
    rm -rf /tmp/* /var/cache/apk/*
