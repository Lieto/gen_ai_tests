## 6. Detailed Component Design (Elaborated)

### 6.1. Question Pool Loader

**Purpose:**  
Centralizes acquisition, validation, and formatting of the HAM radio question pool. This is a critical foundation, as all tests depend on the integrity and accessibility of this data.

**Responsibilities:**
- **Data Sources:** Import questions from formats such as JSON, CSV, XML, or direct API endpoints.  
- **Parsing & Validation:** Ensure each question includes required fields (id, text, choices, correct answer, optional explanation) and that all IDs are unique.  
- **Sanitization:** Remove malformed or duplicate entries.  
- **Caching:** Optionally cache parsed questions in memory for faster access (especially if sourced remotely).
- **Error Handling:** Log and report any data inconsistencies or failed loads.

**Pitfalls/Mitigations:**
- *Malformed Data:* Implement strict schema validation and fallback to last known good pool.
- *Performance Issues:* Use lazy loading or pagination for very large pools.

---

### 6.2. Test Generator

**Purpose:**  
Creates a randomized set of 35 questions per session, guaranteeing uniqueness and fairness.

**Responsibilities:**
- **Random Selection Algorithm:**  
  - Shuffle pool using Fisher-Yates or similar algorithm for true randomness.
  - Select the first 35 items post-shuffle.
- **Uniqueness Guarantee:**  
  - Ensure no duplicate questions in a single test session.
- **Session State:**  
  - Store selected questions and track which have been answered.

**Pitfalls/Mitigations:**
- *Randomness Bias:* Use cryptographically secure random sources if available.
- *Pool Size Limit:* Validate that pool has at least 35 questions; gracefully handle smaller pools.

---

### 6.3. UI Components

**Purpose:**  
Facilitates user interaction—displaying questions, collecting answers, navigating, and submitting.

**Key Components:**
- **Question Display:**  
  - Shows current question text and choices.
  - May include optional image, diagram, or explanation.
- **Answer Selector:**  
  - Render choices as radio buttons, dropdowns, or touch-friendly buttons.
  - Only one answer may be selected per question.
- **Navigation Controls:**  
  - “Next”, “Previous”, and/or direct jump to question number.
  - Optionally support review of unanswered questions.
- **Submission Button:**  
  - Clearly marked, with confirmation dialog to prevent accidental submission.

**Pitfalls/Mitigations:**
- *Accidental Answer Changes:* Lock answered questions on submission.
- *Accessibility Issues:* Use semantic HTML and ARIA tags for web, accessible controls for mobile.
- *Lost Progress:* Optionally autosave answers to local storage until submission.

---

### 6.4. Grading Engine

**Purpose:**  
Evaluates user answers against correct answers, calculates score, and prepares feedback.

**Responsibilities:**
- **Answer Comparison:**  
  - For each question, compare user’s choice with the correct answer index.
- **Score Calculation:**  
  - Total correct answers / 35 = percentage score.
- **Result Aggregation:**  
  - Prepare lists of correct, incorrect, and unanswered questions.
- **Feedback Generation:**  
  - Optionally attach explanations for incorrect answers.

**Pitfalls/Mitigations:**
- *Edge Cases:* Handle unanswered questions as incorrect or “null” depending on UI logic.
- *Grading Errors:* Unit test grading logic to avoid off-by-one mistakes.
- *Feedback Overload:* Optionally offer a summary before full answer breakdown.

---

### 6.5. Feedback Presenter

**Purpose:**  
Delivers results and learning guidance to the user in a clear, actionable format.

**Responsibilities:**
- **Score Display:**  
  - Prominent percentage score, pass/fail indication if desired.
- **Detailed Review:**  
  - For each question: show user’s answer, correct answer, explanation (if available).
- **Progress Tracking (Optional):**  
  - Summarize areas of strength/weakness if historical data is tracked.
- **Retake/Review Options:**  
  - Allow user to retake test, review missed questions, or start a new session.

**Pitfalls/Mitigations:**
- *Information Overload:* Paginate or collapse feedback for long reviews.
- *Discouragement:* Present feedback constructively, focusing on learning.
- *Privacy:* Ensure user scores/history are only stored locally unless explicit consent is given.

---

## 6.x. Additional Considerations

- **State Management:**  
  - Use robust state management (e.g., Redux for web, context/state for mobile) to track test session, answers, and UI flow.
- **Extensibility:**  
  - Design components so new question formats (e.g., images, multi-select) can be added with minimal refactoring.
- **Testing:**  
  - Comprehensive unit and integration tests for data handling, test generation, grading, and UI flows.
