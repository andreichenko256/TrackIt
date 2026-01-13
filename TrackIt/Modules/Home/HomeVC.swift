import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var homeView: HomeView {
        return view as! HomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
        bindViewModel()
        viewModel.loadHabits()
    }
    
    override func loadView() {
        view = HomeView()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.reuseIdentifier, for: indexPath) as! HabitCell
        
        if let habit = viewModel.habit(at: indexPath) {
            cell.configure(with: habit)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HabitsTableHeaderView()
        let title = viewModel.headerTitle(for: section)
        headerView.configure(with: title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.toggleHabit(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            let shouldDeleteSection = self.viewModel.deleteHabit(at: indexPath)
            
            UIView.performWithoutAnimation {
                if shouldDeleteSection {
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .none)
                }
            }
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.editHabit(at: indexPath)
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

private extension HomeViewController {
    func setupTableView() {
        homeView.habbitsTableView.delegate = self
        homeView.habbitsTableView.dataSource = self
    }
    
    func bindViewModel() {
        viewModel.$groupedHabits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UIView.performWithoutAnimation {
                    self?.homeView.habbitsTableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.numberOfHabitsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.homeView.noHabbitsLabel.isHidden = isEmpty
            }
            .store(in: &cancellables)
    }
    
    func setupActions() {
        homeView.addHabbitButton.onTap = { [weak self] in
            self?.showAddHabitDialog()
        }
        
        homeView.customNavigationBar.editMenu.onCompleteAll = { [weak self] in
            self?.completeAllHabits()
        }
        
        homeView.customNavigationBar.editMenu.onDeleteCompleted = { [weak self] in
            self?.deleteCompletedHabits()
        }
    }
    
    func showAddHabitDialog() {
        let alert = UIAlertController(title: "New Habit", message: "Enter habit name", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Habit name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            guard let title = alert?.textFields?.first?.text, !title.isEmpty else { return }
            self?.viewModel.addHabit(title: title)
        })
        
        present(alert, animated: true)
    }
    
    func editHabit(at indexPath: IndexPath) {
        guard let habit = viewModel.habit(at: indexPath) else { return }
        
        let alert = UIAlertController(title: "Edit Habit", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = habit.title
            textField.placeholder = "Habit name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let newTitle = alert?.textFields?.first?.text, !newTitle.isEmpty else { return }
            self?.viewModel.updateHabit(at: indexPath, newTitle: newTitle)
        })
        
        present(alert, animated: true)
    }
    
    func completeAllHabits() {
        viewModel.completeAllHabits()
    }
    
    func deleteCompletedHabits() {
        let alert = UIAlertController(
            title: "Delete Completed",
            message: "Are you sure you want to delete all completed habits?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteCompletedHabits()
        })
        
        present(alert, animated: true)
    }
}
