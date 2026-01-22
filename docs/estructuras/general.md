# Manual general de la aplicacion de Mil Mujeres

# Indice

    Descripcion general de la aplicacion
    Nombre de la aplicacion
    ¿Qué hace?
    El propósito de la aplicación
    Requisitos técnicos (ambiente, soporte, lenguajes, entorno de programación, servidor)
    Instrucciones de instalación y configuración del entorno de desarrollo.
    Como esta organizado el codigo

## Descripcion general de la aplicacion

    Mil Mujeres es una aplicación móvil desarrollada en Flutter para dispositivos iOS y Android, diseñada para facilitar el acceso a la información y los servicios legales ofrecidos por la organización Mil Mujeres. La aplicación ha estado en funcionamiento durante varios años, consolidándose como una herramienta clave en la interacción entre los usuarios y los procesos internos de la organización.

## Nombre de la aplicacion

    Mil Mujeres

## ¿Qué hace?

    La aplicación se conecta a un sistema interno llamado Teams, una API desarrollada en Laravel por el equipo de la organización. Esta integración permite a los usuarios acceder a información clave como:
        • Estado actual de su caso legal.
        • Historial de depósitos y pagos realizados.
        • Eventos programados por la organización.
        • Información general sobre oficinas, alianzas y referencias.
        • Datos personales y configuración de su perfil.

## El propósito de la aplicación

    El propósito de esta aplicación es brindar a los usuarios un canal accesible y seguro para informarse sobre el estado de su proceso legal y las actividades de la organización, fortaleciendo así la transparencia, el acompañamiento y la confianza en el servicio prestado por Mil Mujeres.

## Requisitos técnicos (ambiente, soporte, lenguajes, entorno de programación, servidor)

    1. Entorno de programacion:
        • Lenguaje principal (Frontend móvil): Dart (mediante Flutter SDK).
        • IDE recomendado: Visual Studio Code y Android Studio.
        • Gestión de estado:  BloC.
        • Almacenamiento local: flutter_secure_storage, shared_preferences.
        • Manejo de peticiones HTTP: http o dio.

    2. Backend y servidor
        • API principal: Sistema interno llamado Teams, desarrollado en Laravel (PHP).
        • Servidor: Infraestructura privada de la organización Mil Mujeres.
        • Autenticación: Control de acceso mediante cuentas administradas por el equipo interno.
        • Formato de intercambio de datos: JSON a través de peticiones REST.

    3. Soporte y mantenimiento
        • El mantenimiento del sistema y la creación de cuentas es gestionado por el equipo de soporte interno de Mil Mujeres.
        • La app se actualiza periódicamente para asegurar compatibilidad, seguridad y mejoras en la experiencia de usuario.

## Instrucciones de instalación y configuración del entorno de desarrollo.

    1. Descargar el kit de desarrollo de Flutter.

        Lo puedes encontrar para Windows aquí:
        https://docs.flutter.dev/get-started/install/windows 

    2. Descomprimirlo en el disco C.
    3. Registrar en el path en las variables de entorno del sistema.
    4. Instalar las extensiones de Dart y Flutter en VIsual Studio Code.
    5. Instalacion de Android Studio.

        Lo puedes encontrar aqui:
        https://developer.android.com/studio/index.html

        Mientras trabajas en Flutter, es necesario probar la aplicacion en un dispositivo, por esta razón es necesario usar los servicios que ofrece Android Studio, que te ofrece la opcion de emular un dispositivo Android.

        Es necesario que instales las herramientas de consola de SDK, estas permiten compilar la aplicación en un emulador con Flutter.

        ![android-studio] (./assets/android-sdk.png)

    6. Revisar la configuracion.
        
        Si tienes problemas con la instalación o crees que falta algo, puede ejecutar el comando Flutter doctor para tener más información.

## Como esta organizado el codigo (estructura de carpetas de lib)

    {{ organizacion_codigo: describe la estructura de lib }}

