## Índice

1. [Flujo de diseño de base de datos](#flujo-de-diseño-de-base-de-datos)
2. [Flyway](#flyway)
3. [Instalación](#instalación)
   - [Ubuntu](#ubuntu)
   - [Windows](#windows)
4. [Configuración de la conexión](#configuración-de-la-conexión)
5. [Estructura del repositorio](#estructura-del-repositorio)
6. [Convención de nombres](#convención-de-nombres)
7. [Comandos principales](#comandos-principales)
8. [Cargar la base de datos](#cargar-la-base-de-datos)
   - [Rol DBA](#rol-dba)
   - [Desarrollador Backend](#desarrollador-backend)
9. [Tabla de historial](#tabla-de-historial)

---

## Diseño de base de datos

Antes de escribir cualquier script SQL o aplicar migraciones con Flyway, se sigue un flujo de diseño estructurado en tres etapas:

**1. Modelo Conceptual**
Se identifican las entidades del negocio, sus atributos y las relaciones entre ellas. Consiguiendo asi el diagrama entidad relacion.

**2. Modelo Lógico**
Se transforma el modelo conceptual en tablas, columnas, tipos de datos, claves primarias y claves foráneas.

**3. Modelo Físico**
Se traduce el modelo lógico a scripts SQL específicos para PostgreSQL. Estos scripts son los que se versionan con Flyway en la carpeta `migraciones/`.


---

## Flyway

Flyway es una herramienta de versionamiento y migración de bases de datos. Que nos permite gestionar los cambios en el esquema de una base de datos de forma ordenada, reproducible y rastreable.

---

## Instalación

### Ubuntu

1. Descargar el paquete tar desde la página oficial:

```bash
https://www.red-gate.com/products/flyway/community/download/
```

2. Estraer el archivo .gz ya sea desde editor o con comando de consola

3. Agregar la direccion de la carpeta comprimida editando `~/.bashrc`:

```bash
nano ~/.bashrc

ejemplo de un path: /home/flyway/FlywayDesktopLinuxX64_9.1.0.0
```

4. Aplicar los cambios:

```bash
source ~/.bashrc
```

5. Verificar la instalación:

```bash
flyway -v
```

---

### Windows

1. Descargar el archivo `.zip` desde: https://flywaydb.org/download/community

2. Descomprimir en una ruta como `C:\flyway`

3. Agregar al PATH del sistema:
   - Ir a Panel de control LUEGO  Sistema LUEGO Configuración avanzada del sistema LUEGO Variables de entorno**
   - En Variables del sistema, editar `Path` y agregar `C:\flyway`

4. Verificar la instalación abriendo una terminal (`cmd` o PowerShell):

```powershell
flyway -v
```

---

## Configuración de la conexión

Dentro de la carpeta de Flyway, editar el archivo `conf/flyway.conf`:

```properties
flyway.url=jdbc:postgresql://localhost:5432/sgea_db
flyway.user=aca_usuario
flyway.password=aca_contraseña
flyway.locations=filesystem:/ruta/al/repo/migraciones
```

---

## Estructura del repositorio

```
repo/
├── docs/
├── diagramas/
└── migraciones/
    ├── V1__s1_schema_inicial.sql
```

---

## Convención de nombres

Los archivos deben seguir este formato:

```
V{version}__{sprint}_{descripcion}.sql
```

Ejemplos:

```
V1__s1_schema_inicial.sql
V2__s2_crear_tabla_curso.sql
```

> **Importante:** La `V` siempre debe ser mayúscula. Si se escribe en minúscula, Flyway ignora el archivo sin advertencia.

---

## Comandos principales

| Comando | Descripción |
|---|---|
| `flyway migrate` | Aplica las migraciones pendientes |
| `flyway info` | Muestra el estado de todas las migraciones |
| `flyway validate` | Verifica que los scripts no hayan sido modificados |
| `flyway repair` | Repara la tabla de historial ante fallos |

---

## CARGAR LA BASE DE DATOS

### Rol DBA

El DBA es responsable de crear y versionar los scripts SQL. Su flujo de trabajo es:

1. Crear o modificar scripts en la carpeta `migraciones/` siguiendo la convención de nombres.
2. Verificar el estado actual de las migraciones:

```bash
flyway info
```

3. Aplicar las migraciones pendientes:

```bash
flyway migrate
```

4. Validar que ningún script ya aplicado haya sido modificado:

```bash
flyway validate
```

> **IMPORTANTE:** Nunca modificar un script que ya fue aplicado. Cualquier cambio debe hacerse en un archivo nuevo con la siguiente versión.

---

### Desarrollador Backend

#### 1 — Clonar el repositorio de la base de datos

```bash
git clone git@github.com:piti-codenbugs/sgea-db.git
```

#### 2 — Crear la base de datos vacía

En la carpeta scripts se encuentra db_creation.sql ejecutarlo con las opciones

**terminal:**
```bash
psql -U postgres -f scripts/db_creation.sql
```

**pgAdmin**
1. Abrir pgAdmin
2. Click derecho en Databases DESPUE Create DESPUES Database**
3. Escribir `sgea_db` y guardar


**Para manejo de la base de datos con Spring Boot**:

1. Agregar la dependencia en el `pom.xml`:

```xml
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
```

2. Configurar la conexión en `application.properties`:

** COMO PASO IMPORTANTE AGREGAR EN spring.flyway.location LA RUTA DONDE ESTAN LAS MIGRACIONES ESTO PARA QUE FLYWAY DETECTE LOS CAMBIOS AL HACER PULL
 
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/sgea_db
spring.datasource.username=usuario_aca
spring.datasource.password=contraseña_aca
spring.flyway.enabled=true
spring.flyway.locations=filesystem:/ruta-donde-se-clono-el-repo/migraciones
```

#### Iniciar la aplicación

Al iniciar, Flyway lee los scripts directamente del repo del DBA y crea todas las tablas automáticamente. No se requiere ninguna acción manual.

---

#### Para cada nuevo sprint

Cuando el DBA suba nuevos scripts al repositorio, el backend solo debe de hacer en el repositorio clonado:

```
1. git pull 
2. Iniciar la app y Flyway aplica los cambios automáticamente
```

> **IMPORTANTE:** No modificar los archivos SQL. Si se necesita un cambio en el esquema, solicitarlo al DBA para que cree una nueva migración esto para mantener lo mismo del repositoro.

---

## Tabla de historial

Flyway crea automáticamente una tabla llamada `flyway_schema_history` en la base de datos. Esta tabla registra cada migración aplicada con su versión, descripción, fecha de ejecución y checksum. No debe modificarse manualmente.
