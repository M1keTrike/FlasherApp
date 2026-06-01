# FlasherApp

Monorepo de **Flasher**, una app de tarjetas de estudio (flashcards). Cada
usuario gestiona sus propias tarjetas con pregunta, respuesta y categoría.

El proyecto tiene dos subproyectos independientes pero conectados:

| Carpeta | Qué es | Tecnología |
|---------|--------|------------|
| [`backend/`](backend/README.md) | API RESTful + infraestructura de despliegue | NestJS · TypeORM · PostgreSQL · Docker · Nginx · Certbot |
| [`mobile/`](mobile/README.md) | App móvil | Flutter · Clean Architecture + MVVM · Provider · http |

```
FlasherApp/
  README.md          ← este archivo
  backend/           ← API NestJS + Docker Compose (db, api, nginx, certbot)
  mobile/            ← App Flutter (Clean Architecture + MVVM)
```

La API se despliega en EC2 detrás de Nginx con SSL de Let's Encrypt en
**https://flasherapi.alphahills.site**. La carpeta `mobile/` **no** se despliega
en el servidor; es la app cliente que consume esa API.

---

## Arquitectura general

```
┌─────────────────────────┐         HTTPS          ┌──────────────────────────┐
│   App Flutter (mobile/)  │  ───────────────────▶  │  Nginx (reverse proxy)   │
│  Clean Arch + MVVM       │   Bearer JWT           │  + SSL (Let's Encrypt)    │
│  Provider · http         │  ◀───────────────────  │           │              │
└─────────────────────────┘                         │           ▼              │
                                                     │  API NestJS (:3000)      │
                                                     │  Auth · Users · Cards    │
                                                     │           │              │
                                                     │           ▼              │
                                                     │  PostgreSQL (db)         │
                                                     └──────────────────────────┘
```

---

## Cómo correr cada parte

### Backend (API)

```bash
cd backend
cp .env.example .env
npm install
docker compose up -d db      # solo la base de datos para desarrollo
npm run start:dev            # API en http://localhost:3000
```

Despliegue completo en EC2 (incluida la emisión del certificado SSL): ver
[`backend/README.md`](backend/README.md).

### Mobile (app)

```bash
cd mobile
flutter pub get
flutter run
```

Configuración de la base URL: ver [`mobile/README.md`](mobile/README.md).

---

## Modelo de datos

**User**: `id` (UUID), `name`, `email` (único), `password` (bcrypt, nunca se
devuelve), `createdAt`.

**Flashcard**: `id` (UUID), `question`, `answer`, `category`,
`user` (ManyToOne), `createdAt`, `updatedAt`.

Cada flashcard pertenece a un usuario; un usuario solo ve/edita/elimina sus
propias tarjetas (filtrado por el usuario del JWT en el backend).

---

## Plan de ejecución (cumplido)

- **Fase 1 — Fundación + Autenticación:** scaffolding del backend y la app,
  infraestructura Docker/Nginx/Certbot, registro/login con JWT + bcrypt,
  navegación a la home tras autenticarse.
- **Fase 2 — CRUD de Flashcards:** entidad y módulo de flashcards protegidos
  por JWT, y la app con lista, formulario crear/editar, borrado con
  confirmación y modo estudio con animación de volteo.

Documentación de apoyo para el informe: [`docs/INFORME.md`](docs/INFORME.md)
y los prompts representativos en [`docs/PROMPTS.md`](docs/PROMPTS.md).
