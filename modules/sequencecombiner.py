#!/usr/bin/env python
# coding: utf-8

import os
import argparse

TQ_VERBOSE = os.getenv("TQ_VERBOSE", "F").lower().startswith("t")

class SequenceCombiner:
    def __init__(self, cazy_file, external_fasta_file=None, output_dir="output/cazy_sequences", output_file="updated_sequences.fasta", verbose=TQ_VERBOSE):
        self.cazy_file = cazy_file
        self.external_fasta_file = external_fasta_file
        self.output_dir = output_dir
        self.output_file = os.path.join(output_dir, output_file)
        self.verbose = verbose

        # Crear el directorio de salida si no existe
        os.makedirs(self.output_dir, exist_ok=True)

    def _print(self, message):
        if self.verbose:
            print(message)

    def combinar_secuencias(self):
        try:
            with open(self.output_file, "w") as combined_file:
                with open(self.cazy_file, "r") as fasta_file:
                    combined_file.write(fasta_file.read())

                if self.external_fasta_file:
                    if os.path.exists(self.external_fasta_file):
                        with open(self.external_fasta_file, "r") as external_file:
                            combined_file.write(external_file.read())
                        self._print(f"Secuencia externa añadida desde {self.external_fasta_file}.")
                    else:
                        self._print(f"No se encontró el archivo externo: {self.external_fasta_file}")
                else:
                    self._print("No se proporcionó un archivo externo.")

            self._print(f"Secuencias combinadas guardadas en {self.output_file}.")

        except Exception as e:
            self._print(f"Error al combinar secuencias: {e}")
            raise

def main():
    parser = argparse.ArgumentParser(description='Combinar secuencias FASTA de CAZy con secuencias externas')
    parser.add_argument('--cazy_file', required=True, help='Archivo FASTA de CAZy')
    parser.add_argument('--external_fasta', help='Archivo FASTA externo opcional')
    parser.add_argument('--output_dir', default='.', help='Directorio de salida')
    parser.add_argument('--output_file', default='combined.fasta', help='Nombre del archivo de salida')
    parser.add_argument('--verbose', action='store_true', help='Modo verbose')
    
    args = parser.parse_args()
    
    combiner = SequenceCombiner(
        cazy_file=args.cazy_file,
        external_fasta_file=args.external_fasta,
        output_dir=args.output_dir,
        output_file=args.output_file,
        verbose=args.verbose
    )
    
    combiner.combinar_secuencias()

if __name__ == "__main__":
    main()