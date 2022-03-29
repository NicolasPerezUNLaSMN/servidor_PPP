Ruta del proyecto
> cd /desarrollos-docker/geo-viviendas

Limpiar la Base de Datos
> docker ps
docker exec -it geo-viviendas_db-viv_1 /bin/bash
mysql -u root -p
drop database ppp_viviendas;
create database ppp_viviendas;

Bajar el docker
> docker-compose down

Regenerar la Imagen
> docker build . -t geo_viviendas_ppp:latest 

Actualizar el repositorio
> git pull

Levantar el docker
> docker-compose up -d

Prueba del Entorno (con postman)
