FROM alpine:latest

WORKDIR /jmeter

# JMETER AL PATH
ENV JMETER_VERSION 5.6.3

# INSTALAR JAVA

# Instalar Java
RUN apk add --no-cache openjdk11 curl unzip git

# Establecer variables de entorno para Java
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$PATH:$JAVA_HOME/bin

# Descargar JMeter
RUN curl -L -o /tmp/apache-jmeter.zip https://downloads.apache.org/jmeter/binaries/apache-jmeter-$JMETER_VERSION.zip

# DESCOMPRIMIR JMeter
RUN unzip -q /tmp/apache-jmeter.zip -d /jmeter \
    && rm /tmp/apache-jmeter.zip

# AGREGAR EL PLUGIN DE MONITOREO DE RECURSOS
ADD https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-perfmon/2.1/jmeter-plugins-perfmon-2.1.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

#ESATABLEDER EL PATH DE JMETER
ENV PATH=$PATH:/jmeter/apache-jmeter-$JMETER_VERSION/bin

# VALIDAR LA INSTALACION DE JMETER
RUN jmeter -v

# Verificar la instalación de Java
RUN java -version

# EJECUCION INDEFINIDA
CMD ["tail", "-f", "/dev/null"]
