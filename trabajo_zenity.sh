#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
    opcion=$(zenity --list --title="Menú de Escaneos NMAP" --column="Opción" "1. Escaneo Rápido" "2. Escaneo Completo" "3. Escaneo de Servicios y Versiones" "4. Escaneo Silencioso" "5. Escaneo UDP" "6. Salir")
    case $opcion in
        "1. Escaneo Rápido")
            escaneo_rapido
            ;;
        "2. Escaneo Completo")
            escaneo_completo
            ;;
        "3. Escaneo de Servicios y Versiones")
            escaneo_servicios_versiones
            ;;
        "4. Escaneo Silencioso")
            escaneo_silencioso
            ;;
        "5. Escaneo UDP")
            escaneo_udp
            ;;
        "6. Salir")
            exit 0
            ;;
        *)
            zenity --error --text="Opción no válida."
            ;;
    esac
}

# Función para escaneo rápido
escaneo_rapido() {
    echo "Escaneando los puertos más comúnes..."
    resultado=$(nmap --top-ports 100 $ip | grep --color=auto "open")
    zenity --info --text="$resultado"
    guardar_resultados
}

# Función para escaneo completo
escaneo_completo() {
    echo "EJecutando escaneo completo..."
    resultado=$(nmap -p- $ip | grep --color=auto "open") # p es para todos los puertos
    zenity --info --text="$resultado"
    guardar_resultados
}

# Función para escaneo de servicios y versiones
escaneo_servicios_versiones() {
    echo "Escaneando servicios y versiones..."
    resultado=$(sudo nmap -sV -sC $ip | grep --color=auto "open") # sV versiones sC para usar scripts que vienen determinados por defecto
    zenity --info --text="$resultado"
    guardar_resultados
}

# Función para escaneo silencioso
escaneo_silencioso() {
    echo "Escaneo más lento y menos detectable por los firewalls..."
    resultado=$(sudo nmap -T2 -sS -Pn -p- $ip | grep --color=auto "open")
# t2 para aumentar tiempo de ejecucion del escaneo
# ss para que el escaneo sea menos detectable
# pn desactiva el escaneo de host
    zenity --info --text="$resultado"
    guardar_resultados
}

# Función para escaneo UDP
escaneo_udp() {
    echo "Escaneando puertos UDP..."
    resultado=$(sudo nmap -sU -p 1-65535 $ip | grep --color=auto "open")
    zenity --info --text="$resultado"
    guardar_resultados
}

# Función para guardar los resultados
guardar_resultados() {
    respuesta=$(zenity --question --text="¿Deseas guardar los resultados?" --ok-label="Sí" --cancel-label="No")
    if [ $? -eq 0 ]; then
        archivo=$(zenity --entry --title="Guardar resultados" --text="Introduce el nombre del archivo:")
        echo "Guardando los resultados en $archivo..."
        nmap $opciones $ip > $archivo
        zenity --info --text="Resultados guardados en $archivo"
    else
        zenity --info --text="No se guardarán los resultados"
    fi
}
# Comienza la ejecución
imgcat /home/andrea/Downloads/trabajofinal/nmap.jpg
echo "TEST DE CONECTIVIDAD"
echo "Este script sirve para realizar escaneos de NMAP, es decir, para ver qué puertos tenemos abiertos en el ordenador"
echo "Hay que tener instalado nmap y conocer nuestra dirección IP"
ip=$(zenity --entry --title="Introducir IP" --text="Introduce la IP:")
mostrar_menu
