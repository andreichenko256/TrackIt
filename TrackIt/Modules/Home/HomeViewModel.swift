import UIKit
import Combine

final class HomeViewModel {
    
    @Published private(set) var habits: [Habit] = []
    @Published private(set) var groupedHabits: [Date: [Habit]] = [:]
    @Published private(set) var sortedDates: [Date] = []
    
    func loadHabits() {
        habits = [
            Habit(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", isCompleted: true, dateCreated: Date()),
            Habit(title: "Workout", isCompleted: false, dateCreated: Date()),
            Habit(title: "Read book", isCompleted: false, dateCreated: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
            Habit(title: "Meditation", isCompleted: true, dateCreated: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
            Habit(title: "Read book", isCompleted: false, dateCreated: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
            Habit(title: "Meditation", isCompleted: true, dateCreated: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
            Habit(title: "Meditation", isCompleted: true, dateCreated: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            Habit(title: "Meditation", isCompleted: true, dateCreated: Calendar.current.date(byAdding: .day, value: -4, to: Date())!)
        ]
        groupHabits()
    }
    
    func addHabit() {
        let newHabit = Habit(title: "New habit", isCompleted: false, dateCreated: Date())
        habits.append(newHabit)
        groupHabits()
    }
    
    func toggleHabit(at indexPath: IndexPath) {
        let date = sortedDates[indexPath.section]
        guard var habitsForDate = groupedHabits[date] else { return }
        
        habitsForDate[indexPath.row].isCompleted.toggle()
        groupedHabits[date] = habitsForDate
        
        if let index = habits.firstIndex(where: { $0.id == habitsForDate[indexPath.row].id }) {
            habits[index].isCompleted = habitsForDate[indexPath.row].isCompleted
        }
    }
    
    private func groupHabits() {
        let calendar = Calendar.current
        
        groupedHabits = Dictionary(grouping: habits) { habit in
            calendar.startOfDay(for: habit.dateCreated)
        }
        
        sortedDates = groupedHabits.keys.sorted(by: >)
    }
}
