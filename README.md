
# SERVIDOR VIVIENDAS
## Instalacion :wrench:

* Es necesario tener instalado Java y MySQL 
* Como IDE utilizaremos ECLIPSE
* [Herramienta para utilizar Spring boot](https://spring.io/tools)

## Correr Proyecto Localmente :computer:

### Crear Base de Datos 

Es necesario crear la base de datos y luego spring se encargara de crear todas las tablas
<br>
Para esto haremos lo siguiente desde un script MySQL
```
create database practicas
```

### Clonar el repositorio

```
  git clone https://github.com/camimisa/servidor_ppp.git
```

### Importar el proyecto con spring boot 
* En el PACKAGE EXPLORER de Eclipse hacer click derecho y seleccionar `IMPORT`
* Ir a la carpeta `MAVEN/Existing Maven Proyects`
* Buscar el root del proyecto y en projects debe aparecer el archivo /pom.xml
* Seleccionar ese archivo y hacer click en FINISH
* Por ultimo, buscar el archivo pom.xml, hacer click derecho y buscar la opcion Run As..
* Hacer click en `Maven Clean` y volver a hacer lo mismo y seleccionar `Maven Install` (Esto tambien se puede hacer desde la consola)

### Crear variables de entorno

Utilizamos variables de entorno para la conexion a la base de datos. Estas se pueden ver en el archivo src/main/resources/application.properties
<br>
Para crear nuestras variables de entorno hacemos
* En el Package Explorer hacemos click derecho en la carpeta que contiene todo el proyecto
* Click en `Run As`
* Click abajo de todo en `Run Configurations...`
* En la solapa que dice `Spring Boot` nos fijamos que donde dice `Proyect` este seleccionado nuestro proyecto
* Vamos a la solapa que dice `ENVIRONMENT`
* Con el boton `ADD` vamos agregando todas las variables necesarias

| VARIABLE             | VALUE                                                                | EJEMPLO |
| ----------------- | ------------------------------------------------------------------ | ----------- |
| DB_USER | tu usuario local mysql | root |
| DB_PASSWORD | tu clave local mysql | 123456 |
| DB_URL | Url de la conexion | jdbc:mysql://localhost:3306/practicas |
| SECRET_KEY | clave secreta | secret |

* Luego `Apply`  y `Close`

### Correr Proyecto

* Desde el `Boot Dashboard` seleccionar el nombre del proyecto e iniciarlo.
***
## API :arrow_down:

### Documentacion API :books:
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/16202751-69a7ad6c-ad38-4103-9fac-bc929e62f193?action=collection%2Ffork&collection-url=entityId%3D16202751-69a7ad6c-ad38-4103-9fac-bc929e62f193%26entityType%3Dcollection%26workspaceId%3D63e3c123-c66b-4a16-adfa-fc17b087575f#?env%5BProduccion%5D=W3sia2V5IjoiYXV0aC1rZXkiLCJ2YWx1ZSI6IiIsImVuYWJsZWQiOnRydWV9XQ==)
<br>
[Ver documentacion - Manual de usuario](https://docs.google.com/document/d/1MayJCYz-GbCCGVcoHMnvabD0ORjLwhQFhbNcQCTWhAI/edit?usp=sharing)
***
### LOG IN
Para poder enviar y consultar informacion al servidor es necesario estar loggeado.<br>
Para el login utilizamos [JSON Web Tokens](https://jwt.io/). <br>
#### POST: http://localhost:8080/auth/login
Json:
```
{
    "email": "admin02@email.com",
    "clave": "secreto"
}
```
Obtendra un JSON de respuesta donde estara el token que debe agregarse en el header de cada peticion. 
Esto esta explicado en el manual de usuario.
***
#### Link con el paso a paso para cargar las viviendas luego de cargarlas en el excel: 
En esta pagina al final tambien se encuentra el json para poder cargar las preguntas de las visitas. Es necesario hacerlo la primera vez.<br>
[Pagina web javascript](https://confident-bardeen-5ab688.netlify.app/)

### Algunos enpoints :link:
#### Obtener viviendas
```
  GET /vivienda
```

#### Crear vivienda

```
  POST /vivienda
```

<br> Esta es una vivienda de prueba. Para obtener el json de cada una acceder a la pagina mencionada anteriormente<br>
JSON: 
```
{
    "ubicacion": {
      "region": "Sur",
      "provincia": "Buenos Aires",
      "localidad": "Almirante Brown",
      "barrio": "Nuevo Sol 2",
      "direccion": "Manzana 1 terreno 5",
      "planta": "PB"
    },
    "documentacionTecnica": {
      "obra": {
        "intervenciones": [
          { "nroComponente": "0", "intervencion": { "id": "2" } },
          { "nroComponente": "1", "intervencion": { "id": "2" } },
          { "nroComponente": "2", "intervencion": { "id": "2" } },
          { "nroComponente": "3", "intervencion": { "id": "4" } }
        ],
        "nombreRepresentanteOSC": "Sin informacion"
      }
    },
    "ambientes": "1",
    "duenosVivienda": "TRUE",
    "cantHabitantes": "3",
    "cuestionarioHabitabilidad": "FALSE",
    "preguntasPgas": "FALSE"
  }
  ```
