import React from 'react';
import { Home, User, BookOpen } from 'lucide-react';

interface NavigationProps {
  currentView: string;
  setCurrentView: (view: string) => void;
}

export function Navigation({ currentView, setCurrentView }: NavigationProps) {
  return (
    <nav className="flex gap-4">
      <button
        onClick={() => setCurrentView('home')}
        className={`flex items-center gap-2 px-3 py-1 rounded-lg transition-colors ${
          currentView === 'home' ? 'bg-blue-700' : 'hover:bg-blue-700'
        }`}
      >
        <Home size={20} />
        <span>Home</span>
      </button>
      <button
        onClick={() => setCurrentView('config')}
        className={`flex items-center gap-2 px-3 py-1 rounded-lg transition-colors ${
          currentView === 'config' ? 'bg-blue-700' : 'hover:bg-blue-700'
        }`}
      >
        <BookOpen size={20} />
        <span>Train</span>
      </button>
      <button
        onClick={() => setCurrentView('profile')}
        className={`flex items-center gap-2 px-3 py-1 rounded-lg transition-colors ${
          currentView === 'profile' ? 'bg-blue-700' : 'hover:bg-blue-700'
        }`}
      >
        <User size={20} />
        <span>Profile</span>
      </button>
    </nav>
  );
}