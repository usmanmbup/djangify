# Djangify

Djangify is an educational mobile application designed to help students access lessons and exercises based on their class and course preferences. The app features an intuitive interface with dropdown selections and navigation to relevant content.

---

## Features

- **Class Selection:** Choose your class (e.g., Seconde, Premiere, Terminale) to filter available lessons and exercises.
- **Course Selection:** Pick from a variety of courses, including Electricité, Mécanique, Maths, and more.
- **Persistent Data:** The app remembers your selected class and course using `SharedPreferences`.
- **Lesson & Exercise Access:** Navigate to tailored lesson or exercise sections based on your selections.

---

## Screens

1. **Home Screen:**
   - Select your class and course using dropdown menus.
   - Buttons for accessing lessons and exercises are only enabled once valid selections are made.

2. **Lessons Screen:**
   - Displays lessons filtered by the selected class and course.

3. **Exercises Screen:**
   - Displays exercises filtered by the selected class and course.

---

## Technologies Used

- **Flutter:** Framework for building the app.
- **Firebase Firestore:** Stores and retrieves lesson and exercise data.
- **SharedPreferences:** Saves and loads user preferences (class and course).
- **Dart:** Primary programming language for Flutter.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/djangify.git

   ```bash
   cd djangify
   
