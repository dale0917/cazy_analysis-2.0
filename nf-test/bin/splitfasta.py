#!/usr/bin/env python
import os
import sys

def dividir_fasta(archivo_fasta, num_secuencias_por_archivo, output_dir):
    # Crear directorio de salida si no existe
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(archivo_fasta, "r") as f:
        secuencias = []
        secuencia = ""

        # Leer y almacenar las secuencias del archivo
        for linea in f:
            if linea.startswith(">"):
                if secuencia:
                    secuencias.append(secuencia)
                secuencia = linea  # Almacenar encabezado
            else:
                secuencia += linea.strip()  # Almacenar secuencia

        if secuencia:
            secuencias.append(secuencia)

    total_secuencias = len(secuencias)
    num_archivos = (total_secuencias + num_secuencias_por_archivo - 1) // num_secuencias_por_archivo

    # Dividir las secuencias en varios archivos
    for i in range(num_archivos):
        inicio = i * num_secuencias_por_archivo
        fin = min((i + 1) * num_secuencias_por_archivo, total_secuencias)
        secuencias_a_guardar = secuencias[inicio:fin]

        # Nombre del archivo de salida
        nombre_archivo_salida = os.path.join(output_dir, f"secuencias_parte_{i+1}.txt")

        # Guardar las secuencias en el archivo correspondiente
        with open(nombre_archivo_salida, "w") as output_handle:
            output_handle.write("\n".join(secuencias_a_guardar))

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Uso: python splitfasta.py <archivo_fasta> <directorio_salida> <secuencias_por_archivo>")
        sys.exit(1)

    input_file = sys.argv[1]  # Archivo FASTA a dividir
    output_dir = sys.argv[2]  # Directorio donde se guardarán los archivos resultantes
    sequences_per_file = int(sys.argv[3])  # Número de secuencias por archivo

    dividir_fasta(input_file, sequences_per_file, output_dir)


    
