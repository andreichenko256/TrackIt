import Foundation

struct Habit {
    let id = UUID()
    let title: String
    var isCompleted: Bool
    let dateCreated: Date
}
