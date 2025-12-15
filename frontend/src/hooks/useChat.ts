import { useEffect, useRef, useState, useCallback } from 'react';
import { Socket, Channel } from 'phoenix';

export interface Message {
  id: string;
  user: string;
  content: string;
  room: string;
  inserted_at: string;
}

export interface UseChatOptions {
  url: string;
  room: string;
  username: string;
}

export function useChat({ url, room, username }: UseChatOptions) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [connected, setConnected] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [typingUsers, setTypingUsers] = useState<string[]>([]);

  const socketRef = useRef<Socket | null>(null);
  const channelRef = useRef<Channel | null>(null);
  const typingTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    const socket = new Socket(url, {
      params: { username },
    });

    socket.connect();
    socketRef.current = socket;

    socket.onOpen(() => {
      setConnected(true);
      setError(null);
    });

    socket.onError(() => {
      setConnected(false);
      setError('Connection error');
    });

    socket.onClose(() => {
      setConnected(false);
    });

    const channel = socket.channel(`room:${room}`, {});
    channelRef.current = channel;

    channel
      .join()
      .receive('ok', () => {
        console.log('Joined room successfully');
      })
      .receive('error', (resp) => {
        console.error('Unable to join room', resp);
        setError('Unable to join room');
      });

    channel.on('message_history', (payload: { messages: Message[] }) => {
      setMessages(payload.messages);
    });

    channel.on('new_message', (message: Message) => {
      setMessages((prev) => [...prev, message]);
    });

    channel.on('user_typing', (payload: { user: string }) => {
      if (payload.user !== username) {
        setTypingUsers((prev) => {
          if (!prev.includes(payload.user)) {
            return [...prev, payload.user];
          }
          return prev;
        });

        setTimeout(() => {
          setTypingUsers((prev) => prev.filter((u) => u !== payload.user));
        }, 3000);
      }
    });

    return () => {
      channel.leave();
      socket.disconnect();
    };
  }, [url, room, username]);

  const sendMessage = useCallback(
    (content: string) => {
      if (!channelRef.current || !content.trim()) return;

      channelRef.current
        .push('new_message', { user: username, content })
        .receive('ok', () => {
          console.log('Message sent');
        })
        .receive('error', (resp) => {
          console.error('Failed to send message', resp);
          setError('Failed to send message');
        });
    },
    [username]
  );

  const sendTyping = useCallback(() => {
    if (!channelRef.current) return;

    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }

    channelRef.current.push('typing', { user: username });

    typingTimeoutRef.current = setTimeout(() => {
      typingTimeoutRef.current = null;
    }, 1000);
  }, [username]);

  return {
    messages,
    connected,
    error,
    typingUsers,
    sendMessage,
    sendTyping,
  };
}
