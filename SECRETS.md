# Environment Secrets Configuration

This document lists all the secrets and environment variables that need to be configured for deployment on new environments.

## Backend (Elixir/Phoenix)

### Database Configuration
- `DATABASE_USER` - PostgreSQL username (default: postgres)
- `DATABASE_PASSWORD` - PostgreSQL password (default: postgres)
- `DATABASE_HOST` - PostgreSQL host (default: localhost)
- `DATABASE_NAME` - Database name (default: my_super_live_chat_dev)

### Redis Configuration
- `REDIS_HOST` - Redis host (default: localhost)
- `REDIS_PORT` - Redis port (default: 6379)

### Phoenix/Application Secrets
- `SECRET_KEY_BASE` - Phoenix secret key base for signing cookies/sessions
  - Generate with: `mix phx.gen.secret`
  - Current dev value (DO NOT use in production): `6eGZbz/0FK5wz3VW5FpMn0eNmAu5jwgMevYdC5RJ0/6I1Ovny2J+aMFqqooQPcM6`

### CORS Configuration
- `CORS_ORIGIN` - Allowed CORS origin for API requests (default: http://localhost:5173)
  - Should be set to your frontend URL in production

## Frontend (React/Vite)

### WebSocket Configuration
- `VITE_WEBSOCKET_URL` - WebSocket URL for Phoenix channels (default: ws://localhost:4000/socket)
  - Format for production: `wss://your-backend-domain.com/socket`

## Production Deployment Checklist

1. Generate a new `SECRET_KEY_BASE`:
   ```bash
   cd backend
   mix phx.gen.secret
   ```

2. Set up PostgreSQL database with secure credentials

3. Set up Redis instance with proper security

4. Configure all environment variables in your deployment platform

5. Update `CORS_ORIGIN` to match your production frontend URL

6. Update `VITE_WEBSOCKET_URL` to use `wss://` (secure WebSocket) in production

7. Ensure database migrations are run:
   ```bash
   mix ecto.migrate
   ```

## Example Production .env (Backend)

```bash
DATABASE_USER=prod_user
DATABASE_PASSWORD=strong_password_here
DATABASE_HOST=db.example.com
DATABASE_NAME=my_super_live_chat_prod
REDIS_HOST=redis.example.com
REDIS_PORT=6379
SECRET_KEY_BASE=generated_secret_key_base_here
CORS_ORIGIN=https://chat.example.com
```

## Example Production .env (Frontend)

```bash
VITE_WEBSOCKET_URL=wss://api.example.com/socket
```

## Security Notes

- Never commit `.env` files to version control
- Rotate secrets regularly
- Use strong passwords for database and Redis
- Use SSL/TLS (https/wss) in production
- Consider using a secrets management service (AWS Secrets Manager, HashiCorp Vault, etc.)
