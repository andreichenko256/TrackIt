import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HabitDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error saving context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllHabits() -> [Habit] {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toHabit() }
        } catch {
            print("Error fetching habits: \(error)")
            return []
        }
    }
    
    func createHabit(title: String, isCompleted: Bool = false, dateCreated: Date = Date()) -> Habit {
        let entity = HabitEntity(context: context)
        let habit = Habit(title: title, isCompleted: isCompleted, dateCreated: dateCreated)
        entity.update(from: habit)
        saveContext()
        return habit
    }
    
    func updateHabit(_ habit: Habit) {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", habit.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.update(from: habit)
                saveContext()
            }
        } catch {
            print("Error updating habit: \(error)")
        }
    }
    
    func deleteHabit(withId id: UUID) {
        let request: NSFetchRequest<HabitEntity> = HabitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("Error deleting habit: \(error)")
        }
    }
    
    func deleteAllHabits() {
        let request: NSFetchRequest<NSFetchRequestResult> = HabitEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting all habits: \(error)")
        }
    }
}
