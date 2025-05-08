import React from 'react';
import { ORIGINAL_MOCK_QUESTIONS } from '../mockData';

interface QuizConfigScreenProps {
  onSubjectSelect: (subject: string) => void;
}

export function QuizConfigScreen({ onSubjectSelect }: QuizConfigScreenProps) {
  const subjects = Array.from(new Set(ORIGINAL_MOCK_QUESTIONS.map(q => q.subject)));

  return (
    <div className="max-w-2xl mx-auto">
      <h2 className="text-2xl font-bold mb-6">Select Training Subject</h2>
      <div className="grid gap-4">
        {subjects.map(subject => (
          <button
            key={subject}
            onClick={() => onSubjectSelect(subject)}
            className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow text-left"
          >
            <h3 className="text-xl font-semibold mb-2">{subject.replace(/-/g, ' ').split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')}</h3>
            <p className="text-gray-600">
              {ORIGINAL_MOCK_QUESTIONS.filter(q => q.subject === subject).length} questions available
            </p>
          </button>
        ))}
      </div>
    </div>
  );
}