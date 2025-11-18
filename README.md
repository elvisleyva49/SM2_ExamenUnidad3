# SM2 - Examen Unidad 3: GitHub Actions y DevOps

## Información del Curso

- **Curso:** Soluciones Móviles 2
- **Fecha:** 18 de Noviembre, 2025
- **Estudiante:** Elvis Ronald Leyva Sardon

## Repositorio del Proyecto

**URL del repositorio:** https://github.com/elvisleyva49/SM2_ExamenUnidad3

## Evidencias del Proyecto

### 1. Estructura de Carpetas `.github/workflows/`

La estructura de carpetas creada en la raíz del repositorio es la siguiente:

```
SM2_ExamenUnidad3/
├── .github/
│   └── workflows/
│       └── quality-check.yml
├── app_perufest/
│   ├── lib/
│   ├── test/
│   │   └── main_test.dart
│   ├── pubspec.yaml
│   └── ...
└── README.md
```

<img width="303" height="613" alt="image" src="https://github.com/user-attachments/assets/0ecfa55c-2078-4b54-b989-e86ea917e4bd" />


### 2. Contenido del Archivo `quality-check.yml`

El workflow de GitHub Actions configurado contiene los siguientes pasos:

```yaml
name: Quality Check

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 11
        uses: actions/setup-java@v4
        with:
          java-version: '11'
          distribution: 'temurin'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'  
          channel: 'stable'
          cache: true

      - name: Install dependencies
        working-directory: ./app_perufest
        run: flutter pub get

      - name: Analyze code
        working-directory: ./app_perufest
        run: flutter analyze --no-fatal-warnings --no-fatal-infos

      - name: Run tests
        working-directory: ./app_perufest
        run: flutter test
```

<img width="580" height="820" alt="image" src="https://github.com/user-attachments/assets/f3cf1a08-34cc-4536-82e5-6056d133d3c3" />

### 3. Ejecución del Workflow en GitHub Actions

El workflow se ejecuta automáticamente cuando se realiza:
- Un push a la rama `main`
- Un pull request hacia la rama `main`

<img width="1303" height="406" alt="image" src="https://github.com/user-attachments/assets/795b0076-bf83-4d1d-9064-d264b5027ba1" />

## Explicación de lo Realizado

### Objetivo del Proyecto
Implementar un flujo de trabajo automatizado en GitHub Actions para realizar análisis de calidad sobre el proyecto móvil Flutter "PeruFest", integrando prácticas de DevOps.

### Actividades Desarrolladas

#### 1. Configuración del Repositorio
- Creación del repositorio público `SM2_ExamenUnidad3` en GitHub
- Migración completa del proyecto Flutter `app_perufest` al nuevo repositorio
- Configuración de la estructura de carpetas requerida

#### 2. Implementación del Workflow de CI/CD
El archivo `quality-check.yml` implementa un pipeline de integración continua que incluye:

- **Checkout del código:** Descarga el código fuente del repositorio
- **Configuración del entorno:** 
  - JDK 11 para compilación Android
  - Flutter 3.29.2 estable con caché habilitado
- **Instalación de dependencias:** `flutter pub get`
- **Análisis estático del código:** `flutter analyze` para verificar:
  - Buenas prácticas de estilo
  - Convenciones de naming
  - Detección de warnings e imports innecesarios
  - Errores sintácticos
- **Ejecución de pruebas:** `flutter test` para validar:
  - Funcionalidad del código
  - Casos de prueba unitarios
  - Regresiones en el desarrollo

#### 3. Desarrollo de Pruebas Unitarias
Se implementaron **3 pruebas unitarias** en `main_test.dart` para la funcionalidad de creación de noticias:

1. **Prueba de creación exitosa:** Valida el flujo normal con datos válidos
2. **Prueba de validación:** Verifica el manejo de campos vacíos obligatorios  
3. **Prueba de manejo de errores:** Simula fallos en la subida de imágenes

<img width="781" height="988" alt="image" src="https://github.com/user-attachments/assets/ed0b6367-20fc-43bc-8710-67f162d24f5e" />

Las pruebas utilizan **mocks** para simular servicios externos, garantizando:
- Aislamiento de la lógica de negocio
- Predictibilidad en los resultados
- Rapidez en la ejecución
- Control total sobre diferentes escenarios

#### 4. Tecnologías y Herramientas Utilizadas
- **GitHub Actions:** Para CI/CD automatizado
- **Flutter 3.29.2:** Framework de desarrollo móvil
- **Dart:** Lenguaje de programación
- **flutter_test:** Framework de pruebas unitarias
- **Mocks personalizados:** Para simulación de servicios

### Beneficios Implementados

#### Calidad del Código
- Análisis automático en cada commit
- Detección temprana de errores
- Cumplimiento de estándares de codificación

#### Integración Continua
- Validación automática de cambios
- Prevención de regresiones
- Feedback inmediato a los desarrolladores

#### DevOps y Automatización
- Reducción de tareas manuales
- Consistencia en el proceso de testing
- Integración con el flujo de trabajo de GitHub

### Consideraciones Técnicas

#### Configuración del Workflow
- Se utiliza `working-directory: ./app_perufest` debido a la estructura del repositorio
- Se configuran flags `--no-fatal-warnings --no-fatal-infos` para un análisis más permisivo
- Cache habilitado para optimizar tiempos de ejecución

#### Estrategia de Testing
- Implementación de mocks para independencia de servicios externos
- Cobertura de casos críticos: éxito, validación y manejo de errores
- Estructura estándar con `group()`, `setUp()` y `test()`

#### Arquitectura del Proyecto
El proyecto sigue el patrón **MVVM (Model-View-ViewModel)** con:
- Modelos para representación de datos (`Noticia`)
- ViewModels para lógica de negocio (`NoticiasViewModel`)
- Servicios para acceso a datos (`NoticiasService`, `ImgBBService`)
- Vistas para interfaz de usuario (`CrearNoticiaPage`)

### Resultados Esperados
- ✅ **100% de pruebas exitosas** en el workflow
- ✅ **Análisis de código sin errores críticos**
- ✅ **Integración continua funcional**
- ✅ **Documentación completa del proceso**

Este proyecto demuestra la implementación exitosa de prácticas DevOps en el desarrollo móvil, garantizando calidad, automatización y mantenibilidad del código.
