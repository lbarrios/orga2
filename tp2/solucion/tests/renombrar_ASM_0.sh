#!/usr/bin/env bash

for file in data/resultados_nuestros/*.ASM.*
do
	echo mv "$file" "${file/ASM/ASM0}"
	mv "$file" "${file/ASM/ASM0}"
	 # ${file/#F0000/F000} means replace the pattern that starts at beginning of string
done
