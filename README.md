# TodoApp-SwiftUI
Todo App SwiftUI

## Approach
- My approach was to build a simple and reliable todo application focused specifically on tasks for the current day. I began by identifying the core functionality: adding tasks, removing tasks, and optionally attaching reminders to tasks.
- I implemented the UI using SwiftUI, which allowed me to create a reactive interface that automatically updates when the underlying data changes. Architecturally, I used the MVVM (Model–View–ViewModel) pattern to separate responsibilities. The View layer handles the UI, the ViewModel manages the application logic and state, and the Model represents the todo data stored using Core Data.
- Since the minimum deployment target was iOS 16, I used Core Data for persistence to ensure tasks remain stored locally and survive app restarts. The ViewModel acts as the bridge between the SwiftUI views and the persistence layer, ensuring the UI stays synchronized with the stored tasks.
- I also integrated reminder scheduling so that users can receive notifications for tasks at specific times. Throughout the implementation, I focused on keeping the app responsive, maintaining clean data flow, and ensuring the UI consistently reflects the latest state of the todo list.

## Key Decisions or Tradeoffs
- One key decision was choosing Core Data as the persistence solution. Although newer frameworks like SwiftData simplify data management in SwiftUI applications, they require iOS 17+, so Core Data was the best option given the iOS 16 minimum target.
- Another important design choice was structuring the application using the MVVM architecture. This helped maintain a clear separation between UI logic and data management, making the codebase easier to maintain and extend.
- I also prioritized thread safety when handling todo updates and reminder scheduling. Since data operations and UI updates can occur asynchronously, careful management of state updates was necessary to avoid race conditions or inconsistencies in the task list.

## Improvements
- With more time, I would improve feature set of the application such as editing the existing todo, add a priority list, category of different todos and improved UI feedback.
- Onboarding of a new user on the app, so that user can customise their name, avatar etc.
- One area of improvement would be the reminder system, making it more robust by handling additional edge cases like rescheduling notifications, and improving background reliability.
- I would also refine the packaging of different Manager classes into plug-n-play SPM packages to modularize different components, for example separating notification scheduling and persistence into dedicated services to make the App lighter and easier to test.
- Finally, if the minimum OS requirement allowed it, I would explore migrating from Core Data to SwiftData, which integrates more naturally with SwiftUI and could simplify the persistence layer.

### Sample
https://github.com/punitzen/TodoApp-SwiftUI/blob/main/sample.mov
