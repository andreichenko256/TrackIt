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
    private func setupTableView() {
        homeView.habbitsTableView.delegate = self
        homeView.habbitsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.sortedDates[section]
        return viewModel.groupedHabits[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.reuseIdentifier, for: indexPath) as! HabitCell
        
        let date = viewModel.sortedDates[indexPath.section]
        if let habit = viewModel.groupedHabits[date]?[indexPath.row] {
            cell.configure(with: habit)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HabitsTableHeaderView()
        let date = viewModel.sortedDates[section]
        let formatDate = formatDate(date)
        headerView.configure(with: formatDate)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleHabit(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.toggleHabit(at: indexPath)
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

private extension HomeViewController {
    func bindViewModel() {
        viewModel.$groupedHabits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeView.habbitsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

private extension HomeViewController {
    func setupActions() {
        addHabbitButtonTapped()
    }
    
    func addHabbitButtonTapped() {
        homeView.addHabbitButton.onTap = { [weak self] in
            print("add Habbit tapped")
        }
    }
}


