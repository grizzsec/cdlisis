#!/bin/bash

# URL de la página web a analizar
url="https://www.example.com"

# Directorio temporal para almacenar los archivos descargados
temp_dir="temp_analysis"

# Crear el directorio temporal si no existe
mkdir -p "$temp_dir"

# Realizar una solicitud GET a la URL y guardar la respuesta en un archivo
curl -s "$url" > "$temp_dir/response.html"

# Buscar posibles vulnerabilidades en la respuesta HTML
if grep -q "admin" "$temp_dir/response.html"; then
  echo "¡Vulnerabilidad encontrada! Posible presencia de un panel de administración."
else
  echo "No se encontraron vulnerabilidades conocidas."
fi

# Descargar todos los archivos enlaces en la página web
wget -r -l 1 -P "$temp_dir" -A pdf,jpg,jpeg,png,gif "$url" 2>/dev/null

# Realizar análisis adicional de los archivos descargados
echo "Análisis de archivos descargados:"
for file in "$temp_dir"/*; do
  # Verificar si el archivo es una imagen
  if file "$file" | grep -q "image"; then
    echo "Análisis de imagen: $file"
    # Agrega aquí tu lógica de análisis de imágenes según tus necesidades
    # Ejemplo: Verificar si la imagen contiene metadatos o información oculta
    exiftool "$file"
  fi
  # Verificar si el archivo es un archivo PDF
  if file "$file" | grep -q "PDF"; then
    echo "Análisis de PDF: $file"
    # Agrega aquí tu lógica de análisis de archivos PDF según tus necesidades
    # Ejemplo: Verificar si el PDF contiene enlaces maliciosos o scripts
    pdfid "$file"
  fi
  # Verificar si el archivo es un archivo JS
  if file "$file" | grep -q "JavaScript"; then
    echo "Análisis de archivo JS: $file"
    # Agrega aquí tu lógica de análisis de archivos JS según tus necesidades
    # Ejemplo: Buscar posibles vulnerabilidades conocidas en el código JavaScript
    js-beautify "$file" | grep -E "(eval|exec|dangerous_function)"
  fi
done

# Ejecutar escaneo de vulnerabilidades utilizando Nikto
echo "Ejecutando escaneo de vulnerabilidades con Nikto..."
nikto -h "$url" -output "$temp_dir/nikto_output.txt"

# Ejecutar escaneo de vulnerabilidades utilizando WPScan (si el sitio es WordPress)
if grep -q "wp-content" "$temp_dir/response.html"; then
  echo "El sitio web parece ser WordPress. Ejecutando escaneo de vulnerabilidades con WPScan..."
  wpscan --url "$url" --output "$temp_dir/wpscan_output.txt" --no-update
fi

# Realizar un análisis de seguridad de los formularios en la página web
echo "Realizando análisis de seguridad de formularios..."
curl -s -L "$url" | grep -E "<form.+action=" | while read -r form_line; do
  form_action=$(echo "$form_line" | sed -E 's/.*action="([^"]+)
echo "Análisis de formulario: $form_action"
  # Agrega aquí tu lógica de análisis de formularios según tus necesidades
  # Ejemplo: Verificar si el formulario utiliza HTTPS, si está protegido contra CSRF, etc.
  curl -s -L "$form_action" | grep -E "(https|csrf_token)"
done

# Realizar un análisis de seguridad de los enlaces en la página web
echo "Realizando análisis de seguridad de enlaces..."
curl -s -L "$url" | grep -E "<a\s+href=" | while read -r link_line; do
  link_href=$(echo "$link_line" | sed -E 's/.*href="([^"]+)".*/\1/')
  echo "Análisis de enlace: $link_href"
  # Agrega aquí tu lógica de análisis de enlaces según tus necesidades
  # Ejemplo: Verificar si el enlace utiliza HTTPS, si está protegido contra XSS, etc.
  curl -s -L "$link_href" | grep -E "(https|xss)"
done

# Eliminar el directorio temporal
rm -rf "$temp_dir"
