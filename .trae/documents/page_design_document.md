# Page Design Document

## 1. Design System
- **Colors**:
    - Primary: Emerald/Green (representing travel/go).
    - Secondary: Amber/Orange (for warnings/highlights).
    - Neutral: Slate/Zinc.
- **Typography**: Clean, sans-serif. Large font size for Chinese characters.

## 2. Page Flow

### 2.1 Home Page (`/`)
- **Header**: App Title "Travel Chinese 100".
- **Hero Section**: Progress summary (e.g., "15/100 Learned").
- **Category Grid**:
    - Transportation (Icon + Label + Progress)
    - Dining
    - Accommodation
    - Shopping
    - Emergency
- **Quick Access**: "Emergency Mode" button (Floating or prominent).

### 2.2 Category Detail Page (`/category/:id`)
- **Header**: Back button, Category Title.
- **List View**:
    - List of phrases in this category.
    - Each item shows: English preview, Checkmark if learned.
    - Click item -> Go to Learning Mode.

### 2.3 Learning Mode (`/learn/:id`)
- **Top**: Progress bar (Step 1 -> 2 -> 3).
- **Step 1: Listen**:
    - Large Image.
    - Chinese Text (Large).
    - Pinyin.
    - English.
    - Play Button (Audio).
    - "Next" Button.
- **Step 2: Speak**:
    - Text displayed.
    - "Microphone" Button (Hold to record / Tap to start).
    - Feedback area: "Great!" or "Try again".
- **Step 3: Use (Simulation)**:
    - Context description (e.g., "You are at a restaurant").
    - Prompt: "Order a bowl of noodles."
    - User speaks -> Success animation.

### 2.4 Emergency Card Mode (`/card/:id` or Modal)
- Full screen.
- Large Chinese Text.
- English subtitle (smaller).
- "Play Audio" button (Icon only).
- Close button.

### 2.5 Emergency Dashboard (`/emergency`)
- Grid of critical phrases (Police, Hospital, Embassay, Lost).
- Tapping opens the "Emergency Card" directly.
