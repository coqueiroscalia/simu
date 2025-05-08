import React, { useState } from 'react';
import { User, createMockUser, ORIGINAL_MOCK_QUESTIONS } from './mockData';
import { QuizGame } from './components/QuizGame';
import { QuizConfigScreen } from './components/QuizConfigScreen';
import { ProfileView } from './components/ProfileView';
import { Navigation } from './components/Navigation';

function App() {
  const [currentView, setCurrentView] = useState('home');
  const [userData, setUserData] = useState<User>(createMockUser());
  const [selectedSubject, setSelectedSubject] = useState<string>('');

  const handleQuizComplete = (score: number, subject: string) => {
    setUserData(prevData => {
      const now = new Date();
      const streakMaintained = prevData.lastQuizCompletionDate 
        ? (now.getTime() - prevData.lastQuizCompletionDate.getTime()) / (1000 * 60 * 60 * 24) <= 1 
        : false;

      const newHistory = {
        ...prevData.subjectPerformanceHistory,
        [subject]: [...(prevData.subjectPerformanceHistory[subject] || []), score]
      };

      return {
        ...prevData,
        score: prevData.score + score,
        lastQuizCompletionDate: now,
        quizStreak: streakMaintained ? prevData.quizStreak + 1 : 1,
        completedSubjectsFirstTime: prevData.completedSubjectsFirstTime.includes(subject) 
          ? prevData.completedSubjectsFirstTime 
          : [...prevData.completedSubjectsFirstTime, subject],
        subjectPerformanceHistory: newHistory
      };
    });
    setCurrentView('profile');
  };

  const renderCurrentView = () => {
    switch (currentView) {
      case 'quiz':
        return (
          <QuizGame 
            questions={ORIGINAL_MOCK_QUESTIONS.filter(q => q.subject === selectedSubject)}
            onComplete={handleQuizComplete}
            subject={selectedSubject}
          />
        );
      case 'config':
        return (
          <QuizConfigScreen 
            onSubjectSelect={(subject) => {
              setSelectedSubject(subject);
              setCurrentView('quiz');
            }}
          />
        );
      case 'profile':
        return <ProfileView userData={userData} />;
      default:
        return (
          <div className="text-center">
            <h2 className="text-2xl font-bold mb-6">Welcome to Simu Training Platform</h2>
            <p className="text-lg mb-8">Your gamified learning platform for airline professionals</p>
            <button
              onClick={() => setCurrentView('config')}
              className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Start Training
            </button>
          </div>
        );
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-blue-600 text-white p-4">
        <div className="container mx-auto flex justify-between items-center">
          <h1 className="text-2xl font-bold">Simu</h1>
          <Navigation currentView={currentView} setCurrentView={setCurrentView} />
        </div>
      </header>
      <main className="container mx-auto p-4">
        {renderCurrentView()}
      </main>
    </div>
  );
}

export default App;