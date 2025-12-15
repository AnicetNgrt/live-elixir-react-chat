import { useState, useEffect, useRef, FormEvent } from 'react';
import { useChat, Message } from '../hooks/useChat';

interface ChatProps {
  url: string;
  room: string;
  username: string;
}

export function Chat({ url, room, username }: ChatProps) {
  const { messages, connected, error, typingUsers, sendMessage, sendTyping } = useChat({
    url,
    room,
    username,
  });

  const [input, setInput] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (input.trim()) {
      sendMessage(input);
      setInput('');
    }
  };

  const handleInputChange = (value: string) => {
    setInput(value);
    sendTyping();
  };

  return (
    <div className="flex flex-col h-screen bg-gray-100">
      <header className="bg-blue-600 text-white p-4 shadow-md">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <h1 className="text-2xl font-bold">My Super Live Chat</h1>
          <div className="flex items-center gap-2">
            <span className="text-sm">Room: {room}</span>
            <div
              className={`w-2 h-2 rounded-full ${
                connected ? 'bg-green-400' : 'bg-red-400'
              }`}
            />
          </div>
        </div>
      </header>

      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 max-w-4xl mx-auto mt-4 rounded">
          {error}
        </div>
      )}

      <div className="flex-1 overflow-y-auto p-4 max-w-4xl mx-auto w-full">
        <div className="space-y-4">
          {messages.map((message) => (
            <MessageBubble
              key={message.id}
              message={message}
              isOwn={message.user === username}
            />
          ))}
          {typingUsers.length > 0 && (
            <div className="text-sm text-gray-500 italic">
              {typingUsers.join(', ')} {typingUsers.length === 1 ? 'is' : 'are'} typing...
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>
      </div>

      <form onSubmit={handleSubmit} className="bg-white border-t p-4">
        <div className="max-w-4xl mx-auto flex gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => handleInputChange(e.target.value)}
            placeholder="Type a message..."
            className="flex-1 border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
            disabled={!connected}
          />
          <button
            type="submit"
            disabled={!connected || !input.trim()}
            className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            Send
          </button>
        </div>
        <div className="max-w-4xl mx-auto mt-2 text-sm text-gray-600">
          Logged in as: <span className="font-semibold">{username}</span>
        </div>
      </form>
    </div>
  );
}

interface MessageBubbleProps {
  message: Message;
  isOwn: boolean;
}

function MessageBubble({ message, isOwn }: MessageBubbleProps) {
  const time = new Date(message.inserted_at).toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit',
  });

  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'}`}>
      <div className={`max-w-xs md:max-w-md ${isOwn ? 'order-2' : 'order-1'}`}>
        <div className="flex items-baseline gap-2 mb-1">
          <span className={`text-sm font-semibold ${isOwn ? 'text-blue-600' : 'text-gray-700'}`}>
            {message.user}
          </span>
          <span className="text-xs text-gray-500">{time}</span>
        </div>
        <div
          className={`rounded-lg px-4 py-2 ${
            isOwn
              ? 'bg-blue-600 text-white rounded-br-none'
              : 'bg-white text-gray-800 rounded-bl-none shadow'
          }`}
        >
          <p className="break-words">{message.content}</p>
        </div>
      </div>
    </div>
  );
}
