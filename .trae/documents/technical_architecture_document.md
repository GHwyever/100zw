# Technical Architecture Document

## 1. Tech Stack
- **Framework**: React + TypeScript (Vite template).
- **UI Library**: Tailwind CSS for styling.
- **Icons**: Lucide-React.
- **State Management**: Zustand (for tracking learning progress).
- **Routing**: React Router DOM.
- **Build Tool**: Vite.

## 2. System Architecture
- **Client-Side Only**: No backend server. All logic runs in the browser.
- **Data Persistence**: `localStorage` to save user progress (e.g., list of completed phrases).
- **Content Storage**: JSON files for phrase data (id, chinese, pinyin, translation, audioPath, imagePath).

## 3. Key Modules

### 3.1 Data Model
```typescript
interface Phrase {
  id: string;
  category: string; // e.g., 'transport', 'dining'
  chinese: string;
  pinyin: string;
  english: string;
  audioSrc: string; // Path to audio file
  imageSrc: string; // Path to image
}

interface UserProgress {
  completedPhraseIds: string[];
  // Potential for simple stats
}
```

### 3.2 Audio & Speech
- **Playback**: HTML5 `<audio>` element or `Audio` object.
- **Recognition**: Web Speech API (`window.SpeechRecognition` or `window.webkitSpeechRecognition`).
    - *Fallback*: If API not available, show a message or simple "Self-check" mode.

### 3.3 Offline Capability
- Use Vite PWA plugin (optional for MVP, but good for "App-like" feel) or simply rely on browser caching for assets.
- Since it's a "Low Cost" MVP, we start with standard web caching.

## 4. Directory Structure
```
src/
  assets/         # Static files (images, audio placeholders)
  components/     # Reusable UI components (Button, Card, AudioPlayer)
  data/           # JSON content (phrases.json)
  hooks/          # Custom hooks (useSpeechRecognition, useAudio)
  pages/          # Route components (Home, Category, Learn, Emergency)
  store/          # Zustand store
  utils/          # Helper functions
```
