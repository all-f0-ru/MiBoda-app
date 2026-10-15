# MiBoda+ · Tu boda, sin el caos

App móvil en Flutter para planificar bodas en Chile, con dos perfiles: **novios** (planifican) y **proveedores** (reciben y responden cotizaciones).

Esta primera versión es **solo interfaz**: todas las pantallas del diseño, navegables y con datos de ejemplo, listas para conectar un backend (Firebase o Supabase) más adelante.

## Cómo correrla

Requisitos: Flutter 3.22 o superior.

```bash
git clone https://github.com/all-f0-ru/MiBoda-app.git
cd MiBoda-app
flutter create . --org cl.miboda --project-name miboda_app   # genera android/ e ios/ la primera vez
flutter pub get
dart run flutter_launcher_icons   # instala el ícono de la app (corazón +)
flutter run
```

> `flutter create .` solo agrega las carpetas de plataforma que faltan; no toca `lib/` ni `pubspec.yaml`. Si te pregunta por `test/widget_test.dart`, puedes borrarlo.

## Qué incluye

**Acceso y onboarding**
- Splash, iniciar sesión (con estado de error si la contraseña tiene menos de 6 caracteres), selección de rol.
- Onboarding de novios: fecha (con "Aún no tenemos fecha"), comuna, invitados y presupuesto.

**Novios** (barra inferior: Inicio, Proveedores, Checklist, Invitados, Perfil)
- **Inicio:** cuenta regresiva real hasta el 13 de marzo de 2027, presupuesto, proveedores por categoría, próximas tareas e invitados.
- **Proveedores:** búsqueda (con estado de carga), categorías, filtros en bottom sheet, filtro de precio que muestra el estado "sin resultados", favoritos con corazón animado.
- **Perfil de proveedor:** galería deslizable, paquetes, calendario de disponibilidad con la fecha de la boda, reseñas.
- **Cotización completa:** solicitar → conversación → aceptar, rechazar (con motivo) o pedir cambios → confirmación → presupuesto.
- **Presupuesto:** pagos próximos, desglose por categoría (con categoría excedida), registrar pago y agregar gasto.
- **Checklist:** tareas por etapa, marcar y desmarcar, filtros, agregar tarea propia.
- **Invitados:** lista con RSVP, filtros por grupo, agregar invitado, enviar invitaciones por WhatsApp y **plano de mesas** (toca un invitado y luego una mesa).
- **Perfil:** co-planificadores, accesos y cerrar sesión.

**Proveedor** (barra inferior: Panel, Solicitudes, Calendario, Mensajes, Reseñas)
- Panel con métricas, solicitudes por estado, detalle de solicitud, crear cotización por paquete, calendario editable (disponible / reservado / bloqueado) y respuesta a reseñas.

**Estados**: carga, vacío (mensajes, resultados), error de login y sin conexión (`Routes.offline`).

## Ícono de la app

Corazón formado por dos arcos (como dos anillos que se juntan) y el "+" de la marca, en bronce. Archivos en `assets/icon/`:

| Archivo | Uso |
|---|---|
| `app_icon.svg` / `.png` | Ícono principal, fondo crema (iOS, Android, web) |
| `app_icon_dark.svg` / `.png` | Variante fondo tinta (modo oscuro, splash, redes) |
| `app_icon_foreground.svg` / `.png` | Capa frontal del ícono adaptable de Android (sin fondo) |

Los PNG son de 1024 × 1024. El logo grande dentro de la app sigue siendo el símbolo de anillos con gemas.

## Estructura

```
lib/
├── main.dart · app.dart · routes.dart
├── theme/        colores, tipografía (Fraunces + Work Sans), espaciado y tema
├── data/         modelos y datos de ejemplo (mock_data.dart)
├── state/        AppState: favoritos, tareas, cotización, pagos, mesas, calendario
├── navigation/   barras inferiores de novios y proveedor
├── widgets/      componentes del design system (botones, chips, tarjetas, filas, sheets)
└── screens/      auth/ · couple/ · vendor/ · states/
```

## Próximos pasos sugeridos

1. Conectar autenticación (Firebase Auth o Supabase Auth) en `login_screen.dart`.
2. Reemplazar `data/mock_data.dart` por repositorios que lean de la base de datos.
3. Mover `AppState` a un manejador de estado (Riverpod o Bloc) cuando haya datos reales.
4. Fotos reales de proveedores (hoy son bloques de color).
5. Envío real por WhatsApp con `url_launcher` y links de RSVP.
