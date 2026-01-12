import Foundation

struct Habit: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    let dateCreated: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool, dateCreated: Date) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
    }
}
