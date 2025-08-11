import { useEffect } from 'react';
import { io } from 'socket.io-client';

const wsEnv = import.meta.env.VITE_WS_URL || 'ws://localhost:8080/ws';
const wsURL = new URL(wsEnv);

export default function App() {
  useEffect(() => {
    const socket = io(wsURL.origin, { path: wsURL.pathname });
    socket.on('incidents:new', (data) => {
      console.log('new incidents', data);
    });
    return () => {
      socket.close();
    };
  }, []);

  return <div>Radar coming soon</div>;
}
