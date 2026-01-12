import UIKit
import SnapKit

final class HabitsTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HabitsTableView {
    func setupUI() {
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        layer.cornerRadius = 16
        separatorStyle = .none
        allowsSelection = true
        allowsMultipleSelection = true
    }
    
    func registerCells() {
        register(HabitCell.self, forCellReuseIdentifier: HabitCell.reuseIdentifier)
    }
}
