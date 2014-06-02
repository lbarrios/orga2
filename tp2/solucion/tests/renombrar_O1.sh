for file in data/resultados_nuestros/*.C.*
do
	echo mv "$file" "${file/C/C1}"
	mv "$file" "${file/C/C1}"
	 # ${file/#F0000/F000} means replace the pattern that starts at beginning of string
done
