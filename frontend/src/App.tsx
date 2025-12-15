import { useState } from 'react';
import { Chat } from './components/Chat';
import { Login } from './components/Login';

const WEBSOCKET_URL = import.meta.env.VITE_WEBSOCKET_URL || 'ws://localhost:4000/socket';

function App() {
  const [user, setUser] = useState<{ username: string; room: string } | null>(null);

  const handleLogin = (username: string, room: string) => {
    setUser({ username, room });
  };

  const handleLogout = () => {
    setUser(null);
  };

  if (!user) {
    return <Login onLogin={handleLogin} />;
  }

  return (
    <div className="relative">
      <Chat url={WEBSOCKET_URL} room={user.room} username={user.username} />
      <button
        onClick={handleLogout}
        className="absolute top-4 right-4 bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors text-sm"
      >
        Leave Room
      </button>
    </div>
  );
}

export default App;
