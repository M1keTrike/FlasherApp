# Flasher — Backend (NestJS)

API RESTful para la app de flashcards **Flasher**. Construida con NestJS +
TypeORM + PostgreSQL, y desplegable en EC2 detrás de Nginx con SSL de
Let's Encrypt (Certbot).

Dominio de producción: **https://flasherapi.alphahills.site**

---

## Stack

- **NestJS** (TypeScript)
- **TypeORM** + **PostgreSQL 16**
- **JWT** (`@nestjs/jwt` + `passport-jwt`) + **bcrypt**
- **class-validator / class-transformer** para validación y serialización
- **Docker Compose**: `db`, `api`, `nginx`, `certbot`
- **Nginx** como reverse proxy con terminación SSL

---

## Estructura

```
backend/
  src/
    main.ts                 # bootstrap: CORS, ValidationPipe, ClassSerializer
    app.module.ts           # ConfigModule + TypeOrmModule + módulos de feature
    health/                 # GET /health
    users/                  # entidad User + UsersService
    auth/                   # register/login, JWT strategy, guard
    flashcards/             # CRUD de flashcards (protegido con JWT)
  Dockerfile                # build multi-etapa (build -> runtime)
  docker-compose.yml        # db + api + nginx + certbot
  nginx/
    conf.d/flasher.conf     # config final (80 + 443)
    bootstrap/              # config temporal solo-80 para la 1ª emisión SSL
  certbot/                  # certificados (conf) y webroot del challenge (www)
  .env.example
```

---

## Endpoints

### Salud
| Método | Ruta | Respuesta |
|--------|------|-----------|
| GET | `/health` | `{ "status": "ok" }` |

### Autenticación (públicos)
| Método | Ruta | Body | Respuesta |
|--------|------|------|-----------|
| POST | `/auth/register` | `{ name, email, password }` | `{ accessToken, user }` |
| POST | `/auth/login` | `{ email, password }` | `{ accessToken, user }` |

### Flashcards (requieren `Authorization: Bearer <token>`)
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/flashcards` | Lista las flashcards del usuario autenticado |
| GET | `/flashcards/:id` | Una flashcard del usuario |
| POST | `/flashcards` | Crea (`{ question, answer, category }`) |
| PUT | `/flashcards/:id` | Actualiza |
| DELETE | `/flashcards/:id` | Elimina (204) |

Códigos de estado: `201` creación, `200` lectura/actualización, `204` borrado,
`401` sin token, `404` recurso inexistente, `409` email ya registrado.

---

## Desarrollo local

```bash
cd backend
cp .env.example .env          # ajusta credenciales si quieres
npm install

# Necesitas un Postgres accesible. La forma más rápida:
docker compose up -d db       # levanta solo la base de datos

# Apunta la app a ese Postgres (DB_HOST=localhost si corres fuera de Docker)
npm run start:dev
```

La API escucha en el puerto `3000`.

Prueba rápida:

```bash
curl http://localhost:3000/health
# {"status":"ok"}

curl -X POST http://localhost:3000/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"name":"Ada","email":"ada@example.com","password":"secret123"}'
```

---

## Despliegue en EC2

### 1. Prerrequisitos

- Una instancia EC2 (Ubuntu) con Docker y el plugin de Docker Compose.
- El dominio **flasherapi.alphahills.site** apuntando (registro **A**) a la IP
  pública de la instancia.
- En el **Security Group**, abrir los puertos **80** y **443** (entrada).

### 2. Clonar y configurar

```bash
git clone <repo> FlasherApp
cd FlasherApp/backend
cp .env.example .env
nano .env        # define DB_PASSWORD y JWT_SECRET reales
```

### 3. Primera emisión del certificado SSL

Nginx no arranca con el bloque `443` si el certificado todavía no existe, así
que la primera vez se usa una config temporal solo en el puerto 80:

```bash
# a) Usar la config temporal (solo puerto 80, sirve el ACME challenge)
mv nginx/conf.d/flasher.conf nginx/conf.d/flasher.conf.disabled
cp nginx/bootstrap/flasher-bootstrap.conf nginx/conf.d/

# b) Levantar la base, la API y nginx
docker compose up -d db api nginx

# c) Emitir el certificado con Certbot en modo webroot (una sola vez)
docker compose run --rm certbot certonly --webroot \
  -w /var/www/certbot -d flasherapi.alphahills.site \
  --email TU_CORREO@example.com --agree-tos --no-eff-email

# d) Restaurar la config completa (80 + 443) y recargar nginx
rm nginx/conf.d/flasher-bootstrap.conf
mv nginx/conf.d/flasher.conf.disabled nginx/conf.d/flasher.conf
docker compose up -d        # levanta todo, incluido certbot (auto-renovación)
docker compose exec nginx nginx -s reload
```

### 4. Verificar

```bash
curl https://flasherapi.alphahills.site/health
# {"status":"ok"}
```

A partir de aquí el servicio `certbot` renueva el certificado automáticamente
(loop con `certbot renew` cada ~12h) y nginx lo recoge en cada recarga.

---

## Notas

- La **API no expone puertos al host**: solo es accesible por la red interna de
  Docker, a través de nginx (puertos 80/443).
- `synchronize: true` en TypeORM crea el esquema automáticamente (adecuado para
  este proyecto; en producción real se usarían migraciones).
- El campo `password` nunca se devuelve en las respuestas gracias a `@Exclude()`
  + `ClassSerializerInterceptor`.
