#!/usr/bin/env bash

# Este script crea las multiples imagenes de prueba a partir de unas
# pocas imagenes base.

DATADIR=./data/
TESTINDIR=$DATADIR/imagenes_a_testear
CATEDRADIR=$DATADIR/resultados_catedra
ALUMNOSDIR=$DATADIR/resultados_nuestros

IMAGENES="lena.bmp marilyn.bmp cuadrados.bmp matrix.bmp playa.bmp playabw.bmp"

mkdir $TESTINDIR $CATEDRADIR $ALUMNOSDIR

sizes=(100x100 150x150 200x200 250x250 300x300 350x350 400x400 450x450 500x500 550x550 600x600 650x650 700x700 750x750 800x800 850x850 900x900 950x950 1000x1000 1050x1050 1100x1100 1150x1150 1200x1200 1250x1250 1300x1300 1350x1350 1400x1400 1450x1450 1500x1500 1650x1650 1700x1700 1750x1750 1800x1800 1900x1900 2000x2000 2400x2400 2900x2900 3500x3500 4000x4000 5000x5000 6000x6000 7000x7000 8000x8000 9000x9000 10000x10000)

for f in $IMAGENES;
do
	echo $f

	for s in ${sizes[*]}
	do
		echo "  *" $s

		`echo  "convert -resize $s!" $DATADIR/$f ` $TESTINDIR/`echo "$f" | cut -d'.' -f1`.$s.bmp

	done
done
