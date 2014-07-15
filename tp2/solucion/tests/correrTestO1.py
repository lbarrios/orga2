#!/usr/bin/env python3.2
from glob import glob
import os
import sys

comando = "tp2.O1"
inputDir = "data/imagenes_a_testear"
outputDir = "data/resultados_nuestros"

# Parseo los parámetros
try:
  imagen = sys.argv[1]
  filtro = sys.argv[2]
  version = sys.argv[3]
  iteraciones = sys.argv[4]
except:
  print( "ERROR:" )
  print( "Debe ingresar el nombre de la imagen que desea testear como primer parámetro." )
  print( "Debe el filtro como segundo parámetro." )
  print( "Debe ingresar la versión como tercer parámetro." )
  print( "Debe ingresar la cantidad de iteraciones como cuarto parámetro." )
  print( "\nEjemplos: " )
  print( "\tpython3 correrTest.py lena tiles c 10" )
  print( "\tpython3 correrTest.py lena tiles asm 10" )
  quit()

# Parseo filtro
if filtro == 'tiles':
  config = " 20 30 40 50 "
elif filtro == 'popart':
  config = " 20 30 40 50 "
elif filtro == 'temperature':
  config = "  "
elif filtro == 'ldr':
  config = " 200 "
else:
  print("""ERROR:
No se reconoce el filtro introducido.
Las opciones son:
tiles
popart
temperature
ldr
""")
  quit()

# Parseo versión
if version != 'c' and version != 'asm':
  print("""ERROR:
No se reconoce la versión.
Las versiones disponibles son: c y asm.
""")
  quit()

if int(iteraciones) <= 0:
  print("""ERROR:
No se reconoce la cantidad de iteraciones.
Debe ser un número entero mayor a cero :D
""")
  quit()

# Parseo inputFile
inputFiles = glob( "{}/{}*.bmp".format(inputDir,imagen) )
if len(inputFiles)==0:
  print("No se encontró ningún archivo con el nombre indicado.")
  quit()

# Corro los tests
for file in sorted(inputFiles):
  output = file.replace(".bmp",".txt")
  comando = "../bin/{} {} -i {} -t {} -o {} {} {}".format(comando, filtro, version, int(iteraciones), outputDir, file, config)
  print("corriendo: {}".format(comando))
  os.system(comando)
