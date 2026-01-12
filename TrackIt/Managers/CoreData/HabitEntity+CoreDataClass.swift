import Foundation
import CoreData

@objc(HabitEntity)
public class HabitEntity: NSManagedObject {
    
    func toHabit() -> Habit {
        return Habit(
            id: id ?? UUID(),
            title: title ?? "",
            isCompleted: isCompleted,
            dateCreated: dateCreated ?? Date()
        )
    }
    
    func update(from habit: Habit) {
        self.id = habit.id
        self.title = habit.title
        self.isCompleted = habit.isCompleted
        self.dateCreated = habit.dateCreated
    }
}
