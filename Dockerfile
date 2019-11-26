FROM webgames/awscli
MAINTAINER ebirukov

ENV LANG C.UTF-8

ENV JAVA_VERSION=11.0.5 \
        JAVA_PKG=jdk-11.0.5_linux-x64_bin.tar.gz \
        JAVA_HOME=/usr/java/jdk-11

ENV     PATH $JAVA_HOME/bin:$PATH

RUN apt-get update && \
        apt-get install -y software-properties-common

ARG JDK_PATH

RUN set -eux; \
        \
        mkdir -p "$JAVA_HOME"; \
        curl -s $JDK_PATH/$JAVA_PKG -o /tmp/jdk.tgz; \
        tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
        rm /tmp/jdk.tgz; \
        \
        ln -sfT "$JAVA_HOME" /usr/java/default; \
        ln -sfT "$JAVA_HOME" /usr/java/latest; \
        for bin in "$JAVA_HOME/bin/"*; do \
                base="$(basename "$bin")"; \
                [ ! -e "/usr/bin/$base" ]; \
                update-alternatives --install "/usr/bin/$base" "$base" "$bin" 20000; \
        done; \  
# -Xshare:dump will create a CDS archive to improve startup in subsequent runs
        java -Xshare:dump;


# Define working directory.
WORKDIR /data


CMD ["bash"]
