import React, { useState } from 'react';

interface Question {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  subject: string;
}

interface QuizGameProps {
  questions: Question[];
  onComplete: (score: number, subject: string) => void;
  subject: string;
}

export function QuizGame({ questions, onComplete, subject }: QuizGameProps) {
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [score, setScore] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [isAnswerSubmitted, setIsAnswerSubmitted] = useState(false);

  const currentQuestion = questions[currentQuestionIndex];

  const handleAnswerSelect = (answerIndex: number) => {
    if (!isAnswerSubmitted) {
      setSelectedAnswer(answerIndex);
    }
  };

  const handleSubmit = () => {
    if (selectedAnswer === null) return;

    if (!isAnswerSubmitted) {
      if (selectedAnswer === currentQuestion.correctAnswer) {
        setScore(score + 1);
      }
      setIsAnswerSubmitted(true);
    } else {
      if (currentQuestionIndex < questions.length - 1) {
        setCurrentQuestionIndex(currentQuestionIndex + 1);
        setSelectedAnswer(null);
        setIsAnswerSubmitted(false);
      } else {
        const finalScore = ((score + (selectedAnswer === currentQuestion.correctAnswer ? 1 : 0)) / questions.length) * 100;
        onComplete(finalScore, subject);
      }
    }
  };

  if (!currentQuestion) {
    return <div>No questions available for this subject.</div>;
  }

  return (
    <div className="max-w-2xl mx-auto bg-white rounded-lg shadow-md p-6">
      <div className="mb-6">
        <div className="flex justify-between items-center mb-4">
          <span className="text-sm text-gray-500">Question {currentQuestionIndex + 1} of {questions.length}</span>
          <span className="text-sm text-gray-500">Score: {score}</span>
        </div>
        <h3 className="text-xl font-semibold mb-4">{currentQuestion.question}</h3>
        <div className="space-y-3">
          {currentQuestion.options.map((option, index) => (
            <button
              key={index}
              onClick={() => handleAnswerSelect(index)}
              className={`w-full p-3 text-left rounded-lg transition-colors ${
                selectedAnswer === index
                  ? isAnswerSubmitted
                    ? index === currentQuestion.correctAnswer
                      ? 'bg-green-100 border-green-500'
                      : 'bg-red-100 border-red-500'
                    : 'bg-blue-100 border-blue-500'
                  : 'bg-gray-50 hover:bg-gray-100'
              } border-2 ${
                isAnswerSubmitted && index === currentQuestion.correctAnswer
                  ? 'border-green-500'
                  : 'border-transparent'
              }`}
              disabled={isAnswerSubmitted}
            >
              {option}
            </button>
          ))}
        </div>
      </div>
      <button
        onClick={handleSubmit}
        disabled={selectedAnswer === null}
        className="w-full bg-blue-600 text-white py-3 rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {isAnswerSubmitted
          ? currentQuestionIndex < questions.length - 1
            ? 'Next Question'
            : 'Complete Quiz'
          : 'Submit Answer'}
      </button>
    </div>
  );
}