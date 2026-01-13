import UIKit
import Combine

final class HomeViewModel {
    @Published private(set) var habits: [Habit] = []
    @Published private(set) var groupedHabits: [Date: [Habit]] = [:]
    @Published private(set) var sortedDates: [Date] = []
    
    var numberOfHabits: Int {
        habits.count
    }

    var numberOfHabitsPublisher: AnyPublisher<Bool, Never> {
        $habits
            .map { $0.count > 0 }
            .eraseToAnyPublisher()
    }
    
    var isPremiumUser: Bool {
        return UserDefaultsStorage.shared.get(.isPremiumUser) ?? false
    }
    
    var isPremiumUserPublisher: AnyPublisher<Bool, Never> {
        Just(isPremiumUser)
            .eraseToAnyPublisher()
    }
    
    private let coreDataManager = CoreDataManager.shared
    
    func loadHabits() {
        habits = coreDataManager.fetchAllHabits()
        groupHabits()
    }
    
    func addHabit(title: String) {
        let newHabit = coreDataManager.createHabit(title: title)
        habits.append(newHabit)
        groupHabits()
    }
    
    func numberOfSections() -> Int {
        return sortedDates.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard section < sortedDates.count else { return 0 }
        let date = sortedDates[section]
        return groupedHabits[date]?.count ?? 0
    }
    
    func habit(at indexPath: IndexPath) -> Habit? {
        guard indexPath.section < sortedDates.count else { return nil }
        let date = sortedDates[indexPath.section]
        guard let habits = groupedHabits[date], indexPath.row < habits.count else { return nil }
        return habits[indexPath.row]
    }
    
    func headerTitle(for section: Int) -> String {
        guard section < sortedDates.count else { return "" }
        let date = sortedDates[section]
        return formatDate(date)
    }
    
    func toggleHabit(at indexPath: IndexPath) {
        let date = sortedDates[indexPath.section]
        guard var habitsForDate = groupedHabits[date] else { return }
        
        habitsForDate[indexPath.row].isCompleted.toggle()
        groupedHabits[date] = habitsForDate
        
        if let index = habits.firstIndex(where: { $0.id == habitsForDate[indexPath.row].id }) {
            habits[index].isCompleted = habitsForDate[indexPath.row].isCompleted
            
            coreDataManager.updateHabit(habits[index])
        }
    }
    
    func updateHabit(at indexPath: IndexPath, newTitle: String) {
        let date = sortedDates[indexPath.section]
        guard var habitsForDate = groupedHabits[date] else { return }
        
        habitsForDate[indexPath.row].title = newTitle
        groupedHabits[date] = habitsForDate
        
        let habitToUpdate = habitsForDate[indexPath.row]
        if let index = habits.firstIndex(where: { $0.id == habitToUpdate.id }) {
            habits[index].title = newTitle
            
            coreDataManager.updateHabit(habits[index])
        }
    }
    
    func deleteHabit(at indexPath: IndexPath) -> Bool {
        let date = sortedDates[indexPath.section]
        guard var habitsForDate = groupedHabits[date] else { return false }
        
        let habitToDelete = habitsForDate[indexPath.row]
        
        coreDataManager.deleteHabit(withId: habitToDelete.id)
        
        if let index = habits.firstIndex(where: { $0.id == habitToDelete.id }) {
            habits.remove(at: index)
        }
        
        habitsForDate.remove(at: indexPath.row)
        
        if habitsForDate.isEmpty {
            groupedHabits.removeValue(forKey: date)
            sortedDates.removeAll { $0 == date }
            return true
        } else {
            groupedHabits[date] = habitsForDate
            return false
        }
    }
    
    func completeAllHabits() {
        for index in habits.indices {
            if !habits[index].isCompleted {
                habits[index].isCompleted = true
                coreDataManager.updateHabit(habits[index])
            }
        }
        groupHabits()
    }
    
    func deleteCompletedHabits() {
        let completedHabits = habits.filter { $0.isCompleted }
        
        guard !completedHabits.isEmpty else { return }
        
        for habit in completedHabits {
            coreDataManager.deleteHabit(withId: habit.id)
        }
        
        habits.removeAll { $0.isCompleted }
        groupHabits()
    }
    
    private func groupHabits() {
        let calendar = Calendar.current
        
        groupedHabits = Dictionary(grouping: habits) { habit in
            calendar.startOfDay(for: habit.dateCreated)
        }
        
        sortedDates = groupedHabits.keys.sorted(by: >)
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}
