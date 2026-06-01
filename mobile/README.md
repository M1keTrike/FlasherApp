# Flasher — Mobile (Flutter)

App móvil de flashcards construida con **Flutter** siguiendo
**Clean Architecture + Screaming Architecture + Vertical Slicing**, con **MVVM**
por cada feature. Consume la API de `backend/`.

---

## Stack y restricciones (rúbrica)

- **Flutter** + **Material 3** (`useMaterial3: true`)
- **Provider** para gestión de estado
- Paquete **http** como cliente HTTP (no dio)
- **Inyección de dependencias manual** (sin get_it / injectable)
- **Navigation 1.0** (Navigator imperativo + rutas nombradas)

---

## Arquitectura

```
lib/
  main.dart                    # MultiProvider + MaterialApp + rutas
  core/
    config/                    # ApiConfig (base URL)
    di/                        # CompositionRoot (inyección manual)
    network/                   # ApiClient (http), TokenStore, ApiException
    routing/                   # AppRoutes + AppRouter (Navigation 1.0)
    theme/                     # AppTheme (Material 3, ColorScheme.fromSeed)
  features/
    auth/
      data/                    # datasource http, UserModel, repo impl
      domain/                  # User, AuthRepository (contrato), use cases
      presentation/            # AuthViewModel, LoginView, RegisterView
    flashcards/
      data/                    # datasource http (CRUD), FlashcardModel, repo impl
      domain/                  # Flashcard, FlashcardRepository, use cases
      presentation/            # FlashcardsViewModel + List/Form/Study views
```

**Principios aplicados:**

- **Screaming Architecture:** `features/` (auth, flashcards) revela el dominio
  de la app a primera vista.
- **Vertical Slicing:** cada feature es autocontenida (data/domain/presentation)
  y no se mezcla con las demás.
- **Clean Architecture:** las dependencias apuntan al dominio. `domain` define
  contratos abstractos (`AuthRepository`, `FlashcardRepository`) que `data`
  implementa. El dominio no conoce ni a `data` ni a `presentation`.
- **MVVM:** cada View consume un ViewModel (`ChangeNotifier`) expuesto con
  Provider. La View no contiene lógica de negocio.

**Flujo de una acción** (ej. crear flashcard):

```
View → ViewModel → UseCase → Repository (contrato)
        → RepositoryImpl → RemoteDataSource → ApiClient (http) → API
```

---

## Inyección de dependencias manual

`core/di/composition_root.dart` arma todo el grafo a mano y en orden
`datasource → repository → usecases → viewmodel`, y expone los ViewModels como
providers para `MultiProvider` en `main.dart`. No se usan service locators ni
paquetes de DI.

---

## Cliente HTTP

`core/network/api_client.dart` envuelve el paquete `http` e implementa los
cuatro verbos: **GET**, **POST**, **PUT**, **DELETE**. Adjunta automáticamente
`Authorization: Bearer <token>` cuando hay sesión y traduce los status codes
(401, 404, 409, 500…) a mensajes amigables (`ApiException`) que la UI muestra en
snackbars.

| Verbo | Dónde se usa |
|-------|--------------|
| POST | `/auth/login`, `/auth/register`, crear flashcard |
| GET | listar flashcards |
| PUT | editar flashcard |
| DELETE | eliminar flashcard |

---

## Cómo ejecutar

```bash
cd mobile
flutter pub get
flutter run            # en un emulador o dispositivo
```

### Base URL

Por defecto apunta a producción:
`https://flasherapi.alphahills.site` (ver `lib/core/config/api_config.dart`).

Para probar contra un backend local, cámbiala temporalmente a:

- **Emulador Android:** `http://10.0.2.2:3000`
- **iOS / web / desktop:** `http://localhost:3000`

---

## Pantallas

- **LoginView / RegisterView** — formularios validados, spinner de carga,
  errores en snackbar.
- **FlashcardsListView** — `Card` + `ListTile`, FAB para crear, editar/eliminar
  (con diálogo de confirmación), estados vacío/carga/error, pull-to-refresh.
- **FlashcardFormView** — misma pantalla para crear y editar.
- **StudyView** — modo estudio con **animación de volteo 3D** de la tarjeta
  (pregunta → respuesta).
