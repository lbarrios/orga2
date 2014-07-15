#!/usr/bin/env python2
# -*- coding: utf-8 -*-
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
  print( "\tpython2 graficar.py lena tiles\t\t\t para graficar una en especial" )
  print( "\tpython2 graficar.py TODAS tiles\t\t\t para correr todas juntas" )
  quit()

if imagen=="TODAS":
  inputFiles = glob( "{}/*.{}.*.txt".format(inputDir,filtro) )
else:
  inputFiles = glob( "{}/{}.*.{}.*.txt".format(inputDir,imagen,filtro) )
  print imagen

# Parseo inputFile
if len(inputFiles)==0:
  print("ERROR:\nNo se encontró ningún archivo con el nombre y/o filtro indicado.")
  quit()

c = defaultdict(list)
c0 = defaultdict(list)
c1 = defaultdict(list)
c2 = defaultdict(list)
c3 = defaultdict(list)
asm = defaultdict(list)
asm0 = defaultdict(list)
asm1 = defaultdict(list)

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
    if version=='ASM0':
      asm0[area].append(value)
    if version=='ASM1':
      asm1[area].append(value)
    if version=='C':
      c[area].append(value)
    if version=='C0':
      c0[area].append(value)
    if version=='C1':
      c1[area].append(value)
    if version=='C2':
      c2[area].append(value)
    if version=='C3':
      c3[area].append(value)

y_asm = list()
x_asm = list()
y_asm0 = list()
x_asm0 = list()
y_asm1 = list()
x_asm1 = list()

y_c = list()
x_c = list()
y_c0 = list()
x_c0 = list()
y_c1 = list()
x_c1 = list()
y_c2 = list()
x_c2 = list()
y_c3 = list()
x_c3 = list()

for x in asm:
  y_asm.append(int(np.mean([y for y in asm[x] if y <= np.percentile(asm[x],75) and y >= np.percentile(asm[x],25)])))
  x_asm.append(x)
  y_asm, x_asm = (list(t) for t in zip(*sorted(zip(y_asm, x_asm))))
for x in asm0:
  y_asm0.append(int(np.mean([y for y in asm0[x] if y <= np.percentile(asm0[x],75) and y >= np.percentile(asm0[x],25)])))
  x_asm0.append(x)
  y_asm0, x_asm0 = (list(t) for t in zip(*sorted(zip(y_asm0, x_asm0))))
for x in asm1:
  y_asm1.append(int(np.mean([y for y in asm1[x] if y <= np.percentile(asm1[x],75) and y >= np.percentile(asm1[x],25)])))
  x_asm1.append(x)
  y_asm1, x_asm1 = (list(t) for t in zip(*sorted(zip(y_asm1, x_asm1))))

for x in c:
  y_c.append(int(np.mean([y for y in c[x] if y <= np.percentile(c[x],75) and y >= np.percentile(c[x],25)])))
  x_c.append(x)
  y_c, x_c = (list(t) for t in zip(*sorted(zip(y_c, x_c))))
for x in c0:
  y_c0.append(int(np.mean([y for y in c0[x] if y <= np.percentile(c0[x],75) and y >= np.percentile(c0[x],25)])))
  x_c0.append(x)
  y_c0, x_c0 = (list(t) for t in zip(*sorted(zip(y_c0, x_c0))))
for x in c1:
  y_c1.append(int(np.mean([y for y in c1[x] if y <= np.percentile(c1[x],75) and y >= np.percentile(c1[x],25)])))
  x_c1.append(x)
  y_c1, x_c1 = (list(t) for t in zip(*sorted(zip(y_c1, x_c1))))
for x in c2:
  y_c2.append(int(np.mean([y for y in c2[x] if y <= np.percentile(c2[x],75) and y >= np.percentile(c2[x],25)])))
  x_c2.append(x)
  y_c2, x_c2 = (list(t) for t in zip(*sorted(zip(y_c2, x_c2))))
for x in c3:
  y_c3.append(int(np.mean([y for y in c3[x] if y <= np.percentile(c3[x],75) and y >= np.percentile(c3[x],25)])))
  x_c3.append(x)
  y_c3, x_c3 = (list(t) for t in zip(*sorted(zip(y_c3, x_c3))))


def to_percent(y, position):
    # Ignore the passed in position. This has the effect of scaling the default
    # tick locations.
    s = str(100 * y)
    # The percent symbol needs escaping in latex
    return s + '%'


import matplotlib.pyplot as plt
import matplotlib.ticker as tck
from time import strftime
# - Arreglo la columna tiempo
formatter = tck.EngFormatter(unit='.', places=1) # Formato "segundos"
formatter.ENG_PREFIXES[-6] = 'u' # Arreglo el símbolo "mu"
# - Arreglo la columna x
formatter_x = tck.EngFormatter(unit='px', places=1) # Formato "segundos"
formatter_x.ENG_PREFIXES[-6] = 'u' # Arreglo el símbolo "mu"
# - Creo el formato de porcentaje
percent_formatter = tck.FuncFormatter(to_percent)
# - Creo los subplot
#fig, subplot = plt.subplots(nrows=t_types, ncols=1, sharex=True, sharey=False)
fig,subplot = plt.subplots()
subplot.yaxis.set_major_formatter(formatter)
#subplot.yaxis.set_major_formatter(percent_formatter)
subplot.xaxis.set_major_formatter(formatter_x)

#print "C0: ",x_c0,y_c0
#print "C1: ",x_c1,y_c1
#print "C2: ",x_c2,y_c2
#print "C3: ",x_c3,y_c3
#print "ASM: ",x_asm,y_asm
print "ASM0: ",x_asm0,y_asm0
print "ASM1: ",x_asm1,y_asm1

# Aplico formato
plt.grid(True)
#plt.title("{}".format(filtro))
plt.title(u'Mejoría de prefetch')
#plt.ylabel('Ciclos del procesador')
plt.ylabel(u'Relación de tiempo entre "con prefetch" y "sin prefetch"')
plt.xlabel(u'Tamaño de entrada (pixeles)')

c_print = False
asm_print = True

if x_c and c_print:
  plt.plot(np.array( x_c ), np.array( y_c ), linestyle='-',  color='red', linewidth=2, label='C', alpha=1) 
if x_c0 and c_print:
  plt.plot(np.array( x_c0 ), np.array( y_c0 ), linestyle='-',  color='#ff8c00', linewidth=2, label='C0', alpha=1) 
if x_c1 and c_print:
  plt.plot(np.array( x_c1 ), np.array( y_c1 ), linestyle='-',  color='#222200', linewidth=1, label='C1', alpha=1) 
if x_c2 and c_print:
  plt.plot(np.array( x_c2 ), np.array( y_c2 ), linestyle='-',  color='red', linewidth=1, label='C2', alpha=1) 
if x_c3 and c_print:
  plt.plot(np.array( x_c3 ), np.array( y_c3 ), linestyle='-',  color='#0B6121', linewidth=1, label='C3', alpha=1) 
if x_asm and asm_print:
	plt.plot(np.array( x_asm ), np.array( y_asm ), linestyle='-',  color='blue', linewidth=2, label='ASM', alpha=1) 
if x_asm0 and asm_print:
  plt.plot(np.array( x_asm0 ), np.array( y_asm0 ), linestyle='-',  color='red', linewidth=2, label='ASM Sin Acc. Mem', alpha=1) 
if x_asm1 and asm_print:
  plt.plot(np.array( x_asm1 ), np.array( y_asm1 ), linestyle='-',  color='green', linewidth=2, label='ASM 500 oper. OR', alpha=1) 
# if x_asm0 and x_asm1:
#   y_comp = np.array( np.array( y_asm1 ).astype(float) / np.array( y_asm0 ).astype(float) )
#   print y_comp
#   y_100 = np.array (y_comp)
#   y_100.fill(1.0)
#   print y_100
#   plt.plot(np.array( x_asm1 ), y_100, linestyle='--',  color='blue', linewidth=2, label=u'Sin prefetch', alpha=1) 
#   plt.plot(np.array( x_asm1 ), y_comp, linestyle='-',  color='red', linewidth=2, label=u'Con prefetch', alpha=1) 
plt.legend(loc=2)
plt.tight_layout()

plt.show()

import time
if not os.path.exists(outputDir) or not os.path.isdir(outputDir):
  os.makedirs(outputDir)
#plt.savefig(outputDir+"/{}.{}.pdf".format(filtro,time.strftime('%Y-%m-%d-%H-%M-%S', time.localtime())))
