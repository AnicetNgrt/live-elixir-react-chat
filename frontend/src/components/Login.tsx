import { useState, FormEvent } from 'react';

interface LoginProps {
  onLogin: (username: string, room: string) => void;
}

export function Login({ onLogin }: LoginProps) {
  const [username, setUsername] = useState('');
  const [room, setRoom] = useState('lobby');

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (username.trim() && room.trim()) {
      onLogin(username, room);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-gray-800 mb-2 text-center">
          My Super Live Chat
        </h1>
        <p className="text-gray-600 text-center mb-6">Enter your details to start chatting</p>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="username" className="block text-sm font-medium text-gray-700 mb-1">
              Username
            </label>
            <input
              id="username"
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Enter your username"
              className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
              maxLength={50}
            />
          </div>

          <div>
            <label htmlFor="room" className="block text-sm font-medium text-gray-700 mb-1">
              Room
            </label>
            <input
              id="room"
              type="text"
              value={room}
              onChange={(e) => setRoom(e.target.value)}
              placeholder="Enter room name"
              className="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
          </div>

          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition-colors font-semibold"
          >
            Join Chat
          </button>
        </form>

        <div className="mt-6 text-sm text-gray-500 text-center">
          <p>Popular rooms: lobby, general, random</p>
        </div>
      </div>
    </div>
  );
}
