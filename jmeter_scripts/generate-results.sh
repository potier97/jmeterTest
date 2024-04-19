#!/bin/sh
# Ejemplo de ejecución  > ./generate-results.sh resultados_prueba results-performance.csv  results.csv

# Asignar el nombre de la carpeta donde se va a guardar los reportes
folder_name="$1"
# Asignar el nombre de la carpeta donde se va a guardar los reportes
result_performance="$2"
# Asignar el archivo de resultado de la prueba
result_file="$3"

# tamanio de las graficas
width=800
height=600
# nivel de log
log_level="ERROR"

if [ -d "$folder_name" ]; then
    rm -rf "$folder_name"
fi

# Crear la carpeta de resultados
mkdir -p "$folder_name"

echo "Generating results.."
# Ejecutar los comandos para generar los reportes y resultados
JMeterPluginsCMD.sh --generate-png "$folder_name/responseTimesOverTime.png" --input-jtl $result_file --plugin-type ResponseTimesOverTime --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/transactionPerSecond.png" --input-jtl $result_file --plugin-type TransactionsPerSecond --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/activeThreadsOverTime.png" --input-jtl $result_file --plugin-type ThreadsStateOverTime --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/latenciesOverTime.png" --input-jtl $result_file --plugin-type LatenciesOverTime --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/hitsPerSecond.png" --input-jtl $result_file --plugin-type HitsPerSecond --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/bytesThroughputOverTime.png" --input-jtl $result_file --plugin-type BytesThroughputOverTime --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-png "$folder_name/performance.png" --input-jtl $result_performance --plugin-type PerfMon --width $width --height $height --loglevel $log_level >/dev/null 2>&1
JMeterPluginsCMD.sh --generate-csv "$folder_name/aggregatingReport.csv" --input-jtl $result_file --plugin-type AggregateReport --loglevel $log_level >/dev/null 2>&1

# mensaje de finalizacion
echo "Reseults finished in folder: $folder_name"