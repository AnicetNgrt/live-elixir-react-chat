# My Super Live Chat

A real-time chat application built with Elixir/Phoenix backend and React/TypeScript frontend.

## Features

- Real-time messaging using Phoenix Channels (WebSockets)
- Multiple chat rooms
- Typing indicators
- Message history persistence (PostgreSQL)
- Message count tracking (Redis)
- Responsive UI with Tailwind CSS
- Full TypeScript support
- Comprehensive test suite

## Tech Stack

### Backend
- Elixir 1.14
- Phoenix 1.7
- PostgreSQL 15
- Redis 7
- WebSocket (Phoenix Channels)

### Frontend
- React 18
- TypeScript
- Vite
- Tailwind CSS
- Phoenix JavaScript Client

## Prerequisites

- Elixir 1.14+
- Erlang/OTP 25+
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15+ (via Docker)
- Redis 7+ (via Docker)

## Quick Start

### 1. Initial Setup

Run the setup script to install all dependencies and set up the database:

```bash
./setup.sh
```

This script will:
- Check for required dependencies
- Start Docker services (PostgreSQL & Redis)
- Install Elixir dependencies
- Create and migrate the database
- Install Node.js dependencies

### 2. Launch the Application

Use the launch script to start both backend and frontend:

```bash
./launch.sh
```

Or manually:

```bash
# Terminal 1 - Backend
cd backend
mix phx.server

# Terminal 2 - Frontend
cd frontend
npm run dev
```

The application will be available at:
- Frontend: http://localhost:5173
- Backend API: http://localhost:4000

## Scripts

### Setup
```bash
./setup.sh
```
Installs dependencies and sets up the database.

### Launch
```bash
./launch.sh
```
Starts both backend and frontend servers.

### Test
```bash
./test.sh
```
Runs the backend test suite.

### Type Check
```bash
./typecheck.sh
```
Runs TypeScript type checking on the frontend.

## Development

### Backend Development

```bash
cd backend

# Run tests
mix test

# Run tests with coverage
mix test --cover

# Interactive Elixir shell
iex -S mix phx.server

# Create a new migration
mix ecto.gen.migration migration_name

# Reset database
mix ecto.reset
```

### Frontend Development

```bash
cd frontend

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Type check
npx tsc --noEmit

# Lint
npm run lint
```

## Project Structure

```
.
├── backend/                  # Elixir/Phoenix backend
│   ├── lib/
│   │   ├── my_super_live_chat/
│   │   │   ├── application.ex
│   │   │   ├── chat/         # Chat context
│   │   │   │   └── message.ex
│   │   │   └── chat.ex
│   │   └── my_super_live_chat_web/
│   │       ├── channels/     # WebSocket channels
│   │       │   ├── room_channel.ex
│   │       │   └── user_socket.ex
│   │       └── endpoint.ex
│   ├── test/
│   ├── config/
│   └── mix.exs
├── frontend/                 # React/TypeScript frontend
│   ├── src/
│   │   ├── components/
│   │   │   ├── Chat.tsx
│   │   │   └── Login.tsx
│   │   ├── hooks/
│   │   │   └── useChat.ts
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── package.json
│   └── tsconfig.json
├── docker-compose.yml        # Docker services
├── setup.sh                  # Setup script
├── launch.sh                 # Launch script
├── test.sh                   # Test script
├── typecheck.sh              # Type check script
├── SECRETS.md                # Secrets documentation
└── README.md
```

## Configuration

### Environment Variables

See `SECRETS.md` for a complete list of environment variables that need to be configured for deployment.

### Development Defaults

- Backend: http://localhost:4000
- Frontend: http://localhost:5173
- PostgreSQL: localhost:5432
- Redis: localhost:6379

## Testing

Backend tests include:
- Message CRUD operations
- Channel join/leave functionality
- Message broadcasting
- Typing indicators
- Database integration

Run tests:
```bash
cd backend
mix test
```

## Deployment

For production deployment:

1. Review `SECRETS.md` for required environment variables
2. Generate production secrets
3. Configure database and Redis
4. Set CORS origins
5. Use SSL/TLS (https/wss)
6. Build frontend for production
7. Run database migrations

## API/WebSocket Events

### Client -> Server
- `new_message` - Send a new message
  - Payload: `{user: string, content: string}`
- `typing` - User is typing
  - Payload: `{user: string}`

### Server -> Client
- `message_history` - Initial message history on join
  - Payload: `{messages: Message[]}`
- `new_message` - New message broadcast
  - Payload: `Message`
- `user_typing` - User typing notification
  - Payload: `{user: string, room: string}`

## License

MIT

## Support

For issues and questions, please open an issue in the repository.
