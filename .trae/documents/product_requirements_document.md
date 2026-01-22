# Product Requirements Document: Travel Chinese 100

## 1. Project Overview
A lightweight, low-cost, and effective Chinese learning App focused on "100 Chinese Travel Phrases". It aims to help tourists communicate in China with zero learning cost.

## 2. Core Philosophy
- **Focus**: Only the 100 most practical travel phrases (asking directions, ordering food, shopping, emergency).
- **Simplicity**: No complex AI, no backend dependency, offline-first.
- **Efficiency**: 3-step learning method (Listen, Speak, Use).

## 3. User Stories & Features

### 3.1 Scenario-Based Learning
- **Categorization**: Phrases grouped by scenarios (Transportation, Dining, Accommodation, Shopping, Emergency).
- **Content**: Each phrase includes:
    - Simplified Chinese
    - Pinyin
    - Translation (English)
    - Audio (Male/Female native speakers)
    - Contextual Illustration

### 3.2 Three-Step Learning Process
1.  **Listen**: Play standard audio.
2.  **Speak**: User repeats the phrase. App uses basic speech recognition to give feedback (Correct/Try Again).
3.  **Use**: Simulated dialogue (e.g., App asks a question, User responds).

### 3.3 Emergency Tools
- **One-Click Play**: "Help me order" button to play audio directly to service staff.
- **Offline Cards**: Full-screen bilingual flashcards to show to locals (e.g., "Please take me to the hospital").

### 3.4 User Profile (Local)
- Track progress (which sentences are mastered).
- No login required.

## 4. Non-Functional Requirements
- **Offline First**: All assets (text, images, audio) bundled with the app.
- **Performance**: Fast load time, lightweight (< 50MB target).
- **Platform**: Web App (PWA) compatible with mobile browsers.

## 5. Content Strategy
- **Source**: 100 carefully selected phrases from travel guides.
- **Audio**: Pre-recorded files (mocked/placeholder for development).
- **Images**: AI-generated or free stock illustrations.
