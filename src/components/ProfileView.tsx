import React from 'react';
import { User } from '../mockData';
import { Trophy, Zap, Book, Target } from 'lucide-react';

interface ProfileViewProps {
  userData: User;
}

export function ProfileView({ userData }: ProfileViewProps) {
  const calculateAverageScore = (scores: number[]) => {
    return scores.length > 0 ? scores.reduce((a, b) => a + b, 0) / scores.length : 0;
  };

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <div className="flex items-center gap-4 mb-6">
          <div className="bg-blue-100 p-4 rounded-full">
            <Trophy size={32} className="text-blue-600" />
          </div>
          <div>
            <h2 className="text-2xl font-bold">{userData.name}</h2>
            <p className="text-gray-600">{userData.role}</p>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <div className="bg-gray-50 p-4 rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <Target size={20} className="text-blue-600" />
              <h3 className="font-semibold">Total Score</h3>
            </div>
            <p className="text-2xl font-bold">{Math.round(userData.score)}</p>
          </div>
          
          <div className="bg-gray-50 p-4 rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <Zap size={20} className="text-blue-600" />
              <h3 className="font-semibold">Quiz Streak</h3>
            </div>
            <p className="text-2xl font-bold">{userData.quizStreak} days</p>
          </div>
          
          <div className="bg-gray-50 p-4 rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <Book size={20} className="text-blue-600" />
              <h3 className="font-semibold">Subjects Explored</h3>
            </div>
            <p className="text-2xl font-bold">{userData.completedSubjectsFirstTime.length}</p>
          </div>
        </div>

        <div className="space-y-6">
          <h3 className="text-xl font-bold mb-4">Performance History</h3>
          {Object.entries(userData.subjectPerformanceHistory).map(([subject, scores]) => (
            <div key={subject} className="bg-gray-50 p-4 rounded-lg">
              <h4 className="font-semibold mb-2">
                {subject.replace(/-/g, ' ').split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}
              </h4>
              <div className="flex items-center gap-4">
                <div>
                  <p className="text-sm text-gray-600">Average Score</p>
                  <p className="text-lg font-bold">{Math.round(calculateAverageScore(scores))}%</p>
                </div>
                <div>
                  <p className="text-sm text-gray-600">Quizzes Taken</p>
                  <p className="text-lg font-bold">{scores.length}</p>
                </div>
              </div>
            </div>
          ))}
          
          {Object.keys(userData.subjectPerformanceHistory).length === 0 && (
            <p className="text-gray-600 text-center py-4">
              No quiz history yet. Start training to see your progress!
            </p>
          )}
        </div>
      </div>
    </div>
  );
}