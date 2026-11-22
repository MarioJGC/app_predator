# PRD — App Cazador

**Versión:** 0.1 (borrador) · **Fecha:** 17/11/2026 · **Estado:** en definición
**Documento técnico relacionado:** [ARQUITECTURA.md](ARQUITECTURA.md)

> Este documento define **qué** se construye y **por qué**. El **cómo** (stack, modelo de datos, sincronización) está en `ARQUITECTURA.md`.
> Los puntos marcados con **[validar]** son supuestos que hay que confirmar con usuarios reales antes o durante el piloto.

---

## 1. Resumen

App Cazador es una app móvil para cazadores y organizadores de caza en España. Sirve para:

- guardar sus **zonas de caza** (áreas, rutas y puntos de interés) en un mapa,
- **compartirlas** de forma controlada con personas o grupos,
- **coordinar jornadas** (monterías, batidas, salidas en grupo) con puestos asignados y ubicación en vivo,
- **registrar capturas**.

Todo ello **funciona sin cobertura** y está pensado para personas mayores o poco habituadas a la tecnología.

## 2. Problema

| # | Problema actual | Consecuencia |
|---|---|---|
| P1 | Las zonas, los puestos y los accesos se explican de palabra, con fotos o con ubicaciones sueltas por WhatsApp | Gente perdida, retrasos y puestos mal ocupados |
| P2 | En el monte no hay cobertura y las apps de mapas habituales dejan de funcionar | El cazador no sabe dónde está ni cómo llegar a su puesto |
| P3 | El organizador no sabe dónde está cada cazador durante la jornada | **Riesgo de seguridad**: disparos hacia zonas ocupadas, dificultad para localizar a alguien herido |
| P4 | Compartir una zona implica perder el control sobre ella (se reenvía sin límite) | Los dueños de cotos y los cazadores no comparten, o lo hacen con desconfianza |
| P5 | Las apps existentes son complejas, con letra pequeña y menús ocultos **[validar]** | El usuario objetivo las abandona |

## 3. Usuarios objetivo

| Perfil | Descripción | Necesidad principal |
|---|---|---|
| **Cazador** (usuario principal) | Hombre de 45–75 años **[validar]**, móvil Android de gama media, usa WhatsApp a diario y poco más | Saber dónde tiene que ir y llegar sin perderse, aunque no haya señal |
| **Organizador / responsable de cuadrilla** | Organiza monterías o salidas y asigna puestos | Repartir puestos rápido y ver a todos durante la jornada |
| **Dueño o gestor de coto** | Gestiona un terreno y a quién deja entrar | Compartir el coto con control (quién, qué ve y hasta cuándo) |

**Contexto de uso:** al aire libre, con luz solar intensa, a veces con guantes, con poca batería y casi siempre **sin cobertura**.

## 4. Objetivos y métricas de éxito

| Objetivo | Métrica | Meta del piloto **[validar]** |
|---|---|---|
| Que la app sea útil en una jornada real | Jornadas completadas con ≥3 participantes | ≥ 20 jornadas en los 3 primeros meses |
| Que sea fácil para el usuario objetivo | % de invitados que se registran y aceptan la invitación sin ayuda | ≥ 70 % |
| Que funcione sin cobertura | % de jornadas sin errores de mapa en modo sin conexión | ≥ 95 % |
| Que no agote la batería | Batería consumida en 3 h de jornada compartiendo ubicación | ≤ 20 % |
| Retención | Usuarios que vuelven a usar la app en una segunda jornada | ≥ 50 % |
| Crecimiento orgánico | Usuarios nuevos que llegan por un enlace de invitación | ≥ 60 % |

**No es objetivo del MVP:** ganar dinero. La monetización llega en la fase 2.

## 5. Alcance

### 5.1 Dentro del MVP

1. Registro e inicio de sesión con el número de teléfono (código por SMS).
2. Crear zonas (área dibujada o ruta grabada) y puntos dentro de ellas.
3. Descargar el mapa de una zona para usarlo sin conexión.
4. Compartir zonas mediante un enlace (WhatsApp) con distintos niveles de permiso y caducidad.
5. Grupos (cuadrillas) con un código de 6 dígitos.
6. Jornada en vivo: crear la jornada, asignar puestos, «Llévame a mi puesto», ver posiciones en vivo y botón SOS.
7. Registro de capturas con foto.
8. Borrar la cuenta y todos sus datos.
9. Solo Android.
10. Interfaz en **español e inglés**.

### 5.2 Fuera del MVP

| Funcionalidad | Fase prevista |
|---|---|
| Suscripciones y plan de coto de pago | Fase 2 |
| Panel web del organizador | Fase 2 |
| Avisos por voz | Fase 2 |
| iOS / App Store | Fase 3 (o antes si el piloto lo exige) |
| Navegación paso a paso dentro de la app (se abre Google Maps o Waze) | No previsto |
| Red social, chat o mensajería propia (se usa WhatsApp) | No previsto |
| Licencias, normativa de vedas o seguros | No previsto **[validar]** |

## 6. Requisitos funcionales

Prioridad: **M** = imprescindible para el MVP · **D** = deseable en el MVP · **F2** = fase 2.

### 6.1 Cuenta y acceso (`auth`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-01 | El usuario se registra con su número de teléfono y un código de 6 dígitos recibido por SMS. Sin contraseñas | M |
| RF-02 | En el registro solo se pide el nombre visible | M |
| RF-03 | La sesión se mantiene abierta indefinidamente en el móvil, sin volver a pedir el código | M |
| RF-04 | El teléfono de un usuario nunca se muestra a otros usuarios | M |
| RF-05 | «Borrar mi cuenta» elimina todos sus datos, con una confirmación grande Sí/No | M |

### 6.2 Zonas y puntos (`zonas`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-10 | Crear una zona de tipo **área**, dibujando un polígono sobre el mapa | M |
| RF-11 | Crear una zona de tipo **ruta**, grabándola con el GPS mientras se camina | M |
| RF-12 | Cada zona tiene nombre, descripción, especies, modalidad y una foto opcional | M |
| RF-13 | Añadir puntos a una zona: puesto (numerado), coche/aparcamiento, comedero, peligro y otro | M |
| RF-14 | Solo el creador puede editar o borrar su zona | M |
| RF-15 | Botón «Cómo llegar», que abre Google Maps o Waze con el punto de acceso | M |
| RF-16 | Todo se puede crear y editar sin conexión y se sincroniza solo al recuperar la señal | M |
| RF-17 | Mapa con vista satélite (ortofoto) y topográfica | M |

### 6.3 Mapas sin conexión (`mapas_offline`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-20 | Al guardar o recibir una zona, la app ofrece «Descargar mapa de esta zona» e indica el tamaño aproximado | M |
| RF-21 | El mapa descargado funciona en modo avión, con la posición GPS del usuario | M |
| RF-22 | Lista de mapas descargados con su espacio ocupado y opción para borrarlos | D |
| RF-23 | Aviso si se va a empezar una jornada en una zona sin mapa descargado | M |

### 6.4 Compartir (`compartir`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-30 | Compartir una zona con un enlace a través del menú de compartir del móvil (WhatsApp primero) | M |
| RF-31 | Niveles de permiso: **ver**, **seguir** (ver y navegar) y **editar** | M |
| RF-32 | Caducidad opcional del permiso (un día, una temporada o sin caducidad) | M |
| RF-33 | Si el invitado no tiene la app, el enlace lo lleva a Google Play y la invitación se aplica al registrarse | M |
| RF-34 | El creador ve con quién ha compartido cada zona y puede retirar el acceso | M |
| RF-35 | Compartir con un grupo completo | M |

### 6.5 Grupos (`grupos`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-40 | Crear un grupo (cuadrilla o coto) con nombre | M |
| RF-41 | Unirse a un grupo con un enlace o con un **código de 6 dígitos** que se puede dictar por teléfono | M |
| RF-42 | Roles: dueño, responsable (puede organizar jornadas) y miembro | M |
| RF-43 | El dueño puede expulsar miembros y cambiar sus roles | M |

### 6.6 Jornada en vivo (`jornada`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-50 | El dueño o un responsable crea una jornada eligiendo un grupo y una zona | M |
| RF-51 | Los miembros reciben una notificación y pulsan «Me uno» | M |
| RF-52 | El organizador asigna un puesto a cada cazador | M |
| RF-53 | El cazador ve «Tu puesto: nº X» y el botón **«Llévame»**, que lo guía sobre el mapa, también sin conexión | M |
| RF-54 | Durante la jornada, el organizador ve en el mapa la posición de todos los participantes | M |
| RF-55 | Los participantes ven a los demás en el mapa **[validar: ¿todos o solo el organizador?]** | D |
| RF-56 | Solo se comparte la ubicación mientras la jornada está activa. Se muestra un aviso permanente mientras tanto | M |
| RF-57 | Botón **SOS**, que envía un aviso urgente con la ubicación al organizador y a los participantes | M |
| RF-58 | Sin cobertura, las posiciones se guardan en el móvil y se envían al volver la señal | M |
| RF-59 | La jornada se cierra sola a las 12 h si nadie la termina | M |

### 6.7 Capturas (`capturas`)

| ID | Requisito | Prioridad |
|---|---|---|
| RF-60 | Registrar una captura con especie, cantidad, foto opcional y ubicación | M |
| RF-61 | La captura queda asociada a la jornada si se registra durante una | M |
| RF-62 | Historial personal de capturas | D |
| RF-63 | Resumen de capturas de la jornada para el organizador | D |
| RF-64 | Exportar las capturas (CSV/PDF) | F2 |

## 7. Historias de usuario clave y criterios de aceptación

**HU-1 · Llegar a mi puesto sin cobertura**
*Como cazador, quiero que la app me lleve a mi puesto aunque no haya señal, para no perderme ni llegar tarde.*
- [ ] Con el mapa descargado y el móvil en modo avión, se ven el mapa, mi posición y mi puesto.
- [ ] «Llévame» muestra la dirección y la distancia hasta el puesto.
- [ ] No aparece ningún error ni pantalla de carga infinita por falta de red.

**HU-2 · Unirme por WhatsApp**
*Como cazador invitado, quiero tocar un enlace de WhatsApp y entrar a la zona, sin pasos complicados.*
- [ ] Sin la app instalada: enlace → Google Play → instalación → registro por SMS → la zona aparece sin hacer nada más.
- [ ] Con la app instalada: el enlace abre la app y pide una única confirmación.
- [ ] El proceso completo lleva menos de 3 minutos **[validar con usuarios]**.

**HU-3 · Organizar una montería**
*Como organizador, quiero asignar los puestos y ver a todos en el mapa, para que la jornada sea segura.*
- [ ] Puedo asignar 20 puestos en menos de 5 minutos.
- [ ] Cada cazador recibe su puesto en una notificación.
- [ ] Veo la posición de cada participante actualizada (≤ 30 s de retraso cuando hay señal).
- [ ] Al terminar la jornada, nadie sigue compartiendo su ubicación.

**HU-4 · Pedir ayuda**
*Como cazador, quiero pedir ayuda con un solo botón si tengo un accidente.*
- [ ] El botón SOS está siempre visible durante la jornada y pide una confirmación grande para evitar pulsaciones accidentales.
- [ ] El organizador recibe una notificación urgente con mi última ubicación conocida.

**HU-5 · Compartir mi coto con control**
*Como dueño de coto, quiero compartir mi zona solo durante un día y con solo lectura, para no perder el control.*
- [ ] Puedo elegir el nivel «ver» y la caducidad «un día».
- [ ] Pasada la caducidad, el invitado deja de ver la zona.
- [ ] Puedo retirar el acceso en cualquier momento.

## 8. Requisitos no funcionales

| ID | Categoría | Requisito |
|---|---|---|
| RNF-01 | Sin conexión | Todas las funciones, salvo invitar y registrarse, funcionan sin red. La app nunca bloquea al usuario esperando a la red |
| RNF-02 | Accesibilidad | Letra base de 18 pt que respeta el tamaño del sistema (hasta 1,5×). Botones de al menos 56 px. Contraste AA. Compatible con TalkBack |
| RNF-03 | Simplicidad | Navegación con 4 pestañas fijas y sin menús ocultos. Toda acción destructiva pide confirmación Sí/No |
| RNF-04 | Batería | ≤ 20 % en 3 h de jornada compartiendo ubicación, en un Android de gama media |
| RNF-05 | Rendimiento | Arranque en ≤ 3 s y mapa fluido en Android de gama media (≈ 3 GB de RAM, Android 10 o superior) **[validar]** |
| RNF-06 | Privacidad (RGPD) | Datos alojados en la UE. Consentimiento explícito para la ubicación en segundo plano. Las posiciones se borran a los 7 días. Fotos sin EXIF |
| RNF-07 | Seguridad | Permisos comprobados en el servidor. Límite de intentos de SMS por número y por IP |
| RNF-08 | Coste | Infraestructura de 30–50 €/mes durante el piloto (hasta 500 usuarios) |
| RNF-09 | Idiomas | Español de España (idioma principal) e inglés. La app usa el idioma del móvil; si no es ninguno de los dos, español. Ningún texto visible escrito directamente en el código: todo va en archivos de traducción. Sin anglicismos en la versión española |

## 9. Fases y entregas

| Fase | Contenido | Criterio de salida |
|---|---|---|
| **Sprint 0: pruebas técnicas** | Mapas sin conexión con MapLibre + IGN · posiciones en vivo con 3 móviles · login por SMS | Las 3 pruebas funcionan en dispositivos reales |
| **MVP (piloto)** | Todo lo de la sección 5.1 | 1–3 cuadrillas reales completan jornadas sin ayuda del equipo |
| **Fase 2** | Pagos (plan de coto), panel web del organizador, avisos por voz, exportar capturas | Primeros clientes de pago |
| **Fase 3** | iOS / App Store | — |

Orden propuesto de construcción del MVP (una rama `feature/*` por línea):

1. `feature/estructura-base`: monorepo, tema accesible, navegación con 4 pestañas, traducciones español/inglés (RNF-09)
2. `feature/auth-telefono`: RF-01 a RF-05
3. `feature/zonas`: RF-10 a RF-17
4. `feature/mapas-offline`: RF-20 a RF-23
5. `feature/sincronizacion`: RF-16, RNF-01
6. `feature/grupos`: RF-40 a RF-43
7. `feature/compartir`: RF-30 a RF-35
8. `feature/jornada`: RF-50 a RF-59
9. `feature/capturas`: RF-60 a RF-63

## 10. Supuestos y riesgos

| # | Riesgo / supuesto | Impacto | Mitigación |
|---|---|---|---|
| R1 | Las teselas del IGN no se pueden servir en masa sin permiso | Alto | Revisar las condiciones de uso. La alternativa es MapTiler (de pago) |
| R2 | El GPS en segundo plano gasta demasiada batería o Android lo cierra | Alto | Prueba de 3 h en el sprint 0. Opción de cambiar a `flutter_background_geolocation` |
| R3 | Los usuarios mayores no completan el registro por SMS | Medio | Pruebas con usuarios reales y el código de 6 dígitos como alternativa |
| R4 | El coste de los SMS se dispara (fraude o crecimiento) | Medio | Proveedor barato u OTP por WhatsApp, y límites de intentos |
| R5 | Se asume que la mayoría de los usuarios tiene Android | Medio | Preguntar en el piloto antes de decidir cuándo llega iOS |

## 11. Preguntas abiertas

1. ¿Los participantes de una jornada se ven entre sí o solo los ve el organizador? (RF-55)
2. ~~¿Qué cuatro pestañas fijas habrá?~~ **Decidido:** Mapa · Mis zonas · Grupos · Jornada. Mientras no haya backend, «Jornada» muestra «Mis capturas».
3. Nombre comercial y dominio definitivos (afecta a los enlaces de invitación).
4. Proveedor de SMS: Twilio, Prelude/Vonage o WhatsApp.
5. ¿Cuáles serán las cuadrillas o cotos del piloto y en qué provincias? (Determina qué mapas se precargan.)
6. ¿Hace falta algún aviso legal sobre normativa de caza o seguros?
7. ¿Quién es el público en inglés: cazadores extranjeros que vienen a cazar a España, o salir a otros países? Si es lo segundo, la cartografía del IGN solo cubre España y habría que añadir otra fuente de mapas.

## 12. Glosario

- **Zona:** área o ruta guardada en el mapa.
- **Punto:** lugar concreto dentro de una zona (puesto, coche, comedero, peligro…).
- **Jornada:** evento de caza en grupo con hora de inicio y fin, durante el que se comparte la ubicación.
- **Puesto:** posición numerada donde se coloca un cazador en una montería.
- **Montería / batida:** modalidades de caza en grupo con puestos y perros.
- **Cuadrilla:** grupo habitual de cazadores.
- **Coto:** terreno de caza acotado y gestionado.
