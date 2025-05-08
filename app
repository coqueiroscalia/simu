{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 import React, \{\
    useState,\
    useEffect,\
    useMemo,\
    useCallback,\
    useRef,\
    createContext,\
    forwardRef,\
    useImperativeHandle,\
    memo\
\} from 'react';\
\
// --- Icons (Lucide React - Assumed to be available) ---\
import \{\
    Home, Trophy, User, Check, ArrowRight, X, Info, Loader2, RefreshCw, BookOpen,\
    CloudLightning, Navigation, PlaneTakeoff, ListChecks, Grid, HelpCircle, Timer, Target,\
    TrendingUp, TrendingDown, Zap, CloudSnow, CloudDrizzle, Cloud, SignalLow, SignalMedium,\
    SignalHigh, Signal, CheckCircle, XCircle, AlertCircle,\
    ClipboardList, GraduationCap, Award, Settings, ChevronRight,\
    Sun, Moon, Laptop2, Volume2, VolumeX, UserCircle, Star, Gem, Edit,\
    AlertTriangle, CalendarClock, Bookmark, Camera, Trash2, Bot, ExternalLink, Lock,\
    Sparkles,\
    ArrowLeft,\
    Inbox,\
    LogIn, // Added for Login button\
    LogOut, // Added for Logout button\
    UserCheck, // Added for Login View\
    ShieldCheck, // Added for Pro plan\
    ShieldAlert, // Added for Basic plan\
    ShieldQuestion // Added for Ultra plan (example)\
\} from 'lucide-react';\
\
\
// --- Constants ---\
const VIEW_LOGIN = 'login'; // New Login View\
const VIEW_INICIO = 'inicio';\
const VIEW_HOME = 'home';\
const VIEW_SIMULADOR = 'simulador';\
const VIEW_PERFIL = 'perfil';\
const VIEW_EDIT_PROFILE = 'edit_profile';\
const VIEW_LEARN_MORE = 'learn_more';\
const VIEW_UPGRADE = 'upgrade';\
const VIEW_SAVED_EXPLANATIONS = 'saved_explanations';\
\
// Subscription Plans / Permission Levels\
const SUBSCRIPTION_PLANS = \{\
    BASIC: 'Basic',\
    PRO: 'Pro',\
    // PREMIUM: 'Premium', // Removed for simplicity based on request\
    ULTRA: 'Ultra'\
\};\
\
// Question Types\
const QUESTION_TYPES = \{\
    MULTIPLE_CHOICE: 'multiple-choice',\
    BENTO_ICON: 'multiple-choice-bento-icon',\
    BENTO_PHOTO: 'multiple-choice-bento-photo',\
    FILL_BLANK: 'fill-in-the-blank',\
    SEQUENCING: 'sequencing',\
    HOTSPOT: 'hotspot',\
\};\
\
// Action Button States\
const ACTION_BUTTON_STATES = \{\
    HIDDEN: 'hidden',\
    READY: 'ready',\
    LOADING: 'loading',\
    CORRECT: 'correct',\
    INCORRECT: 'incorrect',\
    FINISHED_RESTARTABLE: 'finished_restartable'\
\};\
\
// Quiz Configuration Options\
const NUM_QUESTIONS_OPTIONS = [10, 20, 40, 80, 100];\
const AI_NUM_QUESTIONS_OPTIONS = [10, 20, 40];\
const DESKTOP_CONTENT_GAP_CLASS = 'gap-6';\
\
// --- Feedback Messages (Simu's Voice) ---\
const CORRECT_FEEDBACK_TITLES = [\
    "Boa! Resposta certa!",\
    "Mandou bem!",\
    "\'c9 isso a\'ed!",\
    "Correto!",\
    "Perfeito!",\
];\
const INCORRECT_FEEDBACK_TITLES = [\
    "Ops, n\'e3o foi dessa vez.",\
    "Quase l\'e1!",\
    "Essa n\'e3o \'e9 a resposta.",\
    "Hmm, vamos revisar?",\
    "Resposta incorreta.",\
];\
\
\
// --- Context (Placeholder if needed elsewhere) ---\
const ActionContext = createContext(\{\});\
\
// --- Mock Data ---\
// *** NOTE: Added more descriptive explanations and unique IDs ***\
const ORIGINAL_MOCK_QUESTIONS = [\
    // Regulamentos\
    \{ id: 'REG001', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Regulamentos', question: 'Qual a sigla para "Visual Flight Rules"?', options: ['VFR', 'IFR', 'MVFR', 'CVFR'], correctAnswerIndex: 0, explanation: 'VFR significa "Visual Flight Rules" (Regras de Voo Visual). Pilotos operam sob VFR em condi\'e7\'f5es meteorol\'f3gicas visuais (VMC), mantendo refer\'eancia visual com o terreno e outras aeronaves.' \},\
    \{ id: 'REG002', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Regulamentos', question: 'Qual a velocidade m\'e1xima abaixo de 10.000 p\'e9s MSL (geralmente)?', options: ['200 kt', '250 kt', '300 kt', 'Sem limite'], correctAnswerIndex: 1, explanation: 'Abaixo de 10.000 p\'e9s MSL, a velocidade m\'e1xima permitida \'e9 geralmente 250 n\'f3s (IAS) para aumentar a seguran\'e7a, especialmente em \'e1reas de tr\'e1fego denso e pr\'f3ximo a aer\'f3dromos.' \},\
    \{ id: 'REG003', type: QUESTION_TYPES.FILL_BLANK, subject: 'Regulamentos', question: 'A separa\'e7\'e3o m\'ednima vertical entre aeronaves em RVSM acima do FL290 \'e9 de _____ p\'e9s.', correctAnswer: '1000', placeholder: 'Digite o n\'famero', explanation: 'RVSM (Reduced Vertical Separation Minimum) permite uma separa\'e7\'e3o vertical de 1000 p\'e9s entre FL290 e FL410 (inclusive), otimizando o espa\'e7o a\'e9reo. Aeronaves e tripula\'e7\'e3o precisam de certifica\'e7\'e3o espec\'edfica.' \},\
    \{ id: 'REG004', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Regulamentos', question: 'Qual \'e9 a prioridade de passagem em voo entre uma aeronave e um bal\'e3o?', options: ['Aeronave tem prioridade', 'Bal\'e3o tem prioridade', 'Depende da altitude', 'Quem estiver mais r\'e1pido'], correctAnswerIndex: 1, explanation: 'Bal\'f5es t\'eam a menor capacidade de manobra e, portanto, t\'eam prioridade sobre todas as outras categorias de aeronaves (planadores, dirig\'edveis, aeronaves motorizadas), exceto em caso de emerg\'eancia.' \},\
    // Meteorologia\
    \{ id: 'MET001', type: QUESTION_TYPES.BENTO_ICON, subject: 'Meteorologia', question: 'Que tipo de nuvem est\'e1 associada a trovoadas?', options: [ \{ id: 'opt1', text: 'Cirrus', icon: 'CloudSnow' \}, \{ id: 'opt2', text: 'Stratus', icon: 'CloudDrizzle' \}, \{ id: 'opt3', text: 'Cumulonimbus', icon: 'CloudLightning' \}, \{ id: 'opt4', text: 'Altocumulus', icon: 'Cloud' \} ], correctAnswerIndex: 2, explanation: 'Cumulonimbus (Cb) s\'e3o nuvens densas e de grande desenvolvimento vertical, associadas a instabilidade atmosf\'e9rica, trovoadas, raios, chuva forte, granizo e turbul\'eancia severa.' \},\
    \{ id: 'MET002', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Meteorologia', question: 'O que significa a sigla METAR?', options: ['Meteorological Aerodrome Report', 'Meteorological Terminal Air Report', 'Minimum Equipment Task Assessment Report', 'Meteorological Aviation Routine Weather Report'], correctAnswerIndex: 3, explanation: 'METAR (Meteorological Aviation Routine Weather Report) \'e9 um relat\'f3rio meteorol\'f3gico regular de aer\'f3dromo, codificado em formato padr\'e3o internacional, contendo informa\'e7\'f5es como vento, visibilidade, tempo presente, nuvens, temperatura e press\'e3o.' \},\
    // Conhecimentos T\'e9cnicos\
    \{ id: 'TEC001', type: QUESTION_TYPES.BENTO_PHOTO, subject: 'Conhecimentos T\'e9cnicos', question: 'Qual instrumento \'e9 este?', options: [ \{ id: 'optA', text: 'Alt\'edmetro', imageUrl: 'https://placehold.co/150x100/a78bfa/ffffff?text=Alt%C3%ADmetro' \}, \{ id: 'optB', text: 'Veloc\'edmetro', imageUrl: 'https://placehold.co/150x100/6366f1/ffffff?text=Veloc%C3%ADmetro' \}, \{ id: 'optC', text: 'Horizonte Artificial', imageUrl: 'https://placehold.co/150x100/a855f7/ffffff?text=Horiz.+Artif.' \}, \{ id: 'optD', text: 'Climb', imageUrl: 'https://placehold.co/150x100/d8b4fe/ffffff?text=Climb' \} ], correctAnswerIndex: 0, explanation: 'O Alt\'edmetro indica a altitude da aeronave. Geralmente \'e9 ajustado com a press\'e3o QNH (altitude em rela\'e7\'e3o ao n\'edvel m\'e9dio do mar) ou QFE (altura em rela\'e7\'e3o \'e0 pista).' \},\
    \{ id: 'TEC002', type: QUESTION_TYPES.HOTSPOT, subject: 'Conhecimentos T\'e9cnicos', question: 'Qual instrumento prim\'e1rio indica a atitude da aeronave?', imageUrl: 'https://placehold.co/400x225/6366f1/ffffff?text=Painel+Simples+(Exemplo)', hotspots: [ \{ id: 'hs1', label: 'Veloc\'edmetro', x: 15, y: 35 \}, \{ id: 'hs2', label: 'Horizonte Artificial', x: 50, y: 35 \}, \{ id: 'hs3', label: 'Alt\'edmetro', x: 85, y: 35 \}, \{ id: 'hs4', label: 'B\'fassola', x: 50, y: 80 \} ], correctHotspotId: 'hs2', explanation: 'O Horizonte Artificial (Indicador de Atitude) mostra a atitude da aeronave (inclina\'e7\'e3o longitudinal - pitch, e lateral - bank) em rela\'e7\'e3o ao horizonte. \'c9 crucial para voo por instrumentos (IFR).' \},\
    \{ id: 'TEC003', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Conhecimentos T\'e9cnicos', question: 'Qual o prop\'f3sito do magnetos em um motor a pist\'e3o?', options: ['Gerar v\'e1cuo para instrumentos', 'Gerar corrente el\'e9trica para a igni\'e7\'e3o', 'Controlar a mistura ar/combust\'edvel', 'Lubrificar o motor'], correctAnswerIndex: 1, explanation: 'Magnetos s\'e3o geradores independentes que fornecem corrente de alta tens\'e3o para as velas de igni\'e7\'e3o, garantindo o funcionamento do motor mesmo em caso de falha do sistema el\'e9trico principal da aeronave.' \},\
    // Navega\'e7\'e3o\
    \{ id: 'NAV001', type: QUESTION_TYPES.BENTO_ICON, subject: 'Navega\'e7\'e3o', question: 'O VOR opera em qual faixa de frequ\'eancia?', options: [ \{id: 'o1', text:'HF', icon: 'SignalLow'\}, \{id:'o2', text:'VHF', icon:'SignalMedium'\}, \{id:'o3', text:'UHF', icon:'SignalHigh'\}, \{id:'o4', text:'LF', icon:'Signal'\} ], correctAnswerIndex: 1, explanation: 'VOR (VHF Omnidirectional Range) opera na faixa VHF (Very High Frequency), entre 108.0 MHz e 117.95 MHz. \'c9 um aux\'edlio \'e0 navega\'e7\'e3o essencial que permite determinar a radial em rela\'e7\'e3o \'e0 esta\'e7\'e3o VOR.' \},\
    \{ id: 'NAV002', type: QUESTION_TYPES.FILL_BLANK, subject: 'Navega\'e7\'e3o', question: 'A linha que conecta pontos de igual declina\'e7\'e3o magn\'e9tica \'e9 chamada de linha _____.', correctAnswer: 'isog\'f4nica', placeholder: 'Digite o nome', explanation: 'Linhas isog\'f4nicas conectam pontos de mesma declina\'e7\'e3o magn\'e9tica (diferen\'e7a entre Norte Verdadeiro e Norte Magn\'e9tico). A linha de declina\'e7\'e3o zero \'e9 chamada ag\'f4nica.' \},\
    // Teoria de Voo\
    \{ id: 'TEO001', type: QUESTION_TYPES.MULTIPLE_CHOICE, subject: 'Teoria de Voo', question: 'Qual das 4 for\'e7as atua paralelamente e na mesma dire\'e7\'e3o do movimento da aeronave?', options: ['Peso', 'Sustenta\'e7\'e3o', 'Arrasto', 'Tra\'e7\'e3o'], correctAnswerIndex: 3, explanation: 'As quatro for\'e7as do voo s\'e3o: Sustenta\'e7\'e3o (oposta ao Peso), Arrasto (oposto \'e0 Tra\'e7\'e3o), Peso (dire\'e7\'e3o ao centro da Terra) e Tra\'e7\'e3o (dire\'e7\'e3o do movimento). A Tra\'e7\'e3o impulsiona a aeronave para frente.' \},\
    \{ id: 'TEO002', type: QUESTION_TYPES.BENTO_ICON, subject: 'Teoria de Voo', question: 'Qual fen\'f4meno aerodin\'e2mico aumenta a sustenta\'e7\'e3o perto do solo?', options: [ \{id: 'tf1', text:'Estol', icon: 'TrendingDown'\}, \{id:'tf2', text:'Efeito Solo', icon:'TrendingUp'\}, \{id:'tf3', text:'Arrasto Induzido', icon:'Zap'\}, \{id:'tf4', text:'Camada Limite', icon:'Cloud'\} ], correctAnswerIndex: 1, explanation: 'O Efeito Solo ocorre pr\'f3ximo \'e0 superf\'edcie (altura menor que a envergadura), onde o fluxo de ar sob as asas \'e9 restringido pelo solo. Isso reduz o arrasto induzido e aumenta a efici\'eancia da asa, dando a sensa\'e7\'e3o de "flutuar".' \},\
];\
\
// --- Mock User Data Generator ---\
const createMockUser = (permissionLevel) => \{\
    const baseUser = \{\
        score: Math.floor(Math.random() * 20000),\
        expirationDays: 30 + Math.floor(Math.random() * 30),\
        avatarUrl: null // Can add random avatars later if needed\
    \};\
    switch (permissionLevel) \{\
        case SUBSCRIPTION_PLANS.BASIC:\
            return \{ ...baseUser, id: 'user_basic_123', name: "Piloto B\'e1sico", nickname: "cmte_basic", subscription: SUBSCRIPTION_PLANS.BASIC \};\
        case SUBSCRIPTION_PLANS.PRO:\
            return \{ ...baseUser, id: 'user_pro_456', name: "Piloto Pro", nickname: "cmte_pro", subscription: SUBSCRIPTION_PLANS.PRO \};\
        case SUBSCRIPTION_PLANS.ULTRA:\
            return \{ ...baseUser, id: 'user_ultra_789', name: "Piloto Ultra", nickname: "cmte_ultra", subscription: SUBSCRIPTION_PLANS.ULTRA \};\
        default:\
            console.warn(`Unknown permission level: $\{permissionLevel\}. Defaulting to Basic.`);\
            return \{ ...baseUser, id: 'user_default_000', name: "Piloto", nickname: "cmte_default", subscription: SUBSCRIPTION_PLANS.BASIC \};\
    \}\
\};\
\
\
// --- Utility Functions ---\
function shuffleArray(array) \{ if (!Array.isArray(array)) \{ console.error("shuffleArray received non-array input:", array); return []; \} const newArray = [...array]; let currentIndex = newArray.length, randomIndex; while (currentIndex !== 0) \{ randomIndex = Math.floor(Math.random() * currentIndex); currentIndex--; [newArray[currentIndex], newArray[randomIndex]] = [newArray[randomIndex], newArray[currentIndex]]; \} return newArray; \}\
const formatTimeMMSS = (ms) => \{ if (ms === null || ms < 0) return '--:--'; const totalSeconds = Math.floor(ms / 1000); const minutes = Math.floor(totalSeconds / 60); const seconds = totalSeconds % 60; return `$\{minutes.toString().padStart(2, '0')\}:$\{seconds.toString().padStart(2, '0')\}`; \};\
const formatAvgTimeSec = (ms) => \{ if (ms === null || ms < 0) return '-- s'; return `$\{(ms / 1000).toFixed(1)\} s`; \};\
const triggerVibration = (pattern) => \{ if ('vibrate' in navigator) \{ try \{ navigator.vibrate(pattern); \} catch (e) \{ console.warn("Vibration API failed:", e); \} \} \};\
const PLACEHOLDER_IMAGE_URL = (width = 150, height = 100, text = 'Imagem Indispon\'edvel') => `https://placehold.co/$\{width\}x$\{height\}/e0e0e0/757575?text=$\{encodeURIComponent(text)\}`;\
\
// --- Reusable UI Components ---\
const PATENT_TIERS = [ \{ name: 'Alum\'ednio', threshold: 0, color: 'bg-gradient-to-br from-slate-300 via-slate-400 to-slate-500', textColor: 'text-slate-800', iconColor: '#94a3b8', ringColor: 'ring-slate-400' \}, \{ name: 'Bronze', threshold: 20, color: 'bg-gradient-to-br from-yellow-600 via-orange-700 to-yellow-800', textColor: 'text-white', iconColor: '#a16207', ringColor: 'ring-orange-700' \}, \{ name: 'Prata', threshold: 40, color: 'bg-gradient-to-br from-slate-100 via-slate-300 to-slate-400', textColor: 'text-slate-700', iconColor: '#cbd5e1', ringColor: 'ring-slate-300' \}, \{ name: 'Ouro', threshold: 60, color: 'bg-gradient-to-br from-yellow-400 via-amber-400 to-yellow-500', textColor: 'text-yellow-900', iconColor: '#f59e0b', ringColor: 'ring-amber-400' \}, \{ name: 'Esmeralda', threshold: 80, color: 'bg-gradient-to-br from-emerald-500 to-green-600', textColor: 'text-white', iconColor: '#10b981', ringColor: 'ring-emerald-500' \}, \{ name: 'Safira', threshold: 95, color: 'bg-gradient-to-br from-blue-500 to-indigo-600', textColor: 'text-white', iconColor: '#60a5fa', ringColor: 'ring-blue-500' \}, ].sort((a, b) => b.threshold - a.threshold);\
function getPatentForPercentage(percentage) \{ return PATENT_TIERS.find(tier => percentage >= tier.threshold) || PATENT_TIERS[PATENT_TIERS.length - 1]; \}\
const PatentBadge = memo((\{ patent \}) => \{ if (!patent) return null; return ( <div className=\{`relative inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-base font-semibold shadow-md $\{patent.color\} $\{patent.textColor\} overflow-hidden transition-transform duration-300 hover:scale-105 ring-2 ring-offset-2 ring-offset-slate-50 dark:ring-offset-slate-900 $\{patent.ringColor\}`\}> <Award className="w-5 h-5 opacity-90 drop-shadow-sm" /> <span className="drop-shadow-sm">\{patent.name\}</span> <div className="absolute inset-0 bg-gradient-to-t from-white/10 via-white/5 to-transparent opacity-50"></div> </div> ); \});\
PatentBadge.displayName = 'PatentBadge';\
// Subject Visuals Mapping\
const SUBJECT_VISUALS = \{\
    'Regulamentos': \{ icon: BookOpen, color: 'text-red-600', bg: 'bg-red-100', gradient: 'from-red-600 to-rose-700', ring: 'ring-red-500' \},\
    'Meteorologia': \{ icon: CloudLightning, color: 'text-orange-600', bg: 'bg-orange-100', gradient: 'from-orange-500 to-amber-600', ring: 'ring-orange-500' \},\
    'Navega\'e7\'e3o': \{ icon: Navigation, color: 'text-green-600', bg: 'bg-green-100', gradient: 'from-green-600 to-emerald-700', ring: 'ring-green-500' \},\
    'Teoria de Voo': \{ icon: PlaneTakeoff, color: 'text-blue-600', bg: 'bg-blue-100', gradient: 'from-blue-600 to-sky-700', ring: 'ring-blue-500' \},\
    'Conhecimentos T\'e9cnicos': \{ icon: Settings, color: 'text-purple-600', bg: 'bg-purple-100', gradient: 'from-purple-600 to-violet-700', ring: 'ring-purple-500' \},\
    'Default': \{ icon: Grid, color: 'text-slate-600', bg: 'bg-slate-100', gradient: 'from-slate-600 to-slate-700', ring: 'ring-slate-500' \}\
\};\
const ProgressBar = memo((\{ percentage, colorClass = 'bg-white' \}) => ( <div className="w-full bg-white/30 rounded-full h-2.5 overflow-hidden" role="progressbar" aria-valuenow=\{percentage\} aria-valuemin="0" aria-valuemax="100"> <div className=\{`h-full rounded-full transition-all duration-500 ease-out $\{colorClass\}`\} style=\{\{ width: `$\{percentage\}%` \}\} /> </div> ));\
ProgressBar.displayName = 'ProgressBar';\
const StatsCard = memo((\{ title, icon: Icon, children, iconBgColor = 'bg-purple-100', iconTextColor = 'text-purple-600' \}) => ( <div className="p-5 sm:p-6 rounded-xl bg-white dark:bg-slate-800 border border-slate-200/80 dark:border-slate-700/80 shadow-sm hover:shadow-lg transition-shadow duration-300 ease-in-out flex flex-col h-full"> <div className="flex items-center mb-4"> \{Icon && (<div className=\{`flex-shrink-0 w-10 h-10 rounded-lg flex items-center justify-center mr-4 $\{iconBgColor\}`\}><Icon className=\{`h-6 w-6 $\{iconTextColor\}`\} /></div>)\} <h4 className="text-lg font-semibold text-slate-800 dark:text-slate-100">\{title\}</h4> </div> <div className="flex-grow text-slate-600 dark:text-slate-300">\{children\}</div> </div> ));\
StatsCard.displayName = 'StatsCard';\
const PerformanceCard = memo((\{ title, icon, percentage, bestOrWorstSubjects, subjectLabel \}) => \{ const isPositiveMetric = title === 'Desempenho Geral'; const iconBg = isPositiveMetric ? 'bg-green-100 dark:bg-green-900/50' : 'bg-red-100 dark:bg-red-900/50'; const iconText = isPositiveMetric ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'; let progressBg = 'bg-slate-500'; let percentageTextColor = 'text-slate-600 dark:text-slate-300'; if (percentage !== null) \{ if (isPositiveMetric) \{ if (percentage >= 70) \{ percentageTextColor = 'text-green-600 dark:text-green-400'; progressBg = 'bg-green-500'; \} else if (percentage >= 40) \{ percentageTextColor = 'text-yellow-600 dark:text-yellow-400'; progressBg = 'bg-yellow-500'; \} else \{ percentageTextColor = 'text-red-600 dark:text-red-400'; progressBg = 'bg-red-500'; \} \} else \{ if (percentage >= 70) \{ percentageTextColor = 'text-green-600 dark:text-green-400'; progressBg = 'bg-green-500'; \} else if (percentage >= 40) \{ percentageTextColor = 'text-yellow-600 dark:text-yellow-400'; progressBg = 'bg-yellow-500'; \} else \{ percentageTextColor = 'text-red-600 dark:text-red-400'; progressBg = 'bg-red-500'; \} \} \} return ( <StatsCard title=\{title\} icon=\{icon\} iconBgColor=\{iconBg\} iconTextColor=\{iconText\}> <div className="mb-4"> <div className="flex justify-between items-baseline mb-1"><span className="text-sm font-medium text-slate-600 dark:text-slate-400">\{subjectLabel\}</span><span className=\{`text-xl font-bold $\{percentageTextColor\}`\}>\{percentage !== null ? `$\{percentage.toFixed(0)\}%` : 'N/A'\}</span></div> <div className="w-full bg-slate-200 dark:bg-slate-700 rounded-full h-2.5 overflow-hidden"><div className=\{`h-full rounded-full transition-all duration-500 ease-out $\{progressBg\}`\} style=\{\{ width: `$\{percentage ?? 0\}%` \}\}></div></div> </div> <div className="text-xs text-slate-500 dark:text-slate-400 space-y-1.5 mt-auto pt-3 border-t border-slate-100 dark:border-slate-700"> <span className="font-medium block text-slate-600 dark:text-slate-300">\{isPositiveMetric ? 'Melhores mat\'e9rias:' : 'Mat\'e9rias com mais erros:'\}</span> \{bestOrWorstSubjects && bestOrWorstSubjects.length > 0 ? (bestOrWorstSubjects.slice(0, 3).map(s => \{ const subjectVisual = SUBJECT_VISUALS[s.name] || SUBJECT_VISUALS.Default; const indicatorClass = subjectVisual.ring.replace('ring-','bg-'); return (<div key=\{s.name\} className="flex items-center gap-2"><span className=\{`w-2 h-2 rounded-full $\{indicatorClass\} flex-shrink-0`\}></span><span className="flex-1 truncate">\{s.name\} (\{isPositiveMetric ? s.correct : s.incorrect\}/\{s.total\})</span></div>); \})) : (<span className="block ml-4 italic">- Nenhuma mat\'e9ria para listar</span>)\} </div> </StatsCard> ); \});\
PerformanceCard.displayName = 'PerformanceCard';\
\
// --- Quiz Specific Components ---\
const getOptionButtonClass = (isSelected, isChecked, isCorrectOption) => \{\
    let baseClasses = "w-full text-left p-4 rounded-lg border-2 transition-all duration-200 ease-in-out flex items-center justify-start disabled:opacity-60 disabled:cursor-not-allowed shadow-sm hover:shadow-md focus:outline-none";\
    let stateClasses = "";\
\
    if (isChecked) \{\
        if (isCorrectOption) \{\
            stateClasses = "border-green-500 bg-green-100 dark:bg-green-700 text-green-800 dark:text-green-100 font-medium";\
            if (isSelected) stateClasses += " shadow-[0_0_15px_rgba(34,197,94,0.5)]";\
        \} else if (isSelected) \{\
            stateClasses = "border-red-500 bg-red-100 dark:bg-red-700 text-red-800 dark:text-red-100";\
            stateClasses += " shadow-[0_0_15px_rgba(239,68,68,0.5)]";\
        \} else \{\
            stateClasses = "border-slate-300 dark:border-slate-600 bg-slate-100 dark:bg-slate-700 text-slate-500 dark:text-slate-400 opacity-70";\
        \}\
    \} else \{\
        if (isSelected) \{\
            stateClasses = "border-purple-500 dark:border-purple-400 bg-purple-50 dark:bg-purple-800 text-slate-900 dark:text-slate-50 font-medium";\
            stateClasses += " shadow-[0_0_15px_rgba(168,85,247,0.5)]";\
        \} else \{\
            stateClasses = "border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 hover:bg-slate-50 dark:hover:bg-slate-700 text-slate-800 dark:text-slate-200 hover:border-purple-400 dark:hover:border-purple-500";\
        \}\
    \}\
    return `$\{baseClasses\} $\{stateClasses\}`;\
\};\
\
const MultipleChoiceOptions = memo((\{ question, selectedAnswer, answerChecked, selectAnswer \}) => \{\
    if (!question || !Array.isArray(question.options)) \{\
        console.error("MultipleChoiceOptions received invalid question prop:", question);\
        return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (MC).</div>;\
    \}\
    return (\
        <div className="space-y-3">\
            \{question.options.map((option, index) => \{\
                const isSelected = selectedAnswer === index;\
                const isCorrectOption = index === question.correctAnswerIndex;\
                return (\
                    <button\
                        key=\{index\}\
                        onClick=\{() => selectAnswer(index)\}\
                        disabled=\{answerChecked\}\
                        className=\{getOptionButtonClass(isSelected, answerChecked, isCorrectOption)\}\
                        aria-pressed=\{isSelected\}\
                    >\
                        <span className="flex-1 mr-3">\{option\}</span>\
                    </button>\
                );\
            \})\}\
        </div>\
    );\
\});\
MultipleChoiceOptions.displayName = 'MultipleChoiceOptions';\
\
const BentoIconOptions = memo((\{ question, selectedAnswer, answerChecked, selectAnswer \}) => \{\
    if (!question || !Array.isArray(question.options)) \{\
        console.error("BentoIconOptions received invalid question prop:", question);\
        return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (Icon).</div>;\
    \}\
    const columns = question.options.length > 2 ? 'grid-cols-2' : 'grid-cols-1';\
    const IconComponents = \{ CloudSnow, CloudDrizzle, CloudLightning, Cloud, SignalLow, SignalMedium, SignalHigh, Signal, TrendingDown, TrendingUp, Zap \};\
    return (\
        <div className=\{`grid $\{columns\} gap-3`\}>\
            \{question.options.map((option, index) => \{\
                if (!option || typeof option.text !== 'string' || typeof option.icon !== 'string') \{\
                     console.warn("BentoIconOptions skipping invalid option:", option);\
                     return null;\
                \}\
                const isSelected = selectedAnswer === index;\
                const isCorrectOption = index === question.correctAnswerIndex;\
                const IconComponent = IconComponents[option.icon] || Grid;\
                return (\
                    <button\
                        key=\{option.id || index\}\
                        onClick=\{() => selectAnswer(index)\}\
                        disabled=\{answerChecked\}\
                        className=\{`$\{getOptionButtonClass(isSelected, answerChecked, isCorrectOption)\} relative flex-col items-center text-center p-4 h-full`\}\
                        aria-pressed=\{isSelected\}\
                    >\
                        <IconComponent className="w-8 h-8 mb-2 opacity-80 mx-auto" />\
                        <span className="font-medium block mt-1">\{option.text\}</span>\
                    </button>\
                );\
            \})\}\
        </div>\
    );\
\});\
BentoIconOptions.displayName = 'BentoIconOptions';\
\
const BentoPhotoOptions = memo((\{ question, selectedAnswer, answerChecked, selectAnswer \}) => \{\
    if (!question || !Array.isArray(question.options)) \{\
        console.error("BentoPhotoOptions received invalid question prop:", question);\
        return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (Photo).</div>;\
    \}\
    const columns = question.options.length > 2 ? 'grid-cols-2' : 'grid-cols-1';\
    return (\
        <div className=\{`grid $\{columns\} gap-3`\}>\
            \{question.options.map((option, index) => \{\
                 if (!option || typeof option.imageUrl !== 'string') \{\
                     console.warn("BentoPhotoOptions skipping invalid option:", option);\
                     return null;\
                 \}\
                const isSelected = selectedAnswer === index;\
                const isCorrectOption = index === question.correctAnswerIndex;\
                return (\
                    <button\
                        key=\{option.id || index\}\
                        onClick=\{() => selectAnswer(index)\}\
                        disabled=\{answerChecked\}\
                        className=\{`$\{getOptionButtonClass(isSelected, answerChecked, isCorrectOption)\} relative flex-col items-center text-center p-0 overflow-hidden h-full`\}\
                        aria-pressed=\{isSelected\}\
                    >\
                        <img\
                            src=\{option.imageUrl\}\
                            alt=\{option.text || `Op\'e7\'e3o $\{index + 1\}`\}\
                            className="w-full h-24 object-cover"\
                            onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(150, 96, option.text || 'Erro') \}\}\
                        />\
                        <span className="font-medium p-2 pt-1 block">\{option.text || ''\}</span>\
                    </button>\
                );\
            \})\}\
        </div>\
    );\
\});\
BentoPhotoOptions.displayName = 'BentoPhotoOptions';\
\
const FillBlankInput = memo((\{ question, fillBlankInput, answerChecked, isCorrect, handleFillBlankChange, handleFillBlankKeyDown \}) => \{\
    if (!question) \{\
        console.error("FillBlankInput received invalid question prop:", question);\
        return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (FillBlank).</div>;\
    \}\
    const inputClass = useMemo(() => \{\
        let base = "w-full px-4 py-3 rounded-lg border-2 text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-slate-800 focus:ring-purple-500 dark:focus:ring-purple-400 focus:border-purple-500 dark:focus:border-purple-400 transition-all duration-200 shadow-sm";\
        if (answerChecked) \{\
            base += isCorrect\
                ? " border-green-500 dark:border-green-500 bg-green-50 dark:bg-green-700 dark:text-green-100"\
                : " border-red-500 dark:border-red-500 bg-red-50 dark:bg-red-700 dark:text-red-100";\
        \} else \{\
            base += " border-slate-300 dark:border-slate-600 hover:border-slate-400 dark:hover:border-slate-500";\
        \}\
        return base;\
    \}, [answerChecked, isCorrect]);\
    return (\
        <input\
            type="text"\
            value=\{fillBlankInput\}\
            onChange=\{handleFillBlankChange\}\
            onKeyDown=\{handleFillBlankKeyDown\}\
            placeholder=\{question.placeholder || "Digite sua resposta"\}\
            className=\{inputClass\}\
            disabled=\{answerChecked\}\
            aria-label="Resposta para preencher a lacuna"\
        />\
    );\
\});\
FillBlankInput.displayName = 'FillBlankInput';\
\
const SequencingOptions = memo((\{ question, sequencingOrder, answerChecked, isSequenceCorrect, handleSequenceClick \}) => \{\
    if (!question || !Array.isArray(question.items)) \{\
        console.error("SequencingOptions received invalid question prop:", question);\
        return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (Seq).</div>;\
    \}\
    const availableItems = useMemo(() => \{\
        const items = Array.isArray(question?.items) ? question.items : [];\
        return items.filter(item => !sequencingOrder.includes(item));\
    \}, [question?.items, sequencingOrder]);\
    return (\
        <div className="space-y-4">\
            <div className=\{`min-h-[60px] bg-slate-100 dark:bg-slate-700 rounded-lg p-3 border-2 flex flex-wrap gap-2 items-center transition-colors duration-200 $\{ answerChecked ? (isSequenceCorrect ? 'border-green-500 dark:border-green-400' : 'border-red-500 dark:border-red-400') : 'border-slate-300 dark:border-slate-600'\}`\}>\
                \{sequencingOrder.length === 0 && !answerChecked && (\
                    <span className="text-sm text-slate-400 dark:text-slate-500 italic px-2">Clique nos itens abaixo na ordem correta</span>\
                )\}\
                \{sequencingOrder.map((item, index) => (\
                    <span key=\{item\} className="px-3 py-1 bg-purple-600 dark:bg-purple-500 text-white rounded-full text-sm font-medium shadow-sm flex items-center gap-1.5 animate-pop-in">\
                        <span className="font-bold">\{index + 1\}.</span> \{item\}\
                    </span>\
                ))\}\
            </div>\
            <div className="flex flex-wrap gap-2 justify-center">\
                \{availableItems.map((item) => (\
                    <button\
                        key=\{item\}\
                        onClick=\{() => handleSequenceClick(item)\}\
                        disabled=\{answerChecked\}\
                        className="px-4 py-2 bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-600 rounded-lg text-sm font-medium text-slate-800 dark:text-slate-200 hover:bg-purple-50 dark:hover:bg-purple-900/30 hover:border-purple-300 dark:hover:border-purple-600 transition-all duration-150 disabled:opacity-50 disabled:cursor-not-allowed shadow-sm hover:shadow-md active:scale-95 focus:outline-none focus:ring-1 focus:ring-purple-500"\
                    >\
                        \{item\}\
                    </button>\
                ))\}\
            </div>\
        </div>\
    );\
\});\
SequencingOptions.displayName = 'SequencingOptions';\
\
const HotspotOptions = memo((\{ question, selectedHotspot, answerChecked, handleHotspotClick \}) => \{\
     if (!question || !Array.isArray(question.hotspots) || !question.imageUrl) \{\
         console.error("HotspotOptions received invalid question prop:", question);\
         return <div className="text-red-500">Erro: Dados da quest\'e3o inv\'e1lidos (HS).</div>;\
     \}\
    const imageRef = useRef(null);\
    const getHotspotPosition = useCallback((hotspot) => \{ if (!imageRef.current) return \{ top: '50%', left: '50%' \}; const x = hotspot.x ?? 50; const y = hotspot.y ?? 50; return \{ left: `$\{x\}%`, top: `$\{y\}%`, transform: 'translate(-50%, -50%)', \}; \}, []);\
    const getHotspotClass = useCallback((hotspotId) => \{ let base = "absolute w-8 h-8 rounded-full border-2 bg-black/50 backdrop-blur-sm flex items-center justify-center text-white font-bold text-xs transition-all duration-200 hover:bg-black/70 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-black/50 focus:ring-purple-400 disabled:opacity-60 disabled:cursor-not-allowed transform hover:scale-110 active:scale-95"; const isSelected = selectedHotspot === hotspotId; const isCorrectOption = answerChecked && hotspotId === question?.correctHotspotId; if (answerChecked) \{ if (isCorrectOption) \{ base += " border-green-400 bg-green-500/70"; if (isSelected) base += " ring-2 ring-green-300"; \} else if (isSelected) \{ base += " border-red-400 bg-red-500/70 ring-2 ring-red-300"; \} else \{ base += " border-slate-400 opacity-50"; \} \} else \{ base += " border-white/80"; if (isSelected) \{ base += " ring-2 ring-purple-400 border-purple-400"; \} \} return base; \}, [answerChecked, selectedHotspot, question?.correctHotspotId]);\
    return (\
        <div className="relative w-full max-w-md mx-auto aspect-video bg-slate-200 dark:bg-slate-700 rounded-lg overflow-hidden shadow-inner">\
            <img\
                ref=\{imageRef\}\
                src=\{question?.imageUrl\}\
                alt="Imagem da quest\'e3o Hotspot"\
                className="block w-full h-full object-contain"\
                onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(400, 225, 'Erro ao carregar imagem') \}\}\
            />\
            \{question?.hotspots?.map((hotspot, index) => (\
                <button\
                    key=\{hotspot.id\}\
                    className=\{getHotspotClass(hotspot.id)\}\
                    style=\{getHotspotPosition(hotspot)\}\
                    onClick=\{() => handleHotspotClick(hotspot.id)\}\
                    disabled=\{answerChecked\}\
                    aria-label=\{hotspot.label || `Ponto $\{index + 1\}`\}\
                    title=\{hotspot.label\}\
                >\
                    \{index + 1\}\
                </button>\
            ))\}\
        </div>\
    );\
\});\
HotspotOptions.displayName = 'HotspotOptions';\
\
// --- Upgrade Notification Component ---\
const UpgradeNotification = memo((\{ onUpgradeClick, onClose \}) => \{\
    return (\
        <div className="w-full p-4 rounded-xl shadow-lg border border-purple-600/50 dark:border-violet-700/50 flex items-start gap-3 bg-gradient-to-r from-purple-500 to-violet-600 dark:from-purple-700 dark:to-violet-800 animate-fade-in-up">\
            <div className="flex-shrink-0 pt-0.5">\
                <Lock className="w-5 h-5 text-purple-100 dark:text-violet-200" />\
            </div>\
            <div className="flex-grow">\
                <p className="text-sm font-semibold text-purple-100 dark:text-violet-100 mb-1">Funcionalidade Premium!</p>\
                <p className="text-xs text-purple-200 dark:text-violet-300 mb-3">\
                    A explica\'e7\'e3o detalhada est\'e1 dispon\'edvel nos planos Pro ou Ultra.\
                </p>\
                <button\
                    onClick=\{onUpgradeClick\}\
                    className="inline-flex items-center gap-1.5 px-3 py-1 bg-white dark:bg-slate-800 text-purple-700 dark:text-purple-300 text-xs font-bold rounded-md shadow-sm hover:bg-purple-50 dark:hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 dark:focus:ring-offset-violet-700 transition-all duration-150"\
                >\
                    <Sparkles className="w-3.5 h-3.5" />\
                    Fazer upgrade\
                </button>\
            </div>\
            <button\
                onClick=\{onClose\}\
                className="p-1 text-purple-100/70 dark:text-violet-200/70 hover:text-white dark:hover:text-white hover:bg-white/20 dark:hover:bg-black/20 rounded-full focus:outline-none focus:ring-1 focus:ring-white/50"\
                aria-label="Fechar notifica\'e7\'e3o"\
            >\
                <X className="w-4 h-4" />\
            </button>\
        </div>\
    );\
\});\
UpgradeNotification.displayName = 'UpgradeNotification';\
\
\
// --- Feedback Section Component (Simu's Feedback) ---\
const FeedbackSection = memo((\{\
    isCorrect,\
    feedbackTitle,\
    explanation,\
    questionId,\
    onSaveExplanation,\
    onLearnMoreClick,\
    onUpgradeClick,\
    subscriptionPlan, // Receives current user's subscription level\
    className = ""\
\}) => \{\
    // Determine if the feature is locked based on the user's plan\
    const isFeatureLocked = subscriptionPlan === SUBSCRIPTION_PLANS.BASIC;\
    const [showExplanation, setShowExplanation] = useState(false);\
    const [saveStatus, setSaveStatus] = useState(\{ visible: false, text: '', success: true \});\
    const saveButtonRef = useRef(null);\
    const [showUpgradeNotification, setShowUpgradeNotification] = useState(false);\
\
    useEffect(() => \{\
        // Automatically show explanation if incorrect and feature is NOT locked\
        setShowExplanation(!isCorrect && !isFeatureLocked);\
        setShowUpgradeNotification(false); // Reset upgrade notification on new feedback\
    \}, [isCorrect, isFeatureLocked, questionId]); // Depend on questionId to reset state for new questions\
\
    const toggleExplanation = () => \{\
        if (isFeatureLocked) \{\
            // If locked, show/hide the upgrade notification instead of explanation\
            setShowUpgradeNotification(prev => !prev);\
        \} else \{\
            // If not locked, toggle the explanation visibility\
            setShowExplanation(prev => !prev);\
            setShowUpgradeNotification(false); // Ensure upgrade notification is hidden\
        \}\
    \};\
\
    const closeUpgradeNotification = useCallback(() => \{\
        setShowUpgradeNotification(false);\
    \}, []);\
\
    const handleSaveClick = useCallback(() => \{\
        // Check if saving is locked for the current plan\
        if (subscriptionPlan === SUBSCRIPTION_PLANS.BASIC) \{ // Example: Only Pro/Ultra can save\
             setShowUpgradeNotification(true); // Show upgrade prompt instead\
            return;\
        \}\
        // Proceed with saving if allowed\
        if (explanation && questionId) \{\
            const result = onSaveExplanation(questionId, explanation); // Get result from handler\
            setSaveStatus(\{ visible: true, text: result.message, success: result.success \});\
            // Hide the status message after a short delay\
            setTimeout(() => setSaveStatus(prev => (\{ ...prev, visible: false \})), 1500);\
        \}\
    \}, [explanation, questionId, onSaveExplanation, subscriptionPlan]); // Depend on subscriptionPlan\
\
     const handleLearnMore = useCallback(() => \{\
        // Check if "Learn More" is locked for the current plan\
        if (subscriptionPlan === SUBSCRIPTION_PLANS.BASIC) \{ // Example: Only Pro/Ultra can learn more\
            setShowUpgradeNotification(true); // Show upgrade prompt instead\
            return;\
        \}\
        // Proceed if allowed\
        onLearnMoreClick();\
    \}, [subscriptionPlan, onLearnMoreClick]); // Depend on subscriptionPlan\
\
    // Styling Constants\
    const cardBaseClasses = `w-full rounded-xl shadow-lg border relative transition-all duration-300 ease-in-out animate-fade-in-up`;\
    const feedbackCardBg = isCorrect ? 'bg-gradient-to-br from-green-50 via-green-100 to-green-200 dark:from-green-800 dark:via-green-700 dark:to-green-600' : 'bg-gradient-to-br from-red-50 via-red-100 to-red-200 dark:from-red-800 dark:via-red-700 dark:to-red-600';\
    const feedbackBorderColor = isCorrect ? 'border-green-200 dark:border-green-600' : 'border-red-200 dark:border-red-600';\
    const Icon = isCorrect ? CheckCircle : XCircle;\
    const iconColor = isCorrect ? 'text-green-600 dark:text-green-300' : 'text-red-600 dark:text-red-300';\
    const iconBgColor = isCorrect ? 'bg-green-100 dark:bg-green-600' : 'bg-red-100 dark:bg-red-600';\
    const titleColor = iconColor;\
    const explanationCardBg = 'bg-gradient-to-br from-purple-50 via-purple-100 to-violet-100 dark:from-purple-800 dark:via-purple-700 dark:to-violet-700';\
    const explanationBorderColor = 'border-purple-200 dark:border-purple-600/80';\
    const actionButtonClass = `relative flex items-center justify-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-md transition-colors duration-150 border border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 hover:border-slate-400 dark:hover:border-slate-500 focus:outline-none focus:ring-1 focus:ring-purple-500 focus:ring-offset-1 dark:focus:ring-offset-slate-800 disabled:opacity-50 disabled:cursor-not-allowed`;\
    // Adjust Learn More button style based on lock status\
    const learnMoreButtonClass = `px-3 py-1 text-xs font-semibold rounded-md transition-colors duration-150 focus:outline-none focus:ring-1 focus:ring-purple-400 $\{isFeatureLocked ? 'text-slate-400 bg-slate-200 dark:bg-slate-700 cursor-not-allowed opacity-70' : 'text-purple-600 dark:text-purple-300 hover:text-purple-800 dark:hover:text-purple-100 bg-purple-100/50 dark:bg-purple-900/50 hover:bg-purple-100 dark:hover:bg-purple-800/70'\}`;\
    // Adjust Save button style based on lock status\
    const saveButtonClass = `$\{actionButtonClass\} $\{subscriptionPlan === SUBSCRIPTION_PLANS.BASIC ? 'opacity-50 cursor-not-allowed' : ''\}`;\
    const chatBubbleTail = `after:content-[''] after:absolute after:top-4 after:-left-2 after:w-0 after:h-0 after:border-t-[8px] after:border-t-transparent after:border-b-[8px] after:border-b-transparent after:border-r-[8px] after:border-r-purple-100 dark:after:border-r-purple-800`;\
\
    return (\
        <div className=\{`space-y-4 $\{className\}`\}>\
            \{/* Card 1: Main Feedback */\}\
            <div className=\{`$\{cardBaseClasses\} $\{feedbackCardBg\} $\{feedbackBorderColor\} p-6`\}>\
                <div className="flex items-center">\
                    <div className=\{`flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center mr-3 $\{iconBgColor\}`\}>\
                        <Icon className=\{`w-5 h-5 $\{iconColor\}`\} />\
                    </div>\
                    <h4 className=\{`text-lg md:text-xl font-semibold $\{titleColor\}`\}>\{feedbackTitle\}</h4>\
                </div>\
            </div>\
\
            \{/* "Entenda o porqu\'ea" button - Always visible if there's an explanation */\}\
            \{explanation && (\
                 <div className=\{`animate-fade-in-up`\}>\
                     <button\
                         onClick=\{toggleExplanation\}\
                         aria-expanded=\{showExplanation && !isFeatureLocked\} // Expanded only if shown and not locked\
                         className=\{`flex w-full items-center justify-center gap-2 text-sm md:text-base font-medium focus:outline-none p-3 rounded-xl shadow-md transition-all duration-200 z-20 relative $\{isFeatureLocked ? 'text-slate-500 dark:text-slate-400 bg-slate-100 dark:bg-slate-700/50 border border-slate-300 dark:border-slate-600 cursor-pointer hover:shadow-lg' : `text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 hover:shadow-lg $\{explanationCardBg\} $\{explanationBorderColor\}`\}`\}\
                     >\
                         \{/* Show lock icon if feature is locked */\}\
                         \{isFeatureLocked ? <Lock className="w-4 h-4 md:w-5 md:h-5 text-slate-400" /> : <Info className="w-4 h-4 md:w-5 md:h-5" />\}\
                         Entenda o porqu\'ea\
                     </button>\
                 </div>\
             )\}\
\
            \{/* Upgrade Notification - Shown when trying to access locked feature */\}\
            \{showUpgradeNotification && isFeatureLocked && (\
                <UpgradeNotification onUpgradeClick=\{onUpgradeClick\} onClose=\{closeUpgradeNotification\} />\
            )\}\
\
            \{/* Card 2: Simu Explica - Shown only if explanation exists, is toggled on, AND feature is NOT locked */\}\
            \{explanation && showExplanation && !isFeatureLocked && (\
                <div className="flex items-start gap-3 animate-fade-in-up">\
                    <div className="flex-shrink-0 w-12 h-12 rounded-full bg-yellow-100 dark:bg-yellow-900/50 flex items-center justify-center overflow-hidden shadow-md border-2 border-white dark:border-slate-700 mt-2">\
                         <img src="https://i.imgur.com/hwYnMXe.png" alt="Simu avatar" className="w-full h-full object-cover" onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(48, 48, 'S') \}\} />\
                    </div>\
                    <div className=\{`$\{cardBaseClasses\} $\{explanationCardBg\} $\{explanationBorderColor\} p-4 flex-grow $\{chatBubbleTail\}`\}>\
                         <div className="space-y-3">\
                            <p className="text-sm md:text-base text-slate-700 dark:text-slate-300">\
                                \{explanation\}\
                            </p>\
                            <div className="flex justify-between items-center pt-3 border-t border-purple-200/50 dark:border-purple-700/30 mt-3">\
                                \{/* Learn More Button - Disabled styling applied via className */\}\
                                <button onClick=\{handleLearnMore\} disabled=\{isFeatureLocked\} aria-disabled=\{isFeatureLocked\} className=\{learnMoreButtonClass\} title=\{isFeatureLocked ? "Recurso Premium" : "Saiba mais sobre o assunto"\}>\
                                    \{isFeatureLocked ? <Lock className="w-3 h-3 inline-block mr-1" /> : null\}\
                                    Saiba Mais\
                                </button>\
                                <div className="relative">\
                                     \{/* Save Button - Disabled styling applied via className */\}\
                                    <button ref=\{saveButtonRef\} onClick=\{handleSaveClick\} className=\{saveButtonClass\} title=\{subscriptionPlan === SUBSCRIPTION_PLANS.BASIC ? "Recurso Premium" : "Salvar explica\'e7\'e3o"\} disabled=\{subscriptionPlan === SUBSCRIPTION_PLANS.BASIC\} aria-disabled=\{subscriptionPlan === SUBSCRIPTION_PLANS.BASIC\}>\
                                        \{subscriptionPlan === SUBSCRIPTION_PLANS.BASIC ? <Lock className="w-4 h-4 text-slate-400" /> : <Bookmark className="w-4 h-4" />\}\
                                    </button>\
                                    \{/* Save status feedback */\}\
                                    \{saveStatus.visible && (\
                                        <div className=\{`absolute bottom-full left-1/2 -translate-x-1/2 mb-1.5 px-2 py-0.5 rounded-md text-xs font-semibold shadow-md whitespace-nowrap transition-all duration-200 ease-in-out animate-fade-in-up z-50 $\{saveStatus.success ? 'bg-green-500 text-white' : 'bg-yellow-500 text-black'\}`\}>\
                                            \{saveStatus.text\}\
                                        </div>\
                                    )\}\
                                </div>\
                            </div>\
                        </div>\
                    </div>\
                </div>\
            )\}\
        </div>\
    );\
\});\
FeedbackSection.displayName = 'FeedbackSection';\
\
\
// --- Game Over Screen ---\
const GameOverScreenComponent = (\{ score, totalQuestions, totalTime, avgTimePerQuestion, subjectStats, onRestart \}) => \{\
    const percentage = totalQuestions > 0 ? Math.round((score / totalQuestions) * 100) : 0;\
    const patent = useMemo(() => getPatentForPercentage(percentage), [percentage]);\
    const performanceStats = useMemo(() => \{\
        if (!subjectStats || Object.keys(subjectStats).length === 0) \{\
            return \{ bestSubjects: [], worstSubjects: [], overallPercentage: null \};\
        \}\
        const statsArray = Object.entries(subjectStats).map(([name, data]) => (\{\
            name,\
            ...data,\
            percentage: data.total > 0 ? (data.correct / data.total) * 100 : 0,\
        \}));\
        const overallPercentage = totalQuestions > 0 ? (score / totalQuestions) * 100 : null;\
        const sortedByPerformance = [...statsArray].sort((a, b) => b.percentage - a.percentage);\
        const sortedByErrors = [...statsArray].sort((a, b) => \{\
            if (a.incorrect !== b.incorrect) return b.incorrect - a.incorrect;\
            if (a.total !== b.total) return b.total - a.total;\
            return a.percentage - b.percentage;\
        \});\
        return \{\
            bestSubjects: sortedByPerformance.filter(s => s.total > 0),\
            worstSubjects: sortedByErrors.filter(s => s.incorrect > 0),\
            overallPercentage,\
        \};\
    \}, [subjectStats, score, totalQuestions]);\
\
    return (\
        <div className="w-full md:max-w-3xl bg-slate-50 dark:bg-slate-800 md:shadow-2xl md:rounded-2xl flex flex-col overflow-hidden animate-fade-in">\
            <div className="bg-gradient-to-br from-green-500 to-teal-600 text-white p-6 md:p-8 text-center shadow-lg relative overflow-hidden">\
                <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px]"></div>\
                <Trophy className="w-16 h-16 mx-auto mb-4 text-yellow-300 drop-shadow-lg relative z-10 animate-pop-in" style=\{\{ animationDelay: '0.1s' \}\}/>\
                <h2 className="text-3xl md:text-4xl font-bold mb-2 relative z-10 animate-pop-in" style=\{\{ animationDelay: '0.2s' \}\}>Quiz Finalizado!</h2>\
                <p className="text-lg text-green-100 relative z-10 animate-pop-in" style=\{\{ animationDelay: '0.3s' \}\}>Confira seu desempenho abaixo:</p>\
            </div>\
            <div className="p-4 sm:p-6 md:p-8 text-center flex-grow overflow-y-auto space-y-6 max-h-[calc(100vh-250px)] md:max-h-none">\
                <div className="flex flex-col sm:flex-row justify-center items-center gap-4 sm:gap-8 mb-6 animate-fade-in-up" style=\{\{ animationDelay: '0.4s' \}\}>\
                    <div className="text-center">\
                        <div className="text-4xl font-bold text-slate-800 dark:text-slate-100">\{score\} / \{totalQuestions\}</div>\
                        <div className="text-sm text-slate-500 dark:text-slate-400">Acertos</div>\
                    </div>\
                    \{patent && <PatentBadge patent=\{patent\} />\}\
                </div>\
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6 animate-fade-in-up" style=\{\{ animationDelay: '0.5s' \}\}>\
                    <PerformanceCard title="Desempenho Geral" icon=\{TrendingUp\} percentage=\{performanceStats.overallPercentage\} bestOrWorstSubjects=\{performanceStats.bestSubjects\} subjectLabel="Taxa de Acerto" />\
                    <PerformanceCard title="Pontos a Melhorar" icon=\{TrendingDown\} percentage=\{performanceStats.worstSubjects.length > 0 ? performanceStats.worstSubjects[0].percentage : null\} bestOrWorstSubjects=\{performanceStats.worstSubjects\} subjectLabel=\{performanceStats.worstSubjects.length > 0 ? `Acerto em $\{performanceStats.worstSubjects[0].name\}` : "Mat\'e9rias c/ Erros"\} />\
                    <StatsCard title="Tempo" icon=\{Timer\} iconBgColor="bg-blue-100 dark:bg-blue-900/50" iconTextColor="text-blue-600 dark:text-blue-400">\
                        <div className="space-y-3 text-center">\
                            <div><div className="text-2xl font-semibold text-slate-700 dark:text-slate-200">\{formatTimeMMSS(totalTime)\}</div><div className="text-xs text-slate-500 dark:text-slate-400">Tempo Total</div></div>\
                            <div><div className="text-2xl font-semibold text-slate-700 dark:text-slate-200">\{formatAvgTimeSec(avgTimePerQuestion)\}</div><div className="text-xs text-slate-500 dark:text-slate-400">Tempo M\'e9dio / Quest\'e3o</div></div>\
                        </div>\
                    </StatsCard>\
                </div>\
                <button onClick=\{onRestart\} className="mt-8 px-10 py-3 bg-gradient-to-r from-purple-600 to-violet-600 hover:from-purple-700 hover:to-violet-700 text-white text-lg font-semibold rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-purple-300 dark:focus:ring-purple-500 flex items-center justify-center gap-2 mx-auto active:scale-95 animate-fade-in-up" style=\{\{ animationDelay: '0.6s' \}\}><RefreshCw className="w-5 h-5" /> Jogar Novamente</button>\
            </div>\
        </div>\
    );\
\};\
const GameOverScreen = memo(GameOverScreenComponent);\
GameOverScreen.displayName = 'GameOverScreen';\
\
\
// --- Main Quiz Game Component ---\
const QuizGame = memo(forwardRef((\{\
    activeSelectedSubjects,\
    activeNumQuestions,\
    onReturnToConfig,\
    onSaveExplanation,\
    onLearnMoreClick,\
    onUpgradeClick,\
    subscriptionPlan // Receive current user's subscription level\
 \}, ref) => \{\
    // Internal state for the action button\
    const [actionButtonState, setActionButtonState] = useState(ACTION_BUTTON_STATES.HIDDEN);\
\
    // Quiz gameplay states\
    const [questionsData, setQuestionsData] = useState([]);\
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);\
    const [selectedAnswer, setSelectedAnswer] = useState(null);\
    const [fillBlankInput, setFillBlankInput] = useState('');\
    const [sequencingOrder, setSequencingOrder] = useState([]);\
    const [selectedHotspot, setSelectedHotspot] = useState(null);\
    const [answerChecked, setAnswerChecked] = useState(false);\
    const [isCorrect, setIsCorrect] = useState(false);\
    const [isSequenceCorrect, setIsSequenceCorrect] = useState(false);\
    const [score, setScore] = useState(0);\
    const [feedbackTitle, setFeedbackTitle] = useState('');\
    const [gameFinished, setGameFinished] = useState(false);\
    const [isLoading, setIsLoading] = useState(true);\
    const [error, setError] = useState(null);\
    const [startTime, setStartTime] = useState(null);\
    const [endTime, setEndTime] = useState(null);\
    const [questionStartTime, setQuestionStartTime] = useState(null);\
    const [timePerQuestion, setTimePerQuestion] = useState([]);\
    const [subjectStats, setSubjectStats] = useState(\{\});\
    const [isShaking, setIsShaking] = useState(false);\
\
    const questionCardRef = useRef(null);\
    const desktopFeedbackContainerRef = useRef(null);\
\
    // Effect to initialize or reset the quiz\
    useEffect(() => \{\
        setIsLoading(true);\
        setError(null);\
        setGameFinished(false);\
        setActionButtonState(ACTION_BUTTON_STATES.HIDDEN);\
        try \{\
            let filteredQuestions = ORIGINAL_MOCK_QUESTIONS;\
            if (activeSelectedSubjects && activeSelectedSubjects.length > 0) \{\
                filteredQuestions = ORIGINAL_MOCK_QUESTIONS.filter(q => q.subject && activeSelectedSubjects.includes(q.subject));\
            \}\
            const shuffledQuestions = shuffleArray(filteredQuestions);\
            const finalQuestions = shuffledQuestions.slice(0, activeNumQuestions);\
            if (finalQuestions.length === 0) \{\
                console.error("QuizGame Effect: No questions found for selected subjects:", activeSelectedSubjects);\
                setError("Nenhuma quest\'e3o encontrada para as mat\'e9rias selecionadas.");\
                setQuestionsData([]);\
                setIsLoading(false);\
                return;\
            \}\
            const initialStats = \{\};\
            const subjectsInQuiz = new Set(finalQuestions.map(q => q.subject).filter(Boolean));\
            subjectsInQuiz.forEach(subj => \{ initialStats[subj] = \{ correct: 0, incorrect: 0, total: 0 \}; \});\
            activeSelectedSubjects?.forEach(subj => \{\
                if (!initialStats[subj]) \{\
                    initialStats[subj] = \{ correct: 0, incorrect: 0, total: 0 \};\
                \}\
            \});\
\
            setSubjectStats(initialStats);\
            setQuestionsData(finalQuestions);\
            setCurrentQuestionIndex(0);\
            setScore(0);\
            setStartTime(Date.now());\
            setQuestionStartTime(Date.now());\
            setTimePerQuestion([]);\
            setIsLoading(false);\
        \} catch (err) \{\
            console.error("Erro ao carregar quest\'f5es:", err);\
            setError(err.message || "Falha ao carregar.");\
            setQuestionsData([]);\
            setIsLoading(false);\
        \}\
        setSelectedAnswer(null);\
        setFillBlankInput('');\
        setSequencingOrder([]);\
        setSelectedHotspot(null);\
        setAnswerChecked(false);\
        setIsCorrect(false);\
        setIsSequenceCorrect(false);\
        setFeedbackTitle('');\
        setEndTime(null);\
        setIsShaking(false);\
    \}, [activeSelectedSubjects, activeNumQuestions]);\
\
    // Memoized current question object\
    const currentQuestion = useMemo(() => \{\
        if (isLoading || error || gameFinished || !questionsData || questionsData.length === 0 || currentQuestionIndex >= questionsData.length) return null;\
        return questionsData[currentQuestionIndex];\
    \}, [isLoading, error, gameFinished, questionsData, currentQuestionIndex]);\
\
    // Memoized visual style for the current subject\
    const subjectVisual = useMemo(() => \{\
        if (!currentQuestion) return SUBJECT_VISUALS.Default;\
        return SUBJECT_VISUALS[currentQuestion.subject] || SUBJECT_VISUALS.Default;\
    \}, [currentQuestion]);\
\
    // Answer Selection Handlers\
    const handleSelectAnswer = useCallback((index) => \{ if (!answerChecked) setSelectedAnswer(index); \}, [answerChecked]);\
    const handleFillBlankChange = useCallback((event) => \{ if (!answerChecked) setFillBlankInput(event.target.value); \}, [answerChecked]);\
    const handleSequenceClick = useCallback((item) => \{ if (!answerChecked) setSequencingOrder(prev => [...prev, item]); \}, [answerChecked]);\
    const handleHotspotClick = useCallback((hotspotId) => \{ if (!answerChecked) setSelectedHotspot(hotspotId); \}, [answerChecked]);\
\
    // Check Answer Logic\
    const checkAnswer = useCallback(() => \{\
        if (!currentQuestion || answerChecked || isLoading || error) return;\
        let correct = false;\
        let sequenceCorrect = false;\
        switch (currentQuestion.type) \{\
            case QUESTION_TYPES.MULTIPLE_CHOICE: case QUESTION_TYPES.BENTO_ICON: case QUESTION_TYPES.BENTO_PHOTO: correct = selectedAnswer === currentQuestion.correctAnswerIndex; break;\
            case QUESTION_TYPES.FILL_BLANK: correct = typeof currentQuestion.correctAnswer === 'string' && fillBlankInput.trim().toLowerCase() === currentQuestion.correctAnswer.toLowerCase(); break;\
            case QUESTION_TYPES.SEQUENCING: const expected = Array.isArray(currentQuestion.items) ? currentQuestion.items : []; correct = sequencingOrder.length === expected.length && sequencingOrder.every((item, index) => item === expected[index]); sequenceCorrect = correct; break;\
            case QUESTION_TYPES.HOTSPOT: correct = selectedHotspot === currentQuestion.correctHotspotId; break;\
            default: console.warn("Tipo de quest\'e3o n\'e3o suportado:", currentQuestion.type); setActionButtonState(ACTION_BUTTON_STATES.HIDDEN); return;\
        \}\
        const newFeedbackTitle = correct ? CORRECT_FEEDBACK_TITLES[Math.floor(Math.random() * CORRECT_FEEDBACK_TITLES.length)] : INCORRECT_FEEDBACK_TITLES[Math.floor(Math.random() * INCORRECT_FEEDBACK_TITLES.length)];\
        if (correct) \{ setScore(prev => prev + 1); triggerVibration(100); \}\
        else \{ triggerVibration([100, 50, 100]); setIsShaking(true); setTimeout(() => setIsShaking(false), 500); \}\
        if (currentQuestion.subject && subjectStats.hasOwnProperty(currentQuestion.subject)) \{\
             setSubjectStats(prev => \{\
                 const subj = currentQuestion.subject;\
                 const newStats = \{ ...prev \};\
                 if (!newStats[subj]) \{\
                     console.warn(`Subject $\{subj\} not found in stats, initializing.`);\
                     newStats[subj] = \{ correct: 0, incorrect: 0, total: 0 \};\
                 \}\
                 newStats[subj] = \{\
                     correct: newStats[subj].correct + (correct ? 1 : 0),\
                     incorrect: newStats[subj].incorrect + (correct ? 0 : 1),\
                     total: newStats[subj].total + 1,\
                 \};\
                 return newStats;\
             \});\
        \} else \{\
             console.warn(`Subject "$\{currentQuestion.subject\}" not found in initial stats object.`);\
        \}\
        const timeTaken = Date.now() - questionStartTime;\
        setTimePerQuestion(prev => [...prev, timeTaken]);\
        setIsCorrect(correct);\
        setIsSequenceCorrect(sequenceCorrect);\
        setFeedbackTitle(newFeedbackTitle);\
        setAnswerChecked(true);\
        const nextButtonState = currentQuestionIndex >= questionsData.length - 1 ? ACTION_BUTTON_STATES.FINISHED_RESTARTABLE : (correct ? ACTION_BUTTON_STATES.CORRECT : ACTION_BUTTON_STATES.INCORRECT);\
        setActionButtonState(nextButtonState);\
\
        // Scroll feedback into view\
        if (window.innerWidth >= 768) \{ // Desktop\
            setTimeout(() => \{ desktopFeedbackContainerRef.current?.scrollIntoView(\{ behavior: 'smooth', block: 'center' \}); \}, 100);\
        \} else \{ // Mobile\
             setTimeout(() => \{ questionCardRef.current?.scrollIntoView(\{ behavior: 'smooth', block: 'start' \}); \}, 100);\
        \}\
\
    \}, [ currentQuestion, answerChecked, isLoading, error, selectedAnswer, fillBlankInput, sequencingOrder, selectedHotspot, questionStartTime, subjectStats, questionsData, currentQuestionIndex ]);\
\
    // Go to Next Question Logic\
    const nextQuestion = useCallback(() => \{\
        if (!answerChecked || isLoading || error || gameFinished) return;\
        const nextIndex = currentQuestionIndex + 1;\
        if (nextIndex < questionsData.length) \{\
            setCurrentQuestionIndex(nextIndex);\
            setSelectedAnswer(null);\
            setFillBlankInput('');\
            setSequencingOrder([]);\
            setSelectedHotspot(null);\
            setAnswerChecked(false);\
            setIsCorrect(false);\
            setIsSequenceCorrect(false);\
            setFeedbackTitle('');\
            setQuestionStartTime(Date.now());\
            setIsShaking(false);\
            setActionButtonState(ACTION_BUTTON_STATES.HIDDEN); // Hide button until answer selected\
            questionCardRef.current?.scrollIntoView(\{ behavior: 'smooth', block: 'start' \});\
        \} else \{\
            // Game finished\
            setGameFinished(true);\
            setEndTime(Date.now());\
            setAnswerChecked(false); // Allow interaction with the game over screen\
        \}\
    \}, [ answerChecked, isLoading, error, gameFinished, currentQuestionIndex, questionsData?.length ]);\
\
    // Expose actions via ref (if needed by parent, e.g., for external controls)\
     useImperativeHandle(ref, () => (\{ triggerCheckAnswer: checkAnswer, triggerNextQuestion: nextQuestion \}), [checkAnswer, nextQuestion]);\
\
    // Determine if Verification is Possible (answer is selected/filled)\
    const isVerificationPossible = useMemo(() => \{\
        if (!currentQuestion || answerChecked || isLoading || error) return false;\
        switch (currentQuestion.type) \{\
            case QUESTION_TYPES.MULTIPLE_CHOICE: case QUESTION_TYPES.BENTO_ICON: case QUESTION_TYPES.BENTO_PHOTO: return selectedAnswer !== null;\
            case QUESTION_TYPES.FILL_BLANK: return fillBlankInput.trim() !== '';\
            case QUESTION_TYPES.SEQUENCING: const items = Array.isArray(currentQuestion.items) ? currentQuestion.items : []; return sequencingOrder.length === items.length;\
            case QUESTION_TYPES.HOTSPOT: return selectedHotspot !== null;\
            default: return false;\
        \}\
    \}, [currentQuestion, answerChecked, isLoading, error, selectedAnswer, fillBlankInput, sequencingOrder, selectedHotspot]);\
\
    // Effect to Update Action Button State based on answer selection\
     useEffect(() => \{\
        if (!answerChecked && !gameFinished && !isLoading && !error) \{\
            // Show "Ready" state only when an answer is selected/filled\
            const newState = isVerificationPossible ? ACTION_BUTTON_STATES.READY : ACTION_BUTTON_STATES.HIDDEN;\
            setActionButtonState(newState);\
        \}\
     \}, [isVerificationPossible, answerChecked, gameFinished, isLoading, error]);\
\
\
    // Action Button Click Handler\
    const handleActionClick = useCallback(() => \{\
        triggerVibration(50); // Haptic feedback\
        switch (actionButtonState) \{\
            case ACTION_BUTTON_STATES.READY:\
                setActionButtonState(ACTION_BUTTON_STATES.LOADING); // Show loading spinner briefly\
                setTimeout(() => \{ checkAnswer(); \}, 10); // Check answer after a tiny delay\
                break;\
            case ACTION_BUTTON_STATES.CORRECT:\
            case ACTION_BUTTON_STATES.INCORRECT:\
                nextQuestion(); // Move to the next question\
                break;\
            case ACTION_BUTTON_STATES.FINISHED_RESTARTABLE:\
                onReturnToConfig(); // Go back to configuration screen\
                break;\
            default:\
                console.warn(`Action Button: Click ignored in state - $\{actionButtonState\}`);\
        \}\
    \}, [actionButtonState, checkAnswer, nextQuestion, onReturnToConfig]);\
\
\
    // Keyboard Handler (e.g., Enter key for Fill-in-the-blank)\
    const handleFillBlankKeyDown = useCallback((event) => \{\
        if (event.key === 'Enter' && !answerChecked && fillBlankInput.trim() && isVerificationPossible) \{\
            event.preventDefault(); // Prevent form submission\
            handleActionClick(); // Trigger the same action as clicking the button\
        \}\
    \}, [answerChecked, fillBlankInput, isVerificationPossible, handleActionClick]);\
\
\
    // Action Button Rendering Logic\
    const renderActionButton = () => \{\
        const currentFabState = actionButtonState;\
        let ActionIcon = null, fabBgClasses = "", fabIconColor = "text-white", actionButtonLabel = "", fabDisabled = false, showFab = false;\
\
        // Determine button appearance based on state\
        if (currentFabState !== ACTION_BUTTON_STATES.HIDDEN && !gameFinished) \{\
            showFab = true;\
            switch (currentFabState) \{\
                case ACTION_BUTTON_STATES.READY: ActionIcon = Check; fabBgClasses = "bg-purple-600 hover:bg-purple-700 focus:ring-purple-500"; actionButtonLabel = "Verificar"; break;\
                case ACTION_BUTTON_STATES.LOADING: ActionIcon = Loader2; fabBgClasses = "bg-slate-400 cursor-wait"; fabIconColor = "text-slate-100"; actionButtonLabel = "Verificando"; fabDisabled = true; break;\
                case ACTION_BUTTON_STATES.CORRECT: ActionIcon = ArrowRight; fabBgClasses = "bg-green-500 hover:bg-green-600 focus:ring-green-500"; actionButtonLabel = "Pr\'f3xima"; break;\
                case ACTION_BUTTON_STATES.INCORRECT: ActionIcon = ArrowRight; fabBgClasses = "bg-red-500 hover:bg-red-600 focus:ring-red-500"; actionButtonLabel = "Pr\'f3xima"; break;\
                case ACTION_BUTTON_STATES.FINISHED_RESTARTABLE: ActionIcon = RefreshCw; fabBgClasses = "bg-purple-500 hover:bg-purple-600 focus:ring-purple-300"; actionButtonLabel = "Reiniciar"; break; // This state might be handled by GameOverScreen now\
                default: ActionIcon = null; showFab = false;\
            \}\
        \}\
\
        // Common classes for the button\
        const commonButtonClasses = `w-16 h-16 rounded-full $\{fabBgClasses\} $\{fabIconColor\} flex items-center justify-center shadow-xl focus:outline-none focus:ring-4 dark:focus:ring-opacity-50 transform transition-all duration-200 ease-in-out hover:scale-105 active:scale-95`;\
        // Positioning for mobile FAB\
        const mobileFabClasses = `fixed bottom-24 right-4 z-40 pointer-events-none`;\
        // Positioning for desktop button (integrated with card)\
        const desktopFabContainerClasses = `hidden md:flex justify-center items-center absolute -bottom-8 left-1/2 -translate-x-1/2 z-20 pointer-events-none`;\
        // Control visibility and interaction\
        const visibilityClasses = showFab ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none';\
\
        return (\
            <>\
                \{/* Mobile FAB */\}\
                <div className=\{`md:hidden $\{mobileFabClasses\}`\}>\
                    <div className=\{`transition-opacity duration-300 ease-in-out $\{visibilityClasses\}`\}>\
                        \{ActionIcon && (\
                            <button onClick=\{handleActionClick\} disabled=\{fabDisabled\} className=\{`$\{commonButtonClasses\} bg-opacity-90 dark:bg-opacity-90 backdrop-blur-md`\} aria-label=\{actionButtonLabel\} title=\{actionButtonLabel\}>\
                                <ActionIcon className=\{`w-8 h-8 $\{currentFabState === ACTION_BUTTON_STATES.LOADING ? 'animate-spin' : ''\}`\} />\
                            </button>\
                        )\}\
                    </div>\
                </div>\
                \{/* Desktop Button (integrated with card) */\}\
                <div className=\{desktopFabContainerClasses\}>\
                    <div className=\{`transition-opacity duration-300 ease-in-out $\{visibilityClasses\}`\}>\
                        \{ActionIcon && (\
                            <button onClick=\{handleActionClick\} disabled=\{fabDisabled\} className=\{commonButtonClasses\} aria-label=\{actionButtonLabel\} title=\{actionButtonLabel\}>\
                                <ActionIcon className=\{`w-8 h-8 $\{currentFabState === ACTION_BUTTON_STATES.LOADING ? 'animate-spin' : ''\}`\} />\
                            </button>\
                        )\}\
                    </div>\
                </div>\
            </>\
        );\
    \};\
\
\
    // Main Render Logic\
    if (isLoading) \{ return ( <div className="flex justify-center items-center h-64 w-full"><Loader2 className="w-12 h-12 animate-spin text-purple-500" /><span className="ml-4 text-lg text-slate-600 dark:text-slate-400">Carregando Quiz...</span></div> ); \}\
    if (error) \{ return ( <div className="p-6 bg-red-100 dark:bg-red-900/30 border border-red-300 dark:border-red-600 rounded-lg text-center shadow-md max-w-md mx-auto"><AlertCircle className="w-12 h-12 mx-auto text-red-500 mb-3" /><h3 className="text-xl font-semibold text-red-800 dark:text-red-200 mb-2">Erro ao Carregar</h3><p className="text-red-700 dark:text-red-300 mb-4">\{error\}</p><button onClick=\{onReturnToConfig\} className="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-red-400 focus:ring-offset-2 dark:focus:ring-offset-red-900/30">Voltar \'e0 Configura\'e7\'e3o</button></div> ); \}\
    if (gameFinished) \{ const totalTime = endTime ? endTime - startTime : 0; const avgTime = timePerQuestion.length > 0 ? timePerQuestion.reduce((sum, time) => sum + time, 0) / timePerQuestion.length : 0; return ( <GameOverScreen score=\{score\} totalQuestions=\{questionsData.length\} totalTime=\{totalTime\} avgTimePerQuestion=\{avgTime\} subjectStats=\{subjectStats\} onRestart=\{onReturnToConfig\} /> ); \}\
    if (!currentQuestion || typeof currentQuestion.id === 'undefined') \{ return ( <div className="flex justify-center items-center h-64 text-slate-500 dark:text-slate-400">Nenhuma quest\'e3o para exibir. Verifique a configura\'e7\'e3o ou aguarde.</div> ); \}\
\
    return (\
        <div className="w-full animate-fade-in">\
            \{/* Mobile Layout */\}\
            <div className="md:hidden flex flex-col">\
                \{/* Question Card (Mobile) */\}\
                <div ref=\{questionCardRef\} className=\{`relative overflow-hidden w-full bg-white dark:bg-slate-800 flex flex-col transition-all duration-500 ease-in-out $\{isShaking ? 'animate-shake' : ''\} mb-4 md:rounded-lg md:shadow-md`\} >\
                     \{/* Header */\}\
                     <div className=\{`sticky top-0 z-10 px-5 pb-5 text-white bg-gradient-to-r $\{subjectVisual.gradient\} shadow-md md:rounded-t-lg`\}>\
                         <div className="flex justify-between items-center mb-3 pt-4">\
                             <div className="flex items-center gap-2 text-sm bg-black/20 px-3 py-1 rounded-full backdrop-blur-sm"><subjectVisual.icon className="w-4 h-4 opacity-80" /><span>\{currentQuestion.subject || 'Geral'\}</span></div>\
                             <button onClick=\{onReturnToConfig\} className="p-1.5 rounded-full text-white/70 hover:text-white hover:bg-black/20 transition-colors duration-150 focus:outline-none focus:ring-2 focus:ring-white/50 active:bg-black/30" aria-label="Fechar Quiz" title="Fechar Quiz"><X className="w-5 h-5" /></button>\
                         </div>\
                         <p className="text-lg font-semibold mb-4 min-h-[2.5em]">\
                             \{currentQuestion.question || <span className="text-white/70 italic">Carregando quest\'e3o...</span>\}\
                         </p>\
                         <ProgressBar percentage=\{((currentQuestionIndex + 1) / questionsData.length) * 100\} />\
                     </div>\
\
                     \{/* Options Area - Disabled visually when answer is checked */\}\
                     <div className=\{`p-5 flex-grow min-h-[200px] transition-opacity duration-300 ease-in-out $\{answerChecked && !gameFinished ? 'opacity-50 pointer-events-none' : ''\}`\}>\
                        \{currentQuestion.type === QUESTION_TYPES.MULTIPLE_CHOICE && (<MultipleChoiceOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.BENTO_ICON && (<BentoIconOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.BENTO_PHOTO && (<BentoPhotoOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.FILL_BLANK && (<FillBlankInput question=\{currentQuestion\} fillBlankInput=\{fillBlankInput\} answerChecked=\{answerChecked\} isCorrect=\{isCorrect\} handleFillBlankChange=\{handleFillBlankChange\} handleFillBlankKeyDown=\{handleFillBlankKeyDown\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.SEQUENCING && (<SequencingOptions question=\{currentQuestion\} sequencingOrder=\{sequencingOrder\} answerChecked=\{answerChecked\} isSequenceCorrect=\{isSequenceCorrect\} handleSequenceClick=\{handleSequenceClick\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.HOTSPOT && (<HotspotOptions question=\{currentQuestion\} selectedHotspot=\{selectedHotspot\} answerChecked=\{answerChecked\} handleHotspotClick=\{handleHotspotClick\} />)\}\
                        \{!Object.values(QUESTION_TYPES).includes(currentQuestion.type) && (<div className="text-red-500">Erro: Tipo de quest\'e3o desconhecido: \{currentQuestion.type\}</div>)\}\
                     </div>\
\
                     \{/* Blurred Background Overlay (Mobile) - Shown when answer is checked */\}\
                     \{ answerChecked && !gameFinished && (\
                         <div className="absolute inset-0 top-0 left-0 right-0 bottom-0 bg-white/30 dark:bg-slate-900/40 backdrop-blur-md z-10 pointer-events-none animate-fade-in"></div>\
                     )\}\
\
                     \{/* Feedback Section (Mobile - Absolute Positioning) - Shown when answer is checked */\}\
                     \{ answerChecked && !gameFinished && (\
                         <div className="absolute top-0 left-0 right-0 p-4 pt-4 z-20 pointer-events-none">\
                             <div className="pointer-events-auto"> \{/* Allow interaction with feedback */\}\
                                 <FeedbackSection\
                                     isCorrect=\{isCorrect\}\
                                     feedbackTitle=\{feedbackTitle\}\
                                     explanation=\{currentQuestion.explanation\}\
                                     questionId=\{currentQuestion.id\}\
                                     onSaveExplanation=\{onSaveExplanation\}\
                                     onLearnMoreClick=\{onLearnMoreClick\}\
                                     onUpgradeClick=\{onUpgradeClick\}\
                                     subscriptionPlan=\{subscriptionPlan\} // Pass user's plan\
                                 />\
                             </div>\
                         </div>\
                     )\}\
                     <div className="h-4"></div> \{/* Bottom margin */\}\
                </div>\
                 \{renderActionButton()\} \{/* Mobile FAB */\}\
            </div>\
\
            \{/* Desktop Layout */\}\
            <div className=\{`hidden md:grid md:grid-cols-[1fr_auto_1fr] md:gap-6 md:items-start`\}>\
                 <div></div> \{/* Left Spacer */\}\
                 \{/* Question Card (Desktop) */\}\
                <div ref=\{questionCardRef\} className=\{`relative overflow-visible w-full max-w-3xl bg-white dark:bg-slate-800 md:shadow-2xl md:rounded-xl flex flex-col transition-all duration-500 ease-in-out $\{isShaking ? 'animate-shake' : ''\}`\} >\
                     \{/* Header */\}\
                     <div className=\{`relative z-10 p-5 text-white bg-gradient-to-r $\{subjectVisual.gradient\} md:rounded-t-xl shadow-md`\}>\
                        <div className="flex justify-between items-center mb-3">\
                            <div className="flex items-center gap-2 text-sm bg-black/20 px-3 py-1 rounded-full backdrop-blur-sm"><subjectVisual.icon className="w-4 h-4 opacity-80" /><span>\{currentQuestion.subject || 'Geral'\}</span></div>\
                            <button onClick=\{onReturnToConfig\} className="p-1.5 rounded-full text-white/70 hover:text-white hover:bg-black/20 transition-colors duration-150 focus:outline-none focus:ring-2 focus:ring-white/50 active:bg-black/30" aria-label="Fechar Quiz" title="Fechar Quiz"><X className="w-5 h-5" /></button>\
                        </div>\
                         <p className="text-lg font-semibold mb-4 min-h-[2.5em]">\
                             \{currentQuestion.question || <span className="text-white/70 italic">Carregando quest\'e3o...</span>\}\
                         </p>\
                         <ProgressBar percentage=\{((currentQuestionIndex + 1) / questionsData.length) * 100\} />\
                     </div>\
                     \{/* Options Area */\}\
                     <div className="p-6 flex-grow min-h-[200px]">\
                        \{currentQuestion.type === QUESTION_TYPES.MULTIPLE_CHOICE && (<MultipleChoiceOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.BENTO_ICON && (<BentoIconOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.BENTO_PHOTO && (<BentoPhotoOptions question=\{currentQuestion\} selectedAnswer=\{selectedAnswer\} answerChecked=\{answerChecked\} selectAnswer=\{handleSelectAnswer\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.FILL_BLANK && (<FillBlankInput question=\{currentQuestion\} fillBlankInput=\{fillBlankInput\} answerChecked=\{answerChecked\} isCorrect=\{isCorrect\} handleFillBlankChange=\{handleFillBlankChange\} handleFillBlankKeyDown=\{handleFillBlankKeyDown\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.SEQUENCING && (<SequencingOptions question=\{currentQuestion\} sequencingOrder=\{sequencingOrder\} answerChecked=\{answerChecked\} isSequenceCorrect=\{isSequenceCorrect\} handleSequenceClick=\{handleSequenceClick\} />)\}\
                        \{currentQuestion.type === QUESTION_TYPES.HOTSPOT && (<HotspotOptions question=\{currentQuestion\} selectedHotspot=\{selectedHotspot\} answerChecked=\{answerChecked\} handleHotspotClick=\{handleHotspotClick\} />)\}\
                         \{!Object.values(QUESTION_TYPES).includes(currentQuestion.type) && (<div className="text-red-500">Erro: Tipo de quest\'e3o desconhecido: \{currentQuestion.type\}</div>)\}\
                     </div>\
                     <div className="h-20"></div> \{/* Placeholder for bottom margin & FAB */\}\
                     \{renderActionButton()\} \{/* Desktop FAB integrated */\}\
                </div>\
                 \{/* Feedback Section Container (Desktop) */\}\
                 <div ref=\{desktopFeedbackContainerRef\} className="flex flex-col gap-4 items-start w-full pt-0">\
                     \{/* Feedback shown only when answer is checked */\}\
                     \{ answerChecked && !gameFinished && (\
                         <FeedbackSection\
                             isCorrect=\{isCorrect\}\
                             feedbackTitle=\{feedbackTitle\}\
                             explanation=\{currentQuestion.explanation\}\
                             questionId=\{currentQuestion.id\}\
                             onSaveExplanation=\{onSaveExplanation\}\
                             onLearnMoreClick=\{onLearnMoreClick\}\
                             onUpgradeClick=\{onUpgradeClick\}\
                             subscriptionPlan=\{subscriptionPlan\} // Pass user's plan\
                             className="md:max-w-2xl"\
                         />\
                     )\}\
                 </div>\
            </div>\
        </div>\
    );\
\}));\
QuizGame.displayName = 'QuizGame';\
\
\
// --- Configuration Screen ---\
const QuizConfigScreen = memo((\{ allSubjects, selectedSubjects, numQuestions, onNumQuestionsChange, onToggleSubject, onSelectAll, onStartQuiz, onGenerateAIRandomQuiz, isStarting \}) => \{ const isAllSelected = selectedSubjects.length === 0; const QuestionSlider = () => \{ const currentIndex = useMemo(() => NUM_QUESTIONS_OPTIONS.indexOf(numQuestions) === -1 ? 0 : NUM_QUESTIONS_OPTIONS.indexOf(numQuestions), [numQuestions]); const handleSliderChange = useCallback((event) => onNumQuestionsChange(NUM_QUESTIONS_OPTIONS[parseInt(event.target.value, 10)]), [onNumQuestionsChange]); const thumbColor = useMemo(() => \{ const shades = ['#c084fc', '#a855f7', '#9333ea', '#7e22ce', '#6b21a8']; return shades[Math.min(currentIndex, shades.length - 1)] || shades[0]; \}, [currentIndex]); return ( <div className="relative pt-1"><input type="range" min="0" max=\{NUM_QUESTIONS_OPTIONS.length - 1\} value=\{currentIndex\} onChange=\{handleSliderChange\} className="w-full h-2 bg-gradient-to-r from-purple-200 to-violet-300 dark:from-purple-800 dark:to-violet-900 rounded-lg appearance-none cursor-pointer accent-purple-600 dark:accent-purple-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 dark:focus:ring-offset-slate-800" style=\{\{ '--thumb-color': thumbColor \}\} id="num-questions-slider" aria-label=\{`N\'famero de quest\'f5es: $\{numQuestions\}`\} /><div className="flex justify-between text-xs text-slate-500 dark:text-slate-400 mt-1.5 px-1">\{NUM_QUESTIONS_OPTIONS.map((num, index) => (<button key=\{num\} onClick=\{() => onNumQuestionsChange(num)\} className=\{`cursor-pointer px-1 rounded $\{index === currentIndex ? 'font-bold text-purple-700 dark:text-purple-300' : 'hover:text-purple-600 dark:hover:text-purple-400'\}`\} aria-pressed=\{index === currentIndex\}>\{num\}</button>))\}</div></div> ); \}; return ( <div className="w-full md:max-w-2xl bg-white dark:bg-slate-800 md:shadow-2xl md:rounded-xl flex flex-col overflow-hidden animate-fade-in"><div className="bg-gradient-to-r from-purple-600 to-violet-700 text-white p-6 text-left md:rounded-t-xl shadow-md"><h2 className="text-2xl md:text-3xl font-bold">Configurar Quiz</h2><p className="text-purple-100 text-sm mt-1">Escolha as mat\'e9rias e o n\'famero de quest\'f5es.</p></div><div className="p-6 md:p-8 flex-grow overflow-y-auto flex flex-col"><div className="mb-8"><label className="block text-lg font-semibold text-slate-800 dark:text-slate-100 mb-3">Mat\'e9rias:</label><div className="flex flex-wrap gap-2 justify-start"><button onClick=\{onSelectAll\} aria-pressed=\{isAllSelected\} className=\{`px-4 py-1.5 rounded-full text-sm font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 dark:focus:ring-offset-slate-800 active:scale-95 $\{isAllSelected ? 'bg-purple-600 text-white shadow-md hover:bg-purple-700' : 'bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600 border border-slate-200 dark:border-slate-600'\}`\}>Todas</button>\{allSubjects.map(subject => \{ const visual = SUBJECT_VISUALS[subject] || SUBJECT_VISUALS.Default; const isSelected = !isAllSelected && selectedSubjects.includes(subject); return (<button key=\{subject\} onClick=\{() => onToggleSubject(subject)\} aria-pressed=\{isSelected\} className=\{`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-medium transition-all duration-200 border-2 focus:outline-none focus:ring-2 focus:ring-offset-1 dark:focus:ring-offset-slate-800 active:scale-95 $\{isSelected ? `$\{visual.bg.replace('bg-', 'border-')\} $\{visual.color\} $\{visual.bg.replace('100', '200/80')\} dark:$\{visual.bg.replace('bg-', 'bg-').replace('100','900/30')\} shadow-md` : `border-slate-300 dark:border-slate-600 text-slate-600 dark:text-slate-300 hover:border-slate-400 dark:hover:border-slate-500 hover:bg-slate-50 dark:hover:bg-slate-700`\}`\} style=\{isSelected ? \{ '--tw-ring-color': visual.ring.replace('ring-', '#') \} : \{\}\}><visual.icon className=\{`w-4 h-4 $\{isSelected ? '' : 'opacity-70'\}`\} />\{subject\}</button>); \})\}</div></div><div className="mb-8"><label htmlFor="num-questions-slider" className="block text-lg font-semibold text-slate-800 dark:text-slate-100 mb-3">N\'famero de Quest\'f5es: <span className="text-purple-700 dark:text-purple-300 font-bold">\{numQuestions\}</span></label><QuestionSlider /></div><div className="flex flex-col sm:flex-row gap-3 mt-auto pt-6 border-t border-slate-200 dark:border-slate-700"><button onClick=\{onStartQuiz\} disabled=\{isStarting || (!isAllSelected && selectedSubjects.length === 0)\} className=\{`flex-1 px-6 py-3 rounded-lg text-white font-semibold transition-all duration-200 ease-in-out flex items-center justify-center gap-2 shadow-md active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed $\{isStarting || (!isAllSelected && selectedSubjects.length === 0) ? 'bg-slate-400 dark:bg-slate-600' : 'bg-purple-600 hover:bg-purple-700 transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 dark:focus:ring-offset-slate-800'\}`\} title=\{(!isAllSelected && selectedSubjects.length === 0) ? "Selecione pelo menos uma mat\'e9ria" : "Iniciar Quiz"\}>\{isStarting ? <Loader2 className="animate-spin w-5 h-5" /> : <ArrowRight className="w-5 h-5" />\} \{isStarting ? 'Iniciando...' : 'Iniciar Quiz'\}</button><button onClick=\{onGenerateAIRandomQuiz\} disabled=\{isStarting\} className=\{`px-4 py-3 rounded-lg font-semibold transition-all duration-200 ease-in-out flex items-center justify-center gap-2 border-2 shadow-sm active:scale-95 disabled:opacity-60 disabled:cursor-not-allowed $\{isStarting ? 'border-slate-300 dark:border-slate-600 text-slate-400 dark:text-slate-500' : 'border-purple-500 text-purple-600 dark:border-purple-400 dark:text-purple-400 hover:bg-purple-50 dark:hover:bg-purple-900/30 transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-1 dark:focus:ring-offset-slate-800'\}`\} title="Gera um quiz r\'e1pido com 2 mat\'e9rias aleat\'f3rias e n\'famero de quest\'f5es variado (10, 20 ou 40)." aria-label="Gerar Quiz R\'e1pido Aleat\'f3rio">\{isStarting ? <Loader2 className="animate-spin w-5 h-5" /> : <Zap className="w-5 h-5" />\} <span className="hidden sm:inline">Quiz R\'e1pido</span></button></div></div></div> ); \});\
QuizConfigScreen.displayName = 'QuizConfigScreen';\
\
// --- Placeholder Views ---\
const ViewPlaceholder = (\{ title, icon: Icon, gradient = 'from-purple-500 to-violet-600', children \}) => (\
    <div className="w-full md:max-w-2xl bg-white dark:bg-slate-800 md:shadow-xl md:rounded-xl flex flex-col overflow-hidden animate-fade-in">\
        <div className=\{`bg-gradient-to-r $\{gradient\} text-white p-6 text-center md:rounded-t-xl shadow-md`\}>\
            <h2 className="text-2xl md:text-3xl font-bold">\{title\}</h2>\
        </div>\
        <div className="p-8 text-center flex-grow flex flex-col items-center justify-center">\
            \{Icon && <Icon className="w-16 h-16 mx-auto text-slate-400 dark:text-slate-500 mb-4" />\}\
            <div className="text-slate-600 dark:text-slate-300">\{children || <p>Conte\'fado em breve...</p>\}</div>\
        </div>\
    </div>\
);\
const InicioView = () => (<ViewPlaceholder title="In\'edcio" icon=\{Home\} gradient="from-purple-500 to-violet-600"><p>Bem-vindo ao Simu! Navegue pelas se\'e7\'f5es usando a barra de navega\'e7\'e3o.</p></ViewPlaceholder>);\
const SimuladorView = () => (<ViewPlaceholder title="Simulador de Exame" icon=\{GraduationCap\} gradient="from-blue-500 to-cyan-600"><p>Prepare-se para seus exames com simula\'e7\'f5es realistas. Funcionalidade em desenvolvimento.</p></ViewPlaceholder>);\
const LearnMoreView = () => (<ViewPlaceholder title="Saiba Mais" icon=\{Info\} gradient="from-teal-500 to-cyan-600"><p>P\'e1gina de informa\'e7\'f5es adicionais sobre o assunto da quest\'e3o. Conte\'fado a ser implementado.</p></ViewPlaceholder>);\
const UpgradeView = () => (<ViewPlaceholder title="Fazer Upgrade" icon=\{Sparkles\} gradient="from-yellow-500 to-orange-600"><p>P\'e1gina para o usu\'e1rio fazer upgrade do plano. Conte\'fado a ser implementado.</p></ViewPlaceholder>);\
\
\
// --- Profile Screen Components ---\
const ProfileSection = memo((\{ children, className = "", ...props \}) => (<div className=\{`bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200/80 dark:border-slate-700/80 overflow-hidden $\{className\}`\} \{...props\}>\{children\}</div>)); ProfileSection.displayName = 'ProfileSection';\
const ProfileRow = memo((\{ icon: Icon, label, children, onClick, showChevron = false, iconColor = 'text-purple-600 dark:text-purple-400' \}) => \{ const content = (<><div className="flex items-center gap-3 flex-1 min-w-0">\{Icon && <Icon className=\{`w-5 h-5 $\{iconColor\} flex-shrink-0`\} />\}<span className="text-sm font-medium text-slate-700 dark:text-slate-200 truncate">\{label\}</span></div><div className="text-sm text-slate-500 dark:text-slate-400 text-right flex-shrink-0 ml-2">\{children\}</div>\{showChevron && <ChevronRight className="w-4 h-4 text-slate-400 dark:text-slate-500 ml-2 flex-shrink-0" />\}</>); if (onClick) \{ return (<button onClick=\{onClick\} className="flex items-center justify-between w-full px-4 py-3.5 hover:bg-slate-50 dark:hover:bg-slate-700/50 transition-colors duration-150 focus:outline-none focus:bg-slate-100 dark:focus:bg-slate-700">\{content\}</button>); \} return (<div className="flex items-center justify-between px-4 py-3.5">\{content\}</div>); \}); ProfileRow.displayName = 'ProfileRow';\
const PillSelector = memo((\{ options, selectedValue, onChange \}) => (<div className="flex items-center space-x-1 bg-slate-100 dark:bg-slate-700 p-1 rounded-lg">\{options.map(option => \{ const isSelected = selectedValue === option.value; return (<button key=\{option.value\} onClick=\{() => onChange(option.value)\} className=\{`flex-1 px-2 py-1 rounded-md text-xs font-semibold transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-1 dark:focus:ring-offset-slate-700 $\{ isSelected ? 'bg-white dark:bg-slate-800 text-purple-700 dark:text-purple-300 shadow' : 'text-slate-600 dark:text-slate-300 hover:bg-white/50 dark:hover:bg-slate-600/50'\}`\} aria-pressed=\{isSelected\}>\{option.label\}</button>); \})\}</div>)); PillSelector.displayName = 'PillSelector';\
const ToggleSwitch = memo((\{ enabled, onChange \}) => (<button type="button" onClick=\{() => onChange(!enabled)\} className=\{`$\{ enabled ? 'bg-purple-600' : 'bg-slate-300 dark:bg-slate-600'\} relative inline-flex h-5 w-9 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 dark:focus:ring-offset-slate-800`\} role="switch" aria-checked=\{enabled\}><span aria-hidden="true" className=\{`$\{ enabled ? 'translate-x-4' : 'translate-x-0'\} pointer-events-none inline-block h-4 w-4 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out`\}/></button>)); ToggleSwitch.displayName = 'ToggleSwitch';\
\
// --- Profile View Screen ---\
const PerfilView = memo((\{\
    currentUser, // Changed from userData to currentUser\
    navigateToView,\
    onUpdateUser, // Still needed for editing profile\
    theme,\
    onThemeChange,\
    savedExplanationsCount,\
    onLogout // Added logout handler\
\}) => \{\
    const [soundEnabled, setSoundEnabled] = useState(() => \{\
        const stored = localStorage.getItem('soundEnabled');\
        return stored ? JSON.parse(stored) : true;\
    \});\
\
    const handleSoundToggle = useCallback((enabled) => \{\
        setSoundEnabled(enabled);\
        localStorage.setItem('soundEnabled', JSON.stringify(enabled));\
        console.log("Sound enabled:", enabled);\
    \}, []);\
\
    const handleEditProfileClick = useCallback(() => navigateToView(VIEW_EDIT_PROFILE), [navigateToView]);\
    const handleRenewClick = useCallback(() => alert("Funcionalidade de renova\'e7\'e3o ainda n\'e3o implementada."), []);\
    const handleSavedExplanationsClick = useCallback(() => navigateToView(VIEW_SAVED_EXPLANATIONS), [navigateToView]);\
\
    // Use currentUser for profile data\
    const userData = currentUser; // Alias for clarity if needed, or use currentUser directly\
\
    // Subscription styles\
    const subStyles = useMemo(() => (\{ [SUBSCRIPTION_PLANS.BASIC]: \{ bg: 'bg-gradient-to-r from-sky-100 to-blue-100 dark:from-sky-900/50 dark:to-blue-900/50', text: 'text-blue-800 dark:text-blue-300', iconBg: 'bg-blue-100 dark:bg-blue-900', button: 'bg-purple-500 hover:bg-purple-600 focus:ring-purple-300 dark:focus:ring-purple-500' \}, [SUBSCRIPTION_PLANS.PRO]: \{ bg: 'bg-gradient-to-r from-purple-100 to-indigo-100 dark:from-purple-900/50 dark:to-indigo-900/50', text: 'text-indigo-800 dark:text-indigo-300', iconBg: 'bg-indigo-100 dark:bg-indigo-900', button: 'bg-purple-500 hover:bg-purple-600 focus:ring-purple-300 dark:focus:ring-purple-500' \}, [SUBSCRIPTION_PLANS.ULTRA]: \{ bg: 'bg-gradient-to-r from-fuchsia-200 to-pink-200 dark:from-fuchsia-900/50 dark:to-pink-900/50', text: 'text-pink-800 dark:text-pink-300', iconBg: 'bg-pink-100 dark:bg-pink-900', button: 'bg-purple-500 hover:bg-purple-600 focus:ring-purple-300 dark:focus:ring-purple-500' \}, Default: \{ bg: 'bg-slate-100 dark:bg-slate-700', text: 'text-slate-800 dark:text-slate-200', iconBg: 'bg-slate-100 dark:bg-slate-600', button: 'bg-purple-500 hover:bg-purple-600 focus:ring-purple-300 dark:focus:ring-purple-500' \} \}), []);\
    const currentSubStyle = useMemo(() => subStyles[userData?.subscription] || subStyles.Default, [userData?.subscription, subStyles]);\
    const isExpiringSoon = userData?.expirationDays !== null && userData?.expirationDays <= 7;\
    const expirationText = userData?.expirationDays !== null ? `Expira em $\{userData.expirationDays\} dia$\{userData.expirationDays !== 1 ? 's' : ''\}` : 'N/A';\
\
    // Handle case where currentUser might be null briefly during logout transition\
    if (!userData) \{\
        return (\
            <div className="flex justify-center items-center h-64 w-full">\
                <Loader2 className="w-12 h-12 animate-spin text-purple-500" />\
            </div>\
        );\
    \}\
\
    return (\
        <div className="w-full md:max-w-2xl bg-slate-50 dark:bg-slate-900 md:shadow-xl md:rounded-xl flex flex-col overflow-hidden animate-fade-in">\
            <div className="bg-gradient-to-r from-purple-600 to-violet-700 text-white p-5 text-center md:rounded-t-xl shadow-md">\
                <h2 className="text-xl md:text-2xl font-bold">Meu Perfil</h2>\
            </div>\
            <div className="flex-grow overflow-y-auto p-4 md:p-6 space-y-4 max-h-[calc(100vh-150px)] md:max-h-none">\
                \{/* User Info Section */\}\
                <ProfileSection className="p-4 relative">\
                    <button onClick=\{handleEditProfileClick\} className="absolute top-3 right-3 p-1.5 text-slate-400 hover:text-purple-600 dark:hover:text-purple-400 hover:bg-purple-50 dark:hover:bg-purple-900/50 rounded-full transition-colors duration-150 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-1 dark:focus:ring-offset-slate-800" aria-label="Editar Perfil" title="Editar Perfil">\
                        <Edit className="w-4 h-4" />\
                    </button>\
                    <div className="flex items-center space-x-4">\
                        <div className="flex-shrink-0 w-16 h-16 rounded-full border-2 border-slate-200 dark:border-slate-700 overflow-hidden">\
                            \{userData.avatarUrl ? (<img src=\{userData.avatarUrl\} alt="Avatar" className="w-full h-full object-cover" onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(64, 64, userData.name?.[0] || '?') \}\} />) : (<UserCircle className="w-full h-full text-slate-300 dark:text-slate-600" />)\}\
                        </div>\
                        <div className="flex-1 min-w-0">\
                            <h3 className="text-lg font-semibold text-slate-800 dark:text-slate-100 truncate">\{userData.name || 'Nome n\'e3o definido'\}</h3>\
                            <p className="text-sm text-slate-500 dark:text-slate-400 truncate">@\{userData.nickname || 'nickname'\}</p>\
                            <div className="flex items-center gap-1 mt-1 text-sm text-yellow-600 dark:text-yellow-400">\
                                <Star className="w-4 h-4 fill-current flex-shrink-0" />\
                                <span>\{userData.score?.toLocaleString() || 0\} Pontos</span>\
                            </div>\
                        </div>\
                    </div>\
                </ProfileSection>\
\
                \{/* General Settings Section */\}\
                <ProfileSection>\
                    <ProfileRow icon=\{Laptop2\} label="Tema" iconColor="text-sky-600 dark:text-sky-400">\
                        <PillSelector options=\{[\{ label: 'Claro', value: 'light' \}, \{ label: 'Escuro', value: 'dark' \}, \{ label: 'Sistema', value: 'system' \}]\} selectedValue=\{theme\} onChange=\{onThemeChange\} />\
                    </ProfileRow>\
                    <ProfileRow icon=\{Volume2\} label="Sons da Interface" iconColor="text-emerald-600 dark:text-emerald-400">\
                        <ToggleSwitch enabled=\{soundEnabled\} onChange=\{handleSoundToggle\} />\
                    </ProfileRow>\
                </ProfileSection>\
\
                \{/* Subscription Section */\}\
                <div className=\{`rounded-xl shadow-sm border border-transparent dark:border-slate-700/50 overflow-hidden $\{currentSubStyle.bg\}`\}>\
                    <ProfileRow icon=\{Gem\} label="Assinatura" iconColor=\{currentSubStyle.text.replace('text-', 'text-')\}>\
                        <span className=\{`font-semibold $\{currentSubStyle.text\}`\}>\{userData.subscription || 'Nenhuma'\}</span>\
                    </ProfileRow>\
                    <ProfileRow icon=\{CalendarClock\} label="Validade" iconColor="text-slate-500 dark:text-slate-400">\
                        <span className=\{isExpiringSoon ? 'text-orange-600 dark:text-orange-400 font-medium' : ''\}>\{expirationText\}</span>\
                    </ProfileRow>\
                    \{(isExpiringSoon || userData.subscription) && (\
                        <div className=\{`px-4 pb-3 pt-2 $\{isExpiringSoon ? 'border-t border-white/30 dark:border-black/20' : ''\}`\}>\
                            \{isExpiringSoon && (\
                                <div className="flex items-center justify-center gap-1.5 text-xs text-orange-700 dark:text-orange-300 bg-orange-100 dark:bg-orange-900/50 px-2 py-1 rounded-full mb-2">\
                                    <AlertTriangle className="w-3 h-3" />\
                                    <span>Sua assinatura est\'e1 expirando!</span>\
                                </div>\
                            )\}\
                            <button onClick=\{handleRenewClick\} className=\{`w-full px-4 py-1.5 rounded-lg text-white text-sm font-semibold transition-colors duration-200 shadow-sm active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-slate-900 $\{currentSubStyle.button\}`\}>\
                                \{isExpiringSoon ? 'Renove Agora' : 'Gerenciar Assinatura'\}\
                            </button>\
                        </div>\
                    )\}\
                </div>\
\
                \{/* Other Links Section */\}\
                <ProfileSection>\
                    <ProfileRow icon=\{Bookmark\} label="Explica\'e7\'f5es Salvas" onClick=\{handleSavedExplanationsClick\} showChevron iconColor="text-teal-600 dark:text-teal-400">\
                         <span className="text-xs bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-300 font-semibold px-2 py-0.5 rounded-full">\{savedExplanationsCount\}</span>\
                    </ProfileRow>\
                    <ProfileRow icon=\{Trophy\} label="Minhas Conquistas" onClick=\{() => alert('Navegar para Conquistas')\} showChevron iconColor="text-amber-600 dark:text-amber-400" />\
                    <ProfileRow icon=\{Settings\} label="Configura\'e7\'f5es Avan\'e7adas" onClick=\{() => alert('Navegar para Configura\'e7\'f5es Avan\'e7adas')\} showChevron iconColor="text-slate-500 dark:text-slate-400" />\
                    <ProfileRow icon=\{HelpCircle\} label="Ajuda & Suporte" onClick=\{() => alert('Navegar para Ajuda')\} showChevron iconColor="text-blue-600 dark:text-blue-400" />\
                </ProfileSection>\
\
                \{/* Logout Button */\}\
                <div className="mt-4">\
                    <button\
                        onClick=\{onLogout\}\
                        className="w-full flex items-center justify-center gap-2 px-4 py-2.5 rounded-lg text-sm font-medium text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-900/30 hover:bg-red-100 dark:hover:bg-red-900/50 border border-red-200 dark:border-red-700/50 shadow-sm hover:shadow-md transition-all duration-150 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 dark:focus:ring-offset-slate-900 active:scale-[0.98]"\
                    >\
                        <LogOut className="w-4 h-4" />\
                        Sair (Logout)\
                    </button>\
                </div>\
            </div>\
        </div>\
    );\
\});\
PerfilView.displayName = 'PerfilView';\
\
\
// --- Edit Profile View Screen ---\
const EditProfileView = memo((\{ currentUser, navigateToView, onUpdateUser \}) => \{\
    // Initialize state from currentUser\
    const [name, setName] = useState(currentUser?.name || '');\
    const [nickname, setNickname] = useState(currentUser?.nickname || '');\
    const [avatarPreview, setAvatarPreview] = useState(currentUser?.avatarUrl);\
    const [avatarFile, setAvatarFile] = useState(null);\
    const [isSaving, setIsSaving] = useState(false);\
    const fileInputRef = useRef(null);\
\
    // Update local state if currentUser changes externally (e.g., after login/logout)\
    useEffect(() => \{\
        if (currentUser) \{\
            setName(currentUser.name || '');\
            setNickname(currentUser.nickname || '');\
            setAvatarPreview(currentUser.avatarUrl);\
        \} else \{\
            // Handle case where user logs out while editing? Reset or navigate away.\
             navigateToView(VIEW_LOGIN); // Navigate to login if user data disappears\
        \}\
    \}, [currentUser, navigateToView]);\
\
\
    const handleSave = useCallback(async () => \{\
        if (!name.trim() || !nickname.trim()) \{\
            alert("Nome e Nickname n\'e3o podem estar vazios.");\
            return;\
        \}\
        if (!currentUser) \{\
             alert("Erro: Usu\'e1rio n\'e3o est\'e1 logado.");\
             return;\
        \}\
        setIsSaving(true);\
        console.log("Saving profile:", \{ name, nickname, avatarFile: avatarFile?.name \});\
        // Simulate API call\
        await new Promise(resolve => setTimeout(resolve, 700));\
        // Create updated user data object\
        const updatedUserData = \{\
            ...currentUser,\
            name: name.trim(),\
            nickname: nickname.trim(),\
            // Keep existing avatar if no new file, otherwise use the preview (which comes from the new file)\
            avatarUrl: avatarFile ? avatarPreview : currentUser.avatarUrl\
        \};\
        onUpdateUser(updatedUserData); // Pass the complete updated user object back\
        setIsSaving(false);\
        navigateToView(VIEW_PERFIL);\
    \}, [name, nickname, avatarPreview, avatarFile, currentUser, onUpdateUser, navigateToView]);\
\
    const handleCancel = useCallback(() => \{\
        if (!isSaving) navigateToView(VIEW_PERFIL);\
    \}, [isSaving, navigateToView]);\
\
    const handlePhotoClick = useCallback(() => fileInputRef.current?.click(), []);\
\
    const handleFileChange = useCallback((event) => \{\
        const file = event.target.files?.[0];\
        if (file) \{\
            if (!file.type.startsWith('image/')) \{\
                alert("Por favor, selecione um arquivo de imagem v\'e1lido (JPG, PNG, GIF, etc.).");\
                return;\
            \}\
            if (file.size > 5 * 1024 * 1024) \{ // 5MB limit\
                alert("O arquivo de imagem \'e9 muito grande (m\'e1ximo 5MB).");\
                return;\
            \}\
            setAvatarFile(file); // Store the file object\
            // Generate a preview URL\
            const reader = new FileReader();\
            reader.onloadend = () => setAvatarPreview(reader.result); // Set preview state\
            reader.readAsDataURL(file);\
            console.log("Selected file:", file.name, file.size);\
        \}\
    \}, []);\
\
    const handleRemovePhoto = useCallback(() => \{\
        setAvatarPreview(null); // Clear preview\
        setAvatarFile(null); // Clear stored file\
        if (fileInputRef.current) fileInputRef.current.value = ""; // Reset file input\
    \}, []);\
\
    // Handle case where currentUser might be null briefly during transitions\
    if (!currentUser) \{\
        return (\
            <div className="flex justify-center items-center h-64 w-full">\
                <Loader2 className="w-12 h-12 animate-spin text-purple-500" />\
            </div>\
        );\
    \}\
\
    return (\
        <div className="w-full md:max-w-2xl bg-white dark:bg-slate-800 md:shadow-xl md:rounded-xl flex flex-col overflow-hidden animate-fade-in">\
            \{/* Header */\}\
            <div className="flex items-center justify-between p-4 border-b border-slate-200 dark:border-slate-700 sticky top-0 bg-white dark:bg-slate-800 z-10">\
                <button onClick=\{handleCancel\} disabled=\{isSaving\} className="text-sm text-purple-600 dark:text-purple-400 hover:text-purple-800 dark:hover:text-purple-300 transition-colors px-2 py-1 rounded-md hover:bg-purple-50 dark:hover:bg-purple-900/50 disabled:opacity-50">Cancelar</button>\
                <h2 className="text-lg font-semibold text-slate-800 dark:text-slate-100">Editar Perfil</h2>\
                <button onClick=\{handleSave\} disabled=\{isSaving || !name.trim() || !nickname.trim()\} className="text-sm font-semibold text-purple-600 dark:text-purple-400 hover:text-purple-800 dark:hover:text-purple-300 transition-colors px-3 py-1 rounded-md hover:bg-purple-50 dark:hover:bg-purple-900/50 disabled:opacity-50 flex items-center gap-1">\
                    \{isSaving ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check className="w-4 h-4" />\}\
                    \{isSaving ? 'Salvando' : 'Salvar'\}\
                </button>\
            </div>\
            \{/* Form Content */\}\
            <div className="flex-grow overflow-y-auto p-4 md:p-6 space-y-6 max-h-[calc(100vh-150px)] md:max-h-none">\
                \{/* Avatar Section */\}\
                <div className="flex flex-col items-center space-y-3">\
                    <div className="relative w-24 h-24">\
                        <div className="w-full h-full rounded-full border-2 border-slate-200 dark:border-slate-600 overflow-hidden bg-slate-100 dark:bg-slate-700 flex items-center justify-center">\
                            \{avatarPreview ? (\
                                <img src=\{avatarPreview\} alt="Avatar Preview" className="w-full h-full object-cover" onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(96, 96, name?.[0] || '?') \}\} />\
                            ) : (\
                                <UserCircle className="w-16 h-16 text-slate-400 dark:text-slate-500" />\
                            )\}\
                        </div>\
                        <input type="file" ref=\{fileInputRef\} onChange=\{handleFileChange\} accept="image/*" className="hidden" />\
                        <button onClick=\{handlePhotoClick\} className="absolute -bottom-1 -right-1 p-1.5 bg-purple-600 text-white rounded-full shadow-md hover:bg-purple-700 transition-colors focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 dark:focus:ring-offset-slate-800" aria-label="Alterar foto" title="Alterar foto" disabled=\{isSaving\}>\
                            <Camera className="w-3.5 h-3.5" />\
                        </button>\
                        \{(avatarPreview || avatarFile) && (\
                            <button onClick=\{handleRemovePhoto\} className="absolute -top-1 -right-1 p-1 bg-red-500 text-white rounded-full shadow-md hover:bg-red-600 transition-colors focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-1 dark:focus:ring-offset-slate-800" aria-label="Remover foto" title="Remover foto" disabled=\{isSaving\}>\
                                <Trash2 className="w-3 h-3" />\
                            </button>\
                        )\}\
                    </div>\
                    <button onClick=\{handlePhotoClick\} disabled=\{isSaving\} className="text-sm text-purple-600 dark:text-purple-400 hover:text-purple-800 dark:hover:text-purple-300 font-medium transition-colors focus:outline-none focus:ring-1 focus:ring-purple-500 rounded px-2 py-0.5 disabled:opacity-50">Alterar Foto</button>\
                </div>\
                \{/* Input Fields */\}\
                <div className="space-y-4">\
                    <div>\
                        <label htmlFor="edit-name" className="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Nome</label>\
                        <input type="text" id="edit-name" value=\{name\} onChange=\{(e) => setName(e.target.value)\} placeholder="Seu nome completo" disabled=\{isSaving\} maxLength=\{50\} className="w-full px-3 py-2 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-purple-500 dark:focus:ring-purple-400 focus:border-purple-500 dark:focus:border-purple-400 text-sm shadow-sm transition-colors disabled:opacity-70" />\
                    </div>\
                    <div>\
                        <label htmlFor="edit-nickname" className="block text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">Nickname</label>\
                        <div className="relative">\
                            <span className="absolute inset-y-0 left-0 pl-3 flex items-center text-sm text-slate-400 dark:text-slate-500">@</span>\
                            <input type="text" id="edit-nickname" value=\{nickname\} onChange=\{(e) => setNickname(e.target.value.replace(/[^a-zA-Z0-9_]/g, ''))\} placeholder="Seu nome de usu\'e1rio" disabled=\{isSaving\} maxLength=\{30\} className="w-full pl-7 pr-3 py-2 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-purple-500 dark:focus:ring-purple-400 focus:border-purple-500 dark:focus:border-purple-400 text-sm shadow-sm transition-colors disabled:opacity-70" />\
                        </div>\
                        <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">Apenas letras, n\'fameros e underscore (_).</p>\
                    </div>\
                </div>\
            </div>\
        </div>\
    );\
\});\
EditProfileView.displayName = 'EditProfileView';\
\
// --- Saved Explanations View Screen ---\
const SavedExplanationsView = memo((\{\
    savedExplanations,\
    allQuestions,\
    navigateToView,\
    onRemoveExplanation\
\}) => \{\
    const handleGoBack = useCallback(() => navigateToView(VIEW_PERFIL), [navigateToView]);\
\
    const getQuestionById = useCallback((id) => \{\
        return allQuestions.find(q => q.id === id);\
    \}, [allQuestions]);\
\
    return (\
        <div className="w-full md:max-w-2xl bg-white dark:bg-slate-800 md:shadow-xl md:rounded-xl flex flex-col overflow-hidden animate-fade-in">\
            \{/* Header with Back Button */\}\
            <div className="flex items-center p-4 border-b border-slate-200 dark:border-slate-700 sticky top-0 bg-white dark:bg-slate-800 z-10">\
                <button\
                    onClick=\{handleGoBack\}\
                    className="p-1.5 rounded-full text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-1 dark:focus:ring-offset-slate-800"\
                    aria-label="Voltar para o Perfil"\
                >\
                    <ArrowLeft className="w-5 h-5" />\
                </button>\
                <h2 className="text-lg font-semibold text-slate-800 dark:text-slate-100 text-center flex-grow mr-8">\
                    Explica\'e7\'f5es Salvas\
                </h2>\
            </div>\
\
            \{/* Content Area */\}\
            <div className="flex-grow overflow-y-auto p-4 md:p-6 space-y-4 max-h-[calc(100vh-150px)] md:max-h-none">\
                \{savedExplanations.length === 0 ? (\
                    <div className="text-center py-16">\
                        <Inbox className="w-16 h-16 mx-auto text-slate-400 dark:text-slate-500 mb-4" />\
                        <p className="text-slate-500 dark:text-slate-400">Nenhuma explica\'e7\'e3o salva ainda.</p>\
                        <p className="text-sm text-slate-400 dark:text-slate-500 mt-1">Voc\'ea pode salvar explica\'e7\'f5es durante os quizzes!</p>\
                    </div>\
                ) : (\
                    <ul className="space-y-4">\
                        \{savedExplanations.map(savedItem => \{\
                            const question = getQuestionById(savedItem.questionId);\
                            const visual = question ? (SUBJECT_VISUALS[question.subject] || SUBJECT_VISUALS.Default) : SUBJECT_VISUALS.Default;\
                            return (\
                                <li key=\{savedItem.questionId\} className=\{`bg-slate-50 dark:bg-slate-800/50 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden transition-shadow hover:shadow-md`\}>\
                                    <div className=\{`px-4 py-3 border-l-4 $\{visual.color.replace('text-', 'border-')\}`\}>\
                                        \{question && (\
                                            <p className="text-xs font-medium text-slate-500 dark:text-slate-400 mb-1.5 flex items-center gap-1.5">\
                                                <visual.icon className=\{`w-3.5 h-3.5 $\{visual.color\}`\} />\
                                                \{question.subject || 'Geral'\} - Quest\'e3o ID: \{question.id\}\
                                            </p>\
                                        )\}\
                                        \{question && (\
                                            <p className="text-sm font-semibold text-slate-700 dark:text-slate-200 mb-2">\
                                                \{question.question\}\
                                            </p>\
                                        )\}\
                                        <p className="text-sm text-slate-600 dark:text-slate-300 mb-3">\
                                            <span className="font-semibold text-purple-700 dark:text-purple-400">Explica\'e7\'e3o Salva:</span> \{savedItem.explanation\}\
                                        </p>\
                                        <div className="text-right">\
                                            <button\
                                                onClick=\{() => onRemoveExplanation(savedItem.questionId)\}\
                                                className="p-1.5 text-red-500 hover:text-red-700 dark:hover:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/30 rounded-full transition-colors duration-150 focus:outline-none focus:ring-1 focus:ring-red-500"\
                                                aria-label="Remover explica\'e7\'e3o salva"\
                                                title="Remover"\
                                            >\
                                                <Trash2 className="w-4 h-4" />\
                                            </button>\
                                        </div>\
                                    </div>\
                                </li>\
                            );\
                        \})\}\
                    </ul>\
                )\}\
            </div>\
        </div>\
    );\
\});\
SavedExplanationsView.displayName = 'SavedExplanationsView';\
\
// --- NEW: Login View Screen ---\
const LoginView = memo((\{ onLogin \}) => \{\
    const handleLoginClick = (permissionLevel) => \{\
        console.log(`Attempting login with permission: $\{permissionLevel\}`);\
        onLogin(permissionLevel);\
    \};\
\
    const planDetails = \{\
        [SUBSCRIPTION_PLANS.BASIC]: \{ icon: ShieldAlert, color: 'text-blue-600 dark:text-blue-400', button: 'border-blue-500 hover:bg-blue-50 dark:hover:bg-blue-900/30 text-blue-700 dark:text-blue-300' \},\
        [SUBSCRIPTION_PLANS.PRO]: \{ icon: ShieldCheck, color: 'text-purple-600 dark:text-purple-400', button: 'border-purple-500 hover:bg-purple-50 dark:hover:bg-purple-900/30 text-purple-700 dark:text-purple-300' \},\
        [SUBSCRIPTION_PLANS.ULTRA]: \{ icon: ShieldQuestion, color: 'text-pink-600 dark:text-pink-400', button: 'border-pink-500 hover:bg-pink-50 dark:hover:bg-pink-900/30 text-pink-700 dark:text-pink-300' \} // Using ShieldQuestion as an example for Ultra\
    \};\
\
    return (\
        <div className="w-full h-screen flex flex-col items-center justify-center p-4 bg-gradient-to-br from-purple-50 via-indigo-50 to-blue-50 dark:from-slate-900 dark:via-purple-900 dark:to-slate-900 animate-fade-in">\
            <div className="w-full max-w-md bg-white dark:bg-slate-800 shadow-2xl rounded-2xl p-8 text-center">\
                 <img src="https://i.imgur.com/hwYnMXe.png" alt="Simu Logo" className="w-24 h-24 mx-auto mb-4 rounded-full shadow-lg border-4 border-white dark:border-slate-700" onError=\{(e) => \{ e.target.onerror = null; e.target.src=PLACEHOLDER_IMAGE_URL(96, 96, 'Simu') \}\} />\
                <h1 className="text-3xl font-bold text-slate-800 dark:text-slate-100 mb-2">Bem-vindo ao Simu!</h1>\
                <p className="text-slate-600 dark:text-slate-400 mb-8">Selecione um perfil para continuar:</p>\
\
                <div className="space-y-4">\
                    \{Object.values(SUBSCRIPTION_PLANS).map(plan => \{\
                        const details = planDetails[plan] || planDetails[SUBSCRIPTION_PLANS.BASIC];\
                        const Icon = details.icon;\
                        return (\
                            <button\
                                key=\{plan\}\
                                onClick=\{() => handleLoginClick(plan)\}\
                                className=\{`w-full flex items-center justify-center gap-3 px-6 py-4 rounded-lg border-2 $\{details.button\} font-semibold transition-all duration-200 ease-in-out transform hover:scale-[1.03] focus:outline-none focus:ring-2 focus:ring-offset-2 dark:focus:ring-offset-slate-800 focus:ring-current active:scale-95 shadow-sm hover:shadow-md`\}\
                            >\
                                <Icon className=\{`w-6 h-6 $\{details.color\}`\} />\
                                <span>Entrar como \{plan\}</span>\
                            </button>\
                        );\
                    \})\}\
                </div>\
\
                <p className="text-xs text-slate-400 dark:text-slate-500 mt-8">\
                    Esta \'e9 uma tela de login simulada para demonstra\'e7\'e3o.\
                </p>\
            </div>\
        </div>\
    );\
\});\
LoginView.displayName = 'LoginView';\
\
\
// --- Mobile Navigation Bar ---\
const AppNavBar = memo((\{ currentView, navigateToView \}) => \{ const navItems = useMemo(() => [\{ id: VIEW_INICIO, label: 'In\'edcio', icon: Home \}, \{ id: VIEW_HOME, label: 'Quiz', icon: ClipboardList \}, \{ id: VIEW_SIMULADOR, label: 'Simulador', icon: GraduationCap \}, \{ id: VIEW_PERFIL, label: 'Perfil', icon: User \},], []);\
    // Hide Nav Bar on non-main views\
    if ([VIEW_LOGIN, VIEW_EDIT_PROFILE, VIEW_SAVED_EXPLANATIONS, VIEW_LEARN_MORE, VIEW_UPGRADE].includes(currentView)) return null;\
    const navContainerClasses = `fixed bottom-4 left-1/2 -translate-x-1/2 flex items-center justify-around w-[calc(100%-2rem)] max-w-sm mx-auto p-1.5 space-x-1 bg-white/80 dark:bg-slate-800/80 backdrop-blur-lg rounded-full shadow-xl border border-slate-200/50 dark:border-slate-700/50 pointer-events-auto z-50 transition-transform duration-300 ease-in-out`;\
    return ( <nav className=\{navContainerClasses\}>\{navItems.map(item => \{ const isActive = currentView === item.id; const Icon = item.icon; return (<button key=\{item.id\} onClick=\{() => navigateToView(item.id)\} title=\{item.label\} aria-label=\{item.label\} aria-current=\{isActive ? 'page' : undefined\} className=\{`relative flex-1 flex items-center justify-center h-14 p-3 rounded-full transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-purple-400 focus:ring-offset-1 dark:focus:ring-offset-slate-800 active:scale-90 group $\{isActive ? 'text-purple-600 dark:text-purple-400 bg-purple-100/50 dark:bg-purple-900/30' : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100/50 dark:hover:bg-slate-700/50 hover:text-purple-500 dark:hover:text-purple-400'\}`\}><Icon className="w-6 h-6" aria-hidden="true" /></button>); \})\}</nav> );\
\});\
AppNavBar.displayName = 'AppNavBar';\
\
\
// --- Main Application Component ---\
function App() \{\
    // Global States\
    const [currentUser, setCurrentUser] = useState(null); // User starts as not logged in\
    const [currentView, setCurrentView] = useState(VIEW_LOGIN); // Start at login view\
    const [quizState, setQuizState] = useState('configuring');\
    const [configSelectedSubjects, setConfigSelectedSubjects] = useState([]);\
    const [configNumQuestions, setConfigNumQuestions] = useState(NUM_QUESTIONS_OPTIONS[0]);\
    const [isStartingQuiz, setIsStartingQuiz] = useState(false);\
    // Saved explanations state\
    const [savedExplanations, setSavedExplanations] = useState(() => \{\
        try \{\
            const saved = localStorage.getItem('savedExplanations_v1');\
            return saved ? JSON.parse(saved) : [];\
        \} catch (error) \{\
            console.error("Error loading saved explanations from localStorage:", error);\
            localStorage.removeItem('savedExplanations_v1');\
            return [];\
        \}\
    \});\
\
    // Smart Theme Logic\
    const [theme, setTheme] = useState('system');\
    const applyTheme = useCallback((themeToApply) => \{\
        const root = document.documentElement;\
        const isDark = themeToApply === 'dark' || (themeToApply === 'system' && window.matchMedia?.('(prefers-color-scheme: dark)').matches);\
        root.classList.remove('light', 'dark');\
        root.classList.add(isDark ? 'dark' : 'light');\
    \}, []);\
    useEffect(() => \{\
        const storedTheme = localStorage.getItem('appTheme');\
        const initialTheme = storedTheme && ['light', 'dark', 'system'].includes(storedTheme) ? storedTheme : 'system';\
        setTheme(initialTheme);\
        applyTheme(initialTheme);\
        const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');\
        const handleSystemThemeChange = () => \{\
            const currentPreference = localStorage.getItem('appTheme') || 'system';\
            if (currentPreference === 'system') applyTheme('system');\
        \};\
        mediaQuery.addEventListener('change', handleSystemThemeChange);\
        return () => mediaQuery.removeEventListener('change', handleSystemThemeChange);\
    \}, [applyTheme]);\
    const handleThemeChange = useCallback((newTheme) => \{\
        if (!['light', 'dark', 'system'].includes(newTheme)) newTheme = 'system';\
        setTheme(newTheme);\
        localStorage.setItem('appTheme', newTheme);\
        applyTheme(newTheme);\
    \}, [applyTheme]);\
\
    // Derived Data\
    const allSubjects = useMemo(() =>\
        Array.from(new Set(ORIGINAL_MOCK_QUESTIONS.map(q => q.subject).filter(Boolean)))\
             .filter(subject => SUBJECT_VISUALS.hasOwnProperty(subject))\
             .sort(),\
    []);\
\
    // --- Authentication Callbacks ---\
    const handleLogin = useCallback((permissionLevel) => \{\
        const user = createMockUser(permissionLevel);\
        setCurrentUser(user);\
        setCurrentView(VIEW_INICIO); // Navigate to initial view after login\
        console.log("User logged in:", user);\
    \}, []);\
\
    const handleLogout = useCallback(() => \{\
        setCurrentUser(null);\
        setCurrentView(VIEW_LOGIN); // Navigate back to login screen\
        setQuizState('configuring'); // Reset quiz state if logging out from quiz view\
        console.log("User logged out");\
    \}, []);\
\
    // Update user data (e.g., after profile edit)\
    const handleUpdateUser = useCallback((updatedUserData) => \{\
        setCurrentUser(prevData => \{\
            if (!prevData) return null; // Should not happen if called correctly\
            // Ensure we only update fields that exist in the original structure\
            const updated = \{ ...prevData \};\
            for (const key in updatedUserData) \{\
                if (Object.hasOwnProperty.call(prevData, key)) \{\
                    updated[key] = updatedUserData[key];\
                \}\
            \}\
            return updated;\
        \});\
        console.log("User data updated:", updatedUserData);\
    \}, []);\
\
\
    // --- Navigation Callback ---\
    const navigateToView = useCallback((viewName) => \{\
        // Prevent navigation to protected views if not logged in\
        if (!currentUser && viewName !== VIEW_LOGIN) \{\
            console.warn("Attempted to navigate to protected view while logged out. Redirecting to login.");\
            setCurrentView(VIEW_LOGIN);\
            return;\
        \}\
        // Reset quiz state if navigating away from the home/quiz view\
        if (currentView === VIEW_HOME && viewName !== VIEW_HOME) \{\
            setQuizState('configuring');\
        \}\
        setCurrentView(viewName);\
        window.scrollTo(\{ top: 0, behavior: 'smooth' \});\
    \}, [currentUser, currentView]); // Depend on currentUser\
\
    // --- Quiz Configuration Callbacks ---\
    const handleConfigSubjectToggle = useCallback((subject) => \{ setConfigSelectedSubjects(prevSelected => prevSelected.includes(subject) ? prevSelected.filter(s => s !== subject) : [...prevSelected, subject]); \}, []);\
    const handleConfigSelectAll = useCallback(() => \{ setConfigSelectedSubjects([]); \}, []);\
    const handleNumQuestionsChange = useCallback((num) => \{ if (NUM_QUESTIONS_OPTIONS.includes(num)) setConfigNumQuestions(num); else \{ console.warn(`Invalid number of questions: $\{num\}. Defaulting.`); setConfigNumQuestions(NUM_QUESTIONS_OPTIONS[0]); \} \}, []);\
    const handleStartQuiz = useCallback(() => \{ if (isStartingQuiz) return; if (allSubjects.length === 0) \{ alert("Erro: Nenhuma mat\'e9ria dispon\'edvel."); return; \} console.log("Starting quiz:", \{ subjects: configSelectedSubjects.length > 0 ? configSelectedSubjects : 'All', numQuestions: configNumQuestions \}); setIsStartingQuiz(true); setTimeout(() => \{ setQuizState('playing'); setIsStartingQuiz(false); \}, 300); \}, [configSelectedSubjects, configNumQuestions, isStartingQuiz, allSubjects]);\
    const handleGenerateAIRandomQuiz = useCallback(() => \{ if (isStartingQuiz || allSubjects.length === 0) return; console.log("Generating Quick AI Quiz..."); setIsStartingQuiz(true); const randomNumQuestions = AI_NUM_QUESTIONS_OPTIONS[Math.floor(Math.random() * AI_NUM_QUESTIONS_OPTIONS.length)]; setConfigNumQuestions(randomNumQuestions); const shuffledSubjects = shuffleArray(allSubjects); const numSubjectsToPick = Math.min(Math.floor(Math.random() * 2) + 1, allSubjects.length); const randomSubjects = shuffledSubjects.slice(0, numSubjectsToPick); setConfigSelectedSubjects(randomSubjects); console.log("Quick Quiz Config:", \{ subjects: randomSubjects, numQuestions: randomNumQuestions \}); setTimeout(() => \{ setQuizState('playing'); setIsStartingQuiz(false); \}, 300); \}, [allSubjects, isStartingQuiz]);\
    const handleReturnToConfig = useCallback(() => \{ console.log("Returning to config..."); setQuizState('configuring'); setIsStartingQuiz(false); \}, []);\
\
    // --- Explanation Save/Remove Callbacks ---\
    const handleSaveExplanation = useCallback((questionId, explanation) => \{\
        // Check permission before saving (Example: Basic cannot save)\
        if (currentUser?.subscription === SUBSCRIPTION_PLANS.BASIC) \{\
            alert("Funcionalidade dispon\'edvel apenas para planos Pro ou Ultra.");\
            return \{ success: false, message: 'Permiss\'e3o negada' \};\
        \}\
\
        let result = \{ success: false, message: 'Erro desconhecido' \};\
        setSavedExplanations(prevSaved => \{\
            if (prevSaved.some(item => item.questionId === questionId)) \{\
                result = \{ success: false, message: 'J\'e1 salvo!' \};\
                return prevSaved;\
            \}\
            const newSavedItem = \{ questionId, explanation, savedAt: new Date().toISOString() \};\
            const newSavedList = [...prevSaved, newSavedItem];\
            try \{\
                localStorage.setItem('savedExplanations_v1', JSON.stringify(newSavedList));\
                result = \{ success: true, message: 'Salvo!' \};\
                return newSavedList;\
            \} catch (error) \{\
                console.error("Error saving explanations to localStorage:", error);\
                result = \{ success: false, message: 'Erro ao salvar' \};\
                return prevSaved;\
            \}\
        \});\
        return result;\
    \}, [currentUser]); // Depend on currentUser for permission check\
\
    const handleRemoveExplanation = useCallback((questionIdToRemove) => \{\
        if (window.confirm("Tem certeza que deseja remover esta explica\'e7\'e3o salva?")) \{\
            setSavedExplanations(prevSaved => \{\
                const newSavedList = prevSaved.filter(item => item.questionId !== questionIdToRemove);\
                try \{\
                    localStorage.setItem('savedExplanations_v1', JSON.stringify(newSavedList));\
                    console.log(`Removed explanation for question ID: $\{questionIdToRemove\}`);\
                    return newSavedList;\
                \} catch (error) \{\
                    console.error("Error updating localStorage after removing explanation:", error);\
                    alert("Erro ao remover a explica\'e7\'e3o.");\
                    return prevSaved;\
                \}\
            \});\
        \}\
    \}, []);\
\
\
    // Handle "Learn More" click\
    const handleLearnMoreClick = useCallback(() => \{\
        // Example: Check permission for "Learn More"\
        if (currentUser?.subscription === SUBSCRIPTION_PLANS.BASIC) \{\
            alert("Funcionalidade 'Saiba Mais' dispon\'edvel apenas para planos Pro ou Ultra.");\
            navigateToView(VIEW_UPGRADE); // Optionally navigate to upgrade page\
            return;\
        \}\
        navigateToView(VIEW_LEARN_MORE);\
    \}, [currentUser, navigateToView]);\
\
    // Handle Upgrade CTA click\
    const handleUpgradeClick = useCallback(() => \{ navigateToView(VIEW_UPGRADE); \}, [navigateToView]);\
\
    // Desktop Navigation Bar\
    const DesktopNavBar = () => \{\
        const navItems = useMemo(() => [\
            \{ id: VIEW_INICIO, label: 'In\'edcio', icon: Home \},\
            \{ id: VIEW_HOME, label: 'Quiz', icon: ClipboardList \},\
            \{ id: VIEW_SIMULADOR, label: 'Simulador', icon: GraduationCap \},\
            \{ id: VIEW_PERFIL, label: 'Perfil', icon: User \},\
        ], []);\
        // Hide Nav Bar on non-main views or when logged out\
        if (!currentUser || [VIEW_LOGIN, VIEW_EDIT_PROFILE, VIEW_SAVED_EXPLANATIONS, VIEW_LEARN_MORE, VIEW_UPGRADE].includes(currentView)) return null;\
        return (\
            <nav className=\{`w-fit px-4 py-2 flex items-center justify-center bg-white/80 dark:bg-slate-800/80 backdrop-blur-lg border border-slate-200/60 dark:border-slate-700/60 shadow-lg space-x-3 rounded-full pointer-events-auto`\}>\
                 \{navItems.map(item => \{\
                    const isActive = currentView === item.id; const Icon = item.icon;\
                    return (<button key=\{item.id\} onClick=\{() => navigateToView(item.id)\} title=\{item.label\} aria-label=\{item.label\} aria-current=\{isActive ? 'page' : undefined\} className=\{`relative flex items-center justify-center w-auto h-12 px-4 rounded-full transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-purple-400 focus:ring-offset-1 dark:focus:ring-offset-slate-800 active:scale-90 group $\{isActive ? 'bg-purple-100 dark:bg-purple-900/50 text-purple-600 dark:text-purple-300 shadow-inner' : 'text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-700 hover:text-purple-500 dark:hover:text-purple-400'\}`\}>\
                            <Icon className="w-5 h-5" aria-hidden="true" />\
                        </button>);\
                \})\}\
            </nav>\
        );\
    \};\
\
    // Render Active View Based on State and Authentication\
    const renderView = () => \{\
        // If not logged in, always show LoginView\
        if (!currentUser) \{\
            return <LoginView onLogin=\{handleLogin\} />;\
        \}\
\
        // If logged in, render the requested view\
        switch (currentView) \{\
            case VIEW_LOGIN: // Should not happen if already logged in, but redirect just in case\
                 console.warn("Already logged in, redirecting from Login to Inicio.");\
                 useEffect(() => navigateToView(VIEW_INICIO), [navigateToView]);\
                 return null;\
            case VIEW_INICIO: return <InicioView />;\
            case VIEW_HOME:\
                return (\
                    <div className="w-full flex flex-col items-center justify-center flex-grow">\
                        \{quizState === 'configuring' && (\
                            <QuizConfigScreen allSubjects=\{allSubjects\} selectedSubjects=\{configSelectedSubjects\} numQuestions=\{configNumQuestions\} onNumQuestionsChange=\{handleNumQuestionsChange\} onToggleSubject=\{handleConfigSubjectToggle\} onSelectAll=\{handleConfigSelectAll\} onStartQuiz=\{handleStartQuiz\} onGenerateAIRandomQuiz=\{handleGenerateAIRandomQuiz\} isStarting=\{isStartingQuiz\} />\
                        )\}\
                        \{quizState === 'playing' && (\
                            <QuizGame\
                                key=\{`$\{configSelectedSubjects.join('-') || 'all'\}-$\{configNumQuestions\}-$\{currentUser.id\}`\} // Add user ID to key for potential user-specific quiz state reset\
                                activeSelectedSubjects=\{configSelectedSubjects\}\
                                activeNumQuestions=\{configNumQuestions\}\
                                onReturnToConfig=\{handleReturnToConfig\}\
                                onSaveExplanation=\{handleSaveExplanation\}\
                                onLearnMoreClick=\{handleLearnMoreClick\}\
                                onUpgradeClick=\{handleUpgradeClick\}\
                                subscriptionPlan=\{currentUser.subscription\} // Pass current user's plan\
                            />\
                        )\}\
                    </div>\
                );\
            case VIEW_SIMULADOR: return <SimuladorView />;\
            case VIEW_PERFIL:\
                return <PerfilView\
                            currentUser=\{currentUser\} // Pass logged-in user data\
                            navigateToView=\{navigateToView\}\
                            onUpdateUser=\{handleUpdateUser\}\
                            theme=\{theme\}\
                            onThemeChange=\{handleThemeChange\}\
                            savedExplanationsCount=\{savedExplanations.length\}\
                            onLogout=\{handleLogout\} // Pass logout handler\
                       />;\
            case VIEW_EDIT_PROFILE:\
                return <EditProfileView\
                            currentUser=\{currentUser\} // Pass logged-in user data\
                            navigateToView=\{navigateToView\}\
                            onUpdateUser=\{handleUpdateUser\}\
                        />;\
            case VIEW_LEARN_MORE: return <LearnMoreView />;\
            case VIEW_UPGRADE: return <UpgradeView />;\
            case VIEW_SAVED_EXPLANATIONS:\
                return <SavedExplanationsView\
                           savedExplanations=\{savedExplanations\}\
                           allQuestions=\{ORIGINAL_MOCK_QUESTIONS\}\
                           navigateToView=\{navigateToView\}\
                           onRemoveExplanation=\{handleRemoveExplanation\}\
                       />;\
            default:\
                console.warn(`Unknown view: $\{currentView\}, navigating to Inicio.`);\
                useEffect(() => \{ if (currentView !== VIEW_INICIO) navigateToView(VIEW_INICIO); \}, [currentView, navigateToView]);\
                return null;\
        \}\
    \};\
\
    // Add Global Styles and Animations\
    const GlobalStyles = () => ( <style>\{` @keyframes shake \{ 0%, 100% \{ transform: translateX(0); \} 10%, 30%, 50%, 70%, 90% \{ transform: translateX(-5px); \} 20%, 40%, 60%, 80% \{ transform: translateX(5px); \} \} .animate-shake \{ animation: shake 0.5s ease-in-out; \} @keyframes pop-in \{ 0% \{ opacity: 0; transform: scale(0.8); \} 80% \{ opacity: 1; transform: scale(1.05); \} 100% \{ opacity: 1; transform: scale(1); \} \} .animate-pop-in \{ animation: pop-in 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards; \} @keyframes fade-in \{ from \{ opacity: 0; \} to \{ opacity: 1; \} \} .animate-fade-in \{ animation: fade-in 0.5s ease-out forwards; \} @keyframes fade-in-up \{ from \{ opacity: 0; transform: translateY(15px); \} to \{ opacity: 1; transform: translateY(0); \} \} .animate-fade-in-up \{ animation: fade-in-up 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards; \} body, html \{ -webkit-overflow-scrolling: touch; \} input[type=range]::-webkit-slider-thumb \{\} input[type=range]::-moz-range-thumb \{\} input[type=range]::-ms-thumb \{\} body \{ background-color: #f1f5f9; \} html.dark body \{ background-color: #0f172a; \} @media (min-width: 768px) \{ body \{ background: linear-gradient(to bottom right, #f3e8ff, #dbeafe); \} html.dark body \{ background: linear-gradient(to bottom right, #3b0764, #1e3a8a); \} \} `\}</style> );\
\
    // Main App Structure\
    return (\
        <>\
            <GlobalStyles />\
            <div className="min-h-screen font-sans text-slate-800 dark:text-slate-200 flex flex-col">\
                 \{/* Desktop Layout */\}\
                 <div className="hidden md:block flex-grow">\
                     <div className="fixed top-0 left-0 right-0 z-50 flex justify-center p-4 pointer-events-none">\
                         <DesktopNavBar /> \{/* Nav bar only shown when logged in */\}\
                     </div>\
                     <main className="w-full flex flex-col items-center pt-24 pb-8 px-4">\
                         <div className="w-full max-w-screen-2xl flex justify-center">\
                            \{renderView()\} \{/* Renders Login or main content */\}\
                         </div>\
                     </main>\
                 </div>\
\
                 \{/* Mobile Layout */\}\
                 <div className="md:hidden flex flex-col flex-grow">\
                     <main className="w-full flex-grow flex flex-col items-center justify-start pb-24 overflow-y-auto">\
                         <div className="w-full max-w-full flex flex-col items-center flex-grow">\
                             \{renderView()\} \{/* Renders Login or main content */\}\
                         </div>\
                     </main>\
                     \{/* Mobile Nav Bar (Only shown when logged in and on main views) */\}\
                     \{currentUser && ![VIEW_LOGIN, VIEW_EDIT_PROFILE, VIEW_SAVED_EXPLANATIONS, VIEW_LEARN_MORE, VIEW_UPGRADE].includes(currentView) && (\
                         <AppNavBar currentView=\{currentView\} navigateToView=\{navigateToView\} />\
                     )\}\
                 </div>\
            </div>\
        </>\
    );\
\}\
\
export default App;\
}
