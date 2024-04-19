FROM alpine:latest

WORKDIR /jmeter

# JMETER AL PATH
ENV JMETER_VERSION 5.6.3

# INSTALAR D3EPENDENCIAS
RUN apk add --no-cache openjdk11 curl unzip nano msttcorefonts-installer fontconfig python3
RUN update-ms-fonts

# ESTABLECER VARIABLES DE ENTORNO PARA JAVA
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$PATH:$JAVA_HOME/bin

# DESCARGAR JMETER Y DESCOMPRIMIR
RUN curl -L -o /tmp/apache-jmeter.zip https://downloads.apache.org/jmeter/binaries/apache-jmeter-$JMETER_VERSION.zip
RUN unzip -q /tmp/apache-jmeter.zip -d /jmeter \
    && rm /tmp/apache-jmeter.zip

## INSTALAR PLUGINS MANAGER https://jmeter-plugins.org/install/Install/ - SE DEBE GUARDAR EN LIB/EXT - VERSION jmeter-plugins-manager-1.10
RUN curl -L -o /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/jmeter-plugins-manager-1.10.jar https://jmeter-plugins.org/get/

# INSTALAR PLUGINS
# - GRAPHS GENERATOR LISTENER
# - PERFMON (SERVERS PERFORMANCE MONITORING)
# - COMMAND-LINE GRAPH PLOTTING TOOL
# - 3 BASIC GRAPHS - Average Response Time - Active Threads - Successful/Failed Transactions
# - 5 ADDITIONAL GRAPHS - Response Codes- Bytes Throughput - Connect Times - Latency - Hits/s
# - Synthesis Report
# - Filter Results Tool

# GRAPHS GENERATOR LISTENER - VERSION 2.0
RUN curl -L -o /tmp/jpgc-ggl-2.0.zip https://jmeter-plugins.org/files/packages/jpgc-ggl-2.0.zip
RUN unzip -q /tmp/jpgc-ggl-2.0.zip -d /jmeter/jpgc-ggl && rm /tmp/jpgc-ggl-2.0.zip
RUN cp /jmeter/jpgc-ggl/lib/jmeter-plugins-cmn-jmeter-0.4.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-ggl/lib/ext/jmeter-plugins-graphs-ggl-2.0.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-ggl/lib/ext/jmeter-plugins-manager-0.20.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

# SERVERS PERFORMANCE MONITORING - VERSION 2.1
RUN curl -L -o /tmp/jpgc-perfmon.zip https://jmeter-plugins.org/files/packages/jpgc-perfmon-2.1.zip
RUN unzip -q /tmp/jpgc-perfmon.zip -d /jmeter/jpgc-perfmon && rm /tmp/jpgc-perfmon.zip
RUN cp /jmeter/jpgc-perfmon/lib/ext/jmeter-plugins-perfmon-2.1.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-perfmon/lib/ext/jmeter-plugins-manager-0.20.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-perfmon/lib/jmeter-plugins-cmn-jmeter-0.4.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-perfmon/lib/perfmon-2.2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/

# JMETERPLUGINSCMD COMMAND LINE TOOL - SE INSTALA LA VERSION 2.2
RUN curl -L -o /tmp/jpgc-cmd-2.2.zip https://jmeter-plugins.org/files/packages/jpgc-cmd-2.2.zip
RUN unzip -q /tmp/jpgc-cmd-2.2.zip -d /jmeter/jpgc-cmd && rm /tmp/jpgc-cmd-2.2.zip
RUN cp /jmeter/jpgc-cmd/bin/JMeterPluginsCMD.bat /jmeter/apache-jmeter-$JMETER_VERSION/bin/
RUN cp /jmeter/jpgc-cmd/bin/JMeterPluginsCMD.sh /jmeter/apache-jmeter-$JMETER_VERSION/bin/
RUN cp /jmeter/jpgc-cmd/lib/cmdrunner-2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-cmd/lib/jmeter-plugins-cmn-jmeter-0.6.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-cmd/lib/ext/jmeter-plugins-cmd-2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-cmd/lib/ext/jmeter-plugins-manager-1.3.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

# 3 BASIC GRAPHS - VERSION 2.0
RUN curl -L -o /tmp/jpgc-graphs-basic-2.0.zip https://jmeter-plugins.org/files/packages/jpgc-graphs-basic-2.0.zip
RUN unzip -q /tmp/jpgc-graphs-basic-2.0.zip -d /jmeter/jpgc-graphs-basic && rm /tmp/jpgc-graphs-basic-2.0.zip
RUN cp /jmeter/jpgc-graphs-basic/lib/jmeter-plugins-cmn-jmeter-0.4.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-graphs-basic/lib/ext/jmeter-plugins-graphs-basic-2.0.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-graphs-basic/lib/ext/jmeter-plugins-manager-0.20.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

# 5 ADDITIONAL GRAPHS - VERSION 2.0
RUN curl -L -o /tmp/jpgc-graphs-additional-2.0.zip https://jmeter-plugins.org/files/packages/jpgc-graphs-additional-2.0.zip
RUN unzip -q /tmp/jpgc-graphs-additional-2.0.zip -d /jmeter/jpgc-graphs-additional && rm /tmp/jpgc-graphs-additional-2.0.zip
RUN cp /jmeter/jpgc-graphs-additional/lib/jmeter-plugins-cmn-jmeter-0.4.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-graphs-additional/lib/ext/jmeter-plugins-graphs-additional-2.0.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-graphs-additional/lib/ext/jmeter-plugins-manager-0.20.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

# SYNTHESIS REPORT - VERSION 2.2
RUN curl -L -o /tmp/jpgc-synthesis-2.2.zip https://jmeter-plugins.org/files/packages/jpgc-synthesis-2.2.zip
RUN unzip -q /tmp/jpgc-synthesis-2.2.zip -d /jmeter/jpgc-synthesis && rm /tmp/jpgc-synthesis-2.2.zip
RUN cp /jmeter/jpgc-synthesis/lib/jmeter-plugins-cmn-jmeter-0.4.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-synthesis/lib/ext/jmeter-plugins-manager-1.3.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-synthesis/lib/ext/jmeter-plugins-synthesis-2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
# CLASE DEPENDS ON: https://groups.google.com/g/jmeter-plugins/c/Da4YN_nLvJA

# FILTER RESULTS TOOL - VERSION 2.2
RUN curl -L -o /tmp/jpgc-filterresults-2.2.zip https://jmeter-plugins.org/files/packages/jpgc-filterresults-2.2.zip
RUN unzip -q /tmp/jpgc-filterresults-2.2.zip -d /jmeter/jpgc-filterresults && rm /tmp/jpgc-filterresults-2.2.zip
RUN cp /jmeter/jpgc-filterresults/lib/cmdrunner-2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-filterresults/lib/jmeter-plugins-cmn-jmeter-0.6.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/
RUN cp /jmeter/jpgc-filterresults/lib/ext/jmeter-plugins-filterresults-2.2.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-filterresults/lib/ext/jmeter-plugins-manager-1.3.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/
RUN cp /jmeter/jpgc-filterresults/bin/FilterResults.bat /jmeter/apache-jmeter-$JMETER_VERSION/bin/
RUN cp /jmeter/jpgc-filterresults/bin/FilterResults.sh /jmeter/apache-jmeter-$JMETER_VERSION/bin/

#ESATABLEDER EL PATH DE JMETER
ENV PATH=$PATH:/jmeter/apache-jmeter-$JMETER_VERSION/bin
# ESTABLECER VARIABLE PARA EJECUTAR EL JMETERPLUGINSCMD COMMAND LINE TOOL SH
ENV PATH=$PATH:/jmeter/apache-jmeter-$JMETER_VERSION/bin/JMeterPluginsCMD.sh


# VALIDAR LA INSTALACION DE JMETER
RUN jmeter -v

# Verificar la instalación de Java
RUN java -version

# COPIAR ESCENARIOS DE PRUEBAS
COPY /jmeter_scripts/ ./jmeter_scripts/

# EJECUCION INDEFINIDA
CMD ["tail", "-f", "/dev/null"]
