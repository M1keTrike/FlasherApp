import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

// Guard que protege rutas exigiendo un JWT válido en el header
// Authorization: Bearer <token>. Si falta o es inválido, responde 401.
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
