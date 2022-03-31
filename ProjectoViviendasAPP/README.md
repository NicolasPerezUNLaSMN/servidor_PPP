# Aplicacion Movil

_Desarrollo de una aplicacion movil para la Universidad Nacional de Lanus._

## Comenzando 🚀

Esta aplicacion fue construida para que se puedan hacer relevaciones de viviendas.
Los relevadores van a ingresar a la aplicacion pudiendo hacer busqueda de la vivienda que van a controlar y luego haciendo click en ella pueden acceder a toda su informacion.
<br>
***
### Pre-requisitos 📋

_Dejamos estos links como ayuda para poder instalar lo necesario para correr el proyecto_

* [Instalacion Windows](https://docs.flutter.dev/get-started/install/windows) - Instalacion de flutter
* Tener instalado Android Studio o IntelliJ

### Instalación 🔧

_Paso a paso_
1) Clonar el repositorio
2) Primero es necesario descargarse todas las dependencias. Para esto abrir la terminar del editor o la de windows en la carpeta del proyecto y correr:
```
flutter pub get
```
3) Para correr el proyecto es necesario o tener un movil conectado por usb o si se utiliza android studio tener un [dispositivo virtual](https://developer.android.com/studio/run/managing-avds) encendido. [mas info](https://docs.flutter.dev/get-started/test-drive).
4) La primer pantalla que se ve en el proyecto es la pagina del login. Dejamos las credenciales para que puedan ingresar:
```
email: admin_programador@email.com
clave: secretoProgramador
```
5) Ya una vez loggeados pueden empezar a probar la aplicacion.
6) Por las dudas lo recomendable es que cambien la url del servidor para poder hacer pruebas y no modificar el servidor en produccion.

Para esto es necesario levantar el proyecto [en java](https://github.com/camimisa/servidor_ppp) y cambiar la url del servidor. Esta se encuentra en lib/tools/Servidor.dart <br>
La url si es local siempre va a ser: "http://10.0.2.2:{NUMERO_DE_PUERTO}"

En su bd local deberia agregar las viviendas y preguntas para poder probar esto (estos datos se encuentran en la coleccion de postman). (Los usuarios e intervenciones se agregan automaticamente la primera vez que levanta el servidor)

### Funcionalidad de la aplicacion ⌨️

Luego de iniciar sesion se pueden filtrar las viviendas segun varios requisitos o directamente apretar el boton buscar y apareceran todas. Estas viviendas son cargadas de un servidor desarrollado en Java-Spring.<br>
Una vez cargadas las viviendas se puede hacer click en alguna y poder ver su informacion. <br>
Cuando las viviendas son cargadas por primera vez su ubicacion no esta disponible. El relevador es el encargado de en la primer visita cargar la ubicacion de dicha vivienda.
<br>
La aplicacion esta pensada para que se pueda utilizar mientras no hay conexion a internet. Es por eso que se consulta una sola vez al servidor la informacion de las viviendas y se guardan TODAS en el movil (es por eso que demora unos minutos en cargarlas). Para actualizarlas hay que presionar un boton que nuevamente consulta al servidor. 
<br>
[Aqui](https://docs.google.com/presentation/d/15Y-4UQVq9-d88dzKsaEVO4fdRZ3EkzmhVeDlvtJowac/edit?usp=sharing) podra ver un manual de uso hecho para el usuario final para que pueda comprender mejor como funciona la aplicacion.<br>
##### 1) BOTON `TECNICO`
En esta solapa se puede ver la informacion tecnica y los documentos correspondientes a cada vivienda.
##### 2) BOTON `OBRA`
En esta solapa se puede ver la informacion de la obra. En la parte inferior tenemos dos botones mas
* _Visitas_ <br>
En esta seccion se pueden ver todas las visitas cargadas en el movil y agregar nuevas. Aqui es donde el relevador contesta las preguntas del estado de la vivienda y donde puede subir imagenes.
* _Certificados_ <br>
Lo mismo que con las visitas pero con los certificados necesarios.

Cuando se carga alguno de estos items estos SOLO QUEDAN GUARDADOS EN EL MOVIL. Para enviar la informacion al servidor hay un boton en especial el cual figura en la lista de visitas/certificados.

## Construido con 🛠️

_Herramientas utilizadas en el proyecto_

* [Flutter](https://flutter.dev/) - El framework usado
* [SqfEntity](https://pub.dev/packages/sqfentity) - Paquete de flutter utilizado para manejar la base de datos

## Modificar la bd
Para hacer esto debemos modificar el archivo que esta en lib/model/model.dart <br>
Leyendo la documentacion de SqfEntity va a encontrar como hacer los cambios necesarios. <br>
Para que estos cambios se apliquen hay que correr el siguiente comando ( que hara que se modifique el archivo que usamos para los modelos generado en model.g.dart)
```
flutter pub run build_runner build --delete-conflicting-outputs
```
## Base de datos

![bd_app](https://user-images.githubusercontent.com/65984808/150436185-4f911bfe-2463-4489-9cb2-92199a56b244.png)

## Generar descargable de la aplicacion
Para generar el instalador debemos seguir los pasos indicados en la documentacion de flutter https://docs.flutter.dev/deployment/android. Primero debemos generar el KeyStore mediante el siguiente comando:
```
keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Luego debemos crear un archivo llamado key.properties en la carpeta android con las dos passwords ingresadas al crear el KeyStore (pueden ser iguales), un alias y la ruta del archivo jks.
```
storePassword=unla2022
keyPassword=unla2022
keyAlias=alias_viviendas_1
storeFile=C:/Users/USER_NAME/upload-keystore.jks
```
Por ultimo generamos el apk, el cual podremos encontrar en la ruta "build/app/outputs/flutter-apk/"
```
flutter build apk
```
## Autores ✒️

* **Camila Garcia Misa**
* **Ezequiel Wokraczka** 
