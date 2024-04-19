#!/bin/sh
# Ejemplo de ejecucion > ./generate-test.sh plan_de_pruebas carpeta_de_resultados numero_de_hilos ramp_up

# plan de pruebas - archivo .jmx
PLAN_TEST="$1"

# carpeta donde se guardara todo
PLAN_TEST_FOLFER=$2

#NUMERO DE HILOS
NUM_THREADS="$3"

#RAMP UP
RAMP_UP="$4"
INITIAL_RAMP_UP=$RAMP_UP

#ITERACIONES
ITERATIONS=5

#DECREMENTO DE ACELERACION
DECREMENT=2

#REFERENCIA PLAN DE PREUBA ITERATIVA
PLAN_ITERATION_FILE=""

#REFERENCIA DE CARPETA ITERATIVA
PLAN_ITERATION_FOLDER=""

if [ -d "$PLAN_TEST_FOLFER" ]; then
    rm -rf "$PLAN_TEST_FOLFER"
fi

# Crear la carpeta de resultados
mkdir -p "$PLAN_TEST_FOLFER"


# Bucle para generar archivos de prueba iterativos
for i in `seq 1 $ITERATIONS`; do

    if [ $RAMP_UP -lt 0 ]; then
        echo "Ramp-up no puede ser negativo"
        return
    fi

    #CREAR LA CARPETAS DE PLAN DE PRUEBAS ITERATIVAS
    PLAN_ITERATION_FOLDER="$PLAN_TEST_FOLFER/iteration_$i""_threads_$NUM_THREADS""_rampup_$RAMP_UP"
    mkdir -p $PLAN_ITERATION_FOLDER
    PLAN_ITERATION_FILE=$PLAN_ITERATION_FOLDER"/plan_iteration_$i.jmx"
    cp $PLAN_TEST $PLAN_ITERATION_FILE

    #Modificar el plan de pruebas con threads y ramp-up
    python3 update_file.py $PLAN_ITERATION_FILE "$PLAN_ITERATION_FOLDER/results" $NUM_THREADS $RAMP_UP   

    #Calcular los valores actualizados para esta iteración
    RAMP_UP=$((RAMP_UP - DECREMENT))
done

echo "Pruebas generadas en la carpeta $PLAN_TEST_FOLFER"

# RESTAURAR EL VALOR DE RAMP_UP
RAMP_UP=$INITIAL_RAMP_UP

# EJECUCION DE LAS PRUEBAS
for i in `seq 1 $ITERATIONS`; do
    PLAN_ITERATION_FOLDER="$PLAN_TEST_FOLFER/iteration_$i""_threads_$NUM_THREADS""_rampup_$RAMP_UP"
    PLAN_ITERATION_FILE=$PLAN_ITERATION_FOLDER"/plan_iteration_$i.jmx"
    echo "Ejecutando el plan de pruebas $PLAN_ITERATION_FILE"
    jmeter -n -t $PLAN_ITERATION_FILE -l $PLAN_ITERATION_FOLDER"/results/results.csv"
    #GENERAR LOS GRAFICOS
    ./generate-results.sh $PLAN_ITERATION_FOLDER"/graphs" $PLAN_ITERATION_FOLDER"/results/results-performance.csv" $PLAN_ITERATION_FOLDER"/results/results.csv"
    # GENERAR REPORTE FINAL
    jmeter -g $PLAN_ITERATION_FOLDER"/results/results.csv" -o $PLAN_ITERATION_FOLDER"/report"

    # DELAY DE 10S
    echo "Esperando 5 segundos para la siguiente prueba"
    sleep 5
    #Calcular los valores actualizados para esta iteración
    RAMP_UP=$((RAMP_UP - DECREMENT))
done

echo "Pruebas finalizadas"
