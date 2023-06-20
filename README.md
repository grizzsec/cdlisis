# cdlisis

Script en bash que realiza análisis dinámicos en páginas web.

En esta versión, se agregaron varias características (además de wget, grep... etc)

Se incluyó el análisis de imágenes utilizando la herramienta exiftool para verificar los metadatos y la posible presencia de información oculta en las imágenes descargadas.

Se agregó el análisis de archivos PDF utilizando la herramienta pdfid para identificar posibles enlaces maliciosos o scripts presentes en los archivos PDF descargados.

Se agregó el escaneo de vulnerabilidades utilizando la herramienta nikto, que realiza una exploración exhaustiva en busca de vulnerabilidades comunes en el sitio web objetivo.

Se incluyó el escaneo de vulnerabilidades utilizando la herramienta wpscan en caso de que el sitio web sea una instancia de WordPress. Esta herramienta realiza un análisis específico para detectar vulnerabilidades en sitios web de WordPress.

Se agregó el análisis de archivos JavaScript utilizando la herramienta js-beautify para buscar posibles vulnerabilidades conocidas en el código JavaScript descargado.

Se realizó un análisis de seguridad de los formularios presentes en la página web, verificando aspectos como el uso de HTTPS y la protección contra ataques CSRF.

Se realizó un análisis de seguridad de los enlaces en la página web, verificando aspectos como el uso de HTTPS y la protección contra ataques XSS.
