#!/usr/bin/env python2
## -*- coding: utf-8 -*-
from glob import glob
import os
import sys
from collections import defaultdict
import numpy as np

inputDir = "data/resultados_nuestros"
outputDir = "data/graficos"

try:
  imagen = sys.argv[1]
  filtro = sys.argv[2]
except:
  print( "ERROR:" )
  print( "Debe ingresar el nombre de la imagen que desea testear como primer parámetro, o * para todas las imágenes." )
  print( "Debe el filtro como segundo parámetro." )
  print( "\nEjemplos: " )
  print( "\tpython3 correrTest.py lena tiles" )
  print( "\tpython3 correrTest.py * tiles" )
  quit()

if(imagen=='*'):
  inputFiles = glob( "{}/*.{}.*.txt".format(inputDir,filtro) )
else:
  inputFiles = glob( "{}/{}.*.{}.*.txt".format(inputDir,imagen,filtro) )

# Parseo inputFile
if len(inputFiles)==0:
  print("ERROR:\nNo se encontró ningún archivo con el nombre y/o filtro indicado.")
  quit()

c = defaultdict(list)
asm = defaultdict(list)

for f in sorted(inputFiles):
  print("Parseando: {}".format(f))
  file = open(f)
  filename = f.split("/")[-1]
  version = f.split(".")[-2]
  size = filename.split(".")[1]
  area = int(size.split("x")[0]) * int(size.split("x")[1])
  for line in file:
    value = int(line)
    if version=='ASM':
      asm[area].append(value)
    if version=='C':
      c[area].append(value)

y_asm = list()
x_asm = list()
y_c = list()
x_c = list()

for x in asm:
  y_asm.append(int(np.mean([y for y in asm[x] if y < np.percentile(asm[x],75) and y > np.percentile(asm[x],25)])))
  x_asm.append(x)
for x in c:
  y_c.append(int(np.mean([y for y in c[x] if y < np.percentile(c[x],75) and y > np.percentile(c[x],25)])))
  x_c.append(x)


import matplotlib.pyplot as plt
import matplotlib.ticker as tck
from time import strftime
# - Arreglo la columna tiempo
formatter = tck.EngFormatter(unit='s', places=1) # Formato "segundos"
formatter.ENG_PREFIXES[-6] = 'u' # Arreglo el símbolo "mu"
# - Creo los subplot
#fig, subplot = plt.subplots(nrows=t_types, ncols=1, sharex=True, sharey=False)
fig,subplot = plt.subplots()
subplot.yaxis.set_major_formatter(formatter)

# Aplico formato
plt.grid(True)
plt.title("Ejercicio 2 (cuartiles)")
plt.ylabel('Tiempo (segundos)')
plt.xlabel(u'Tamaño de entrada (sapos)')

plt.plot(np.array( x_c ), np.array( y_c ), linestyle='-',  color='red', linewidth=2, label='C', alpha=1) 
plt.plot(np.array( x_asm ), np.array( y_asm ), linestyle='-',  color='blue', linewidth=2, label='ASM', alpha=1) 
plt.legend(loc=2)

plt.show()
