FROM webgames/awscli


ENV LANG en_US.UTF-8

# Install Java.
ENV JAVA_VERSION=11.0.5 \
	JAVA_PKG=jdk-11.0.5_linux-x64_bin.tar.gz \
	JAVA_SHA256=387e60bdad6d6fc20d41cd712536f0f7adbb086fa73bc3cb225b3edad0bfa0a6 \
	JAVA_HOME=/usr/java/jdk-11
	
ENV	PATH $JAVA_HOME/bin:$PATH

RUN apt-get update && \
	apt-get install -y software-properties-common
##
COPY $JAVA_PKG /tmp/jdk.tgz
RUN set -eux; \
	\
	echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
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
