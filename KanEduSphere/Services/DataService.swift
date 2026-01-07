//
//  DataService.swift
//  KanEduSphere
//

import Foundation

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    func getLessons() -> [Lesson] {
        return [
            Lesson(
                title: "Spanish Basics: Greetings & Introductions",
                description: "Learn essential Spanish greetings and how to introduce yourself in Spanish-speaking countries.",
                category: .language,
                difficulty: .beginner,
                duration: 15,
                points: 100,
                quizQuestions: [
                    QuizQuestion(
                        question: "How do you say 'Hello' in Spanish?",
                        options: ["Adiós", "Hola", "Gracias", "Por favor"],
                        correctAnswer: 1,
                        explanation: "'Hola' is the most common way to say hello in Spanish."
                    ),
                    QuizQuestion(
                        question: "What does 'Me llamo' mean?",
                        options: ["Goodbye", "My name is", "Thank you", "Please"],
                        correctAnswer: 1,
                        explanation: "'Me llamo' literally translates to 'I call myself' and is used to introduce your name."
                    ),
                    QuizQuestion(
                        question: "How do you ask 'How are you?' in Spanish?",
                        options: ["¿Cómo estás?", "¿Qué tal?", "Both answers", "¿Dónde está?"],
                        correctAnswer: 2,
                        explanation: "Both '¿Cómo estás?' and '¿Qué tal?' are commonly used to ask how someone is doing."
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "Welcome to Spanish Basics! In this lesson, you'll learn the fundamental greetings that will help you start conversations in Spanish."),
                    LessonContent(type: .text, text: "Common Greetings:\n• Hola - Hello\n• Buenos días - Good morning\n• Buenas tardes - Good afternoon\n• Buenas noches - Good evening/night"),
                    LessonContent(type: .text, text: "Introducing Yourself:\n• Me llamo... - My name is...\n• Soy... - I am...\n• Mucho gusto - Nice to meet you\n• Encantado/a - Pleased to meet you"),
                    LessonContent(type: .interactive, text: "Practice: Try saying 'Hello, my name is [your name]. Nice to meet you!' in Spanish.")
                ]
            ),
            Lesson(
                title: "French Pronunciation: Vowels & Accents",
                description: "Master French vowel sounds and understand how accents change pronunciation.",
                category: .language,
                difficulty: .intermediate,
                duration: 20,
                points: 150,
                quizQuestions: [
                    QuizQuestion(
                        question: "What sound does 'é' make in French?",
                        options: ["eh", "ay", "ee", "ah"],
                        correctAnswer: 1,
                        explanation: "The accent aigu (é) produces an 'ay' sound, like in 'café'."
                    ),
                    QuizQuestion(
                        question: "Which accent makes a vowel sound more open?",
                        options: ["Accent aigu (é)", "Accent grave (è)", "Accent circonflexe (ê)", "Tréma (ë)"],
                        correctAnswer: 1,
                        explanation: "The accent grave (è) creates a more open 'eh' sound."
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "French pronunciation can be challenging, but mastering vowels and accents is key to sounding natural."),
                    LessonContent(type: .text, text: "French Accents:\n• Accent aigu (é) - closed 'ay' sound\n• Accent grave (è) - open 'eh' sound\n• Accent circonflexe (ê) - slightly elongated vowel\n• Tréma (ë) - separate pronunciation"),
                    LessonContent(type: .interactive, text: "Listen and repeat: été (summer), père (father), fête (party), Noël (Christmas)")
                ]
            ),
            Lesson(
                title: "Algebra Fundamentals: Linear Equations",
                description: "Understand and solve linear equations with practical examples.",
                category: .mathematics,
                difficulty: .beginner,
                duration: 25,
                points: 120,
                quizQuestions: [
                    QuizQuestion(
                        question: "Solve for x: 2x + 5 = 15",
                        options: ["x = 5", "x = 10", "x = 7.5", "x = 20"],
                        correctAnswer: 0,
                        explanation: "Subtract 5 from both sides: 2x = 10, then divide by 2: x = 5"
                    ),
                    QuizQuestion(
                        question: "What is the first step to solve: 3x - 7 = 14?",
                        options: ["Divide by 3", "Add 7 to both sides", "Subtract 14", "Multiply by 3"],
                        correctAnswer: 1,
                        explanation: "Add 7 to both sides to isolate the term with x: 3x = 21"
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "Linear equations are the foundation of algebra. They represent relationships where variables have a constant rate of change."),
                    LessonContent(type: .text, text: "Key Steps to Solve Linear Equations:\n1. Simplify both sides\n2. Move variables to one side\n3. Move constants to the other side\n4. Divide or multiply to isolate the variable"),
                    LessonContent(type: .text, text: "Example: Solve 4x + 8 = 28\nStep 1: Subtract 8 from both sides → 4x = 20\nStep 2: Divide both sides by 4 → x = 5"),
                    LessonContent(type: .interactive, text: "Practice: Try solving 5x - 3 = 22 on your own!")
                ]
            ),
            Lesson(
                title: "Python Basics: Variables & Data Types",
                description: "Learn about Python variables, data types, and basic operations.",
                category: .programming,
                difficulty: .beginner,
                duration: 30,
                points: 140,
                quizQuestions: [
                    QuizQuestion(
                        question: "Which data type would you use to store the number 3.14?",
                        options: ["int", "float", "str", "bool"],
                        correctAnswer: 1,
                        explanation: "Floating-point numbers (decimals) are stored using the 'float' data type."
                    ),
                    QuizQuestion(
                        question: "What is the output of: print(type('Hello'))?",
                        options: ["<class 'int'>", "<class 'str'>", "<class 'float'>", "<class 'bool'>"],
                        correctAnswer: 1,
                        explanation: "Text enclosed in quotes is a string, so the type is 'str'."
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "Python is a versatile programming language. Understanding variables and data types is your first step to mastery."),
                    LessonContent(type: .text, text: "Basic Data Types:\n• int - Whole numbers (e.g., 42)\n• float - Decimal numbers (e.g., 3.14)\n• str - Text/strings (e.g., 'Hello')\n• bool - True or False values"),
                    LessonContent(type: .text, text: "Creating Variables:\nname = 'Alice'\nage = 25\nheight = 5.6\nis_student = True"),
                    LessonContent(type: .interactive, text: "Practice: Create a variable for your favorite number and print its type.")
                ]
            ),
            Lesson(
                title: "Physics: Newton's Laws of Motion",
                description: "Explore the three fundamental laws that govern motion and forces.",
                category: .science,
                difficulty: .intermediate,
                duration: 35,
                points: 180,
                quizQuestions: [
                    QuizQuestion(
                        question: "What is Newton's First Law?",
                        options: ["F = ma", "An object at rest stays at rest unless acted upon", "Action-reaction", "E = mc²"],
                        correctAnswer: 1,
                        explanation: "Newton's First Law states that an object remains at rest or in uniform motion unless acted upon by an external force."
                    ),
                    QuizQuestion(
                        question: "If force = 20N and mass = 4kg, what is acceleration?",
                        options: ["5 m/s²", "80 m/s²", "16 m/s²", "24 m/s²"],
                        correctAnswer: 0,
                        explanation: "Using F = ma, acceleration = F/m = 20/4 = 5 m/s²"
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "Isaac Newton's three laws of motion revolutionized our understanding of physics and mechanics."),
                    LessonContent(type: .text, text: "First Law (Inertia):\nAn object at rest stays at rest, and an object in motion stays in motion at constant velocity, unless acted upon by an unbalanced force."),
                    LessonContent(type: .text, text: "Second Law (F = ma):\nThe acceleration of an object depends on the net force acting upon it and its mass. Formula: Force = Mass × Acceleration"),
                    LessonContent(type: .text, text: "Third Law (Action-Reaction):\nFor every action, there is an equal and opposite reaction.")
                ]
            ),
            Lesson(
                title: "Digital Art: Color Theory Fundamentals",
                description: "Understanding color wheels, harmony, and psychological effects of colors.",
                category: .arts,
                difficulty: .beginner,
                duration: 20,
                points: 110,
                quizQuestions: [
                    QuizQuestion(
                        question: "What are the primary colors?",
                        options: ["Red, Green, Blue", "Red, Yellow, Blue", "Orange, Green, Purple", "Black, White, Gray"],
                        correctAnswer: 1,
                        explanation: "The primary colors are Red, Yellow, and Blue. They cannot be created by mixing other colors."
                    ),
                    QuizQuestion(
                        question: "Which colors are complementary to each other?",
                        options: ["Colors next to each other", "Colors opposite on the color wheel", "All warm colors", "All cool colors"],
                        correctAnswer: 1,
                        explanation: "Complementary colors are opposite each other on the color wheel and create high contrast."
                    )
                ],
                content: [
                    LessonContent(type: .text, text: "Color theory is essential for any artist. It helps you create visually appealing and emotionally impactful artwork."),
                    LessonContent(type: .text, text: "Color Wheel Basics:\n• Primary: Red, Yellow, Blue\n• Secondary: Orange, Green, Purple\n• Tertiary: Combinations of primary and secondary"),
                    LessonContent(type: .text, text: "Color Harmony:\n• Complementary: Opposite colors (e.g., Blue & Orange)\n• Analogous: Adjacent colors (e.g., Blue, Blue-Green, Green)\n• Triadic: Three evenly spaced colors"),
                    LessonContent(type: .interactive, text: "Experiment: Try creating a color palette using complementary colors.")
                ]
            )
        ]
    }
    
    func getChallenges() -> [Challenge] {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        
        return [
            Challenge(
                title: "Daily Language Sprint",
                description: "Complete 3 language lessons today to maintain your streak!",
                type: .daily,
                category: .language,
                points: 50,
                tasks: [
                    ChallengeTask(description: "Complete a beginner lesson", requiredCount: 1),
                    ChallengeTask(description: "Complete an intermediate lesson", requiredCount: 1),
                    ChallengeTask(description: "Practice pronunciation", requiredCount: 1)
                ],
                expiryDate: tomorrow
            ),
            Challenge(
                title: "Math Master Challenge",
                description: "Solve 20 algebra problems this week",
                type: .weekly,
                category: .mathematics,
                points: 200,
                tasks: [
                    ChallengeTask(description: "Solve linear equations", requiredCount: 10),
                    ChallengeTask(description: "Practice word problems", requiredCount: 5),
                    ChallengeTask(description: "Complete a quiz with 80%+", requiredCount: 1)
                ],
                expiryDate: nextWeek
            ),
            Challenge(
                title: "Code Every Day",
                description: "Write code for 7 consecutive days",
                type: .special,
                category: .programming,
                points: 300,
                tasks: [
                    ChallengeTask(description: "Complete a Python lesson", requiredCount: 7),
                    ChallengeTask(description: "Solve coding exercises", requiredCount: 7)
                ],
                expiryDate: nextWeek
            ),
            Challenge(
                title: "Science Explorer",
                description: "Learn about physics concepts today",
                type: .daily,
                category: .science,
                points: 75,
                tasks: [
                    ChallengeTask(description: "Study Newton's Laws", requiredCount: 1),
                    ChallengeTask(description: "Complete physics quiz", requiredCount: 1)
                ],
                expiryDate: tomorrow
            )
        ]
    }
    
    func generateAIFeedback(for lessonId: UUID, userInput: String, type: AIFeedback.FeedbackType) -> AIFeedback {
        let feedbackData: [(score: Double, suggestions: [String], strengths: [String], improvements: [String])] = [
            (
                score: 0.85,
                suggestions: ["Practice the 'r' sound more", "Try listening to native speakers", "Record yourself and compare"],
                strengths: ["Clear vowel pronunciation", "Good rhythm and pace", "Natural intonation"],
                improvements: ["Rolling 'r' sounds", "Consonant clusters", "Accent consistency"]
            ),
            (
                score: 0.92,
                suggestions: ["Keep up the excellent work", "Try more complex sentences", "Practice with conversation partners"],
                strengths: ["Perfect grammar structure", "Rich vocabulary usage", "Natural flow"],
                improvements: ["Advanced vocabulary", "Idiomatic expressions"]
            ),
            (
                score: 0.78,
                suggestions: ["Review verb conjugations", "Practice with flashcards", "Focus on irregular verbs"],
                strengths: ["Good understanding of basics", "Clear pronunciation", "Consistent effort"],
                improvements: ["Verb tenses", "Plural forms", "Gender agreement"]
            )
        ]
        
        let randomFeedback = feedbackData.randomElement() ?? feedbackData[0]
        
        return AIFeedback(
            lessonId: lessonId,
            userInput: userInput,
            feedbackType: type,
            score: randomFeedback.score,
            suggestions: randomFeedback.suggestions,
            strengths: randomFeedback.strengths,
            areasToImprove: randomFeedback.improvements
        )
    }
}

