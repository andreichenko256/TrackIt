import UIKit
import SnapKit

final class HabitCell: UITableViewCell {
    static let reuseIdentifier = "HabitCell"
    
    private lazy var containerView = {
        $0.backgroundColor = .clear
        return $0
    }(UIView())
    
    private lazy var checkImageView: UIImageView = {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.snp.makeConstraints { make in
            make.size.equalTo(14)
        }
        return $0
    }(UIImageView())
    
    private lazy var completeView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.systemGray.cgColor
        $0.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        $0.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return $0
    }(UIView())
    
    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    private lazy var divider = {
        $0.backgroundColor = .systemGray.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 6
        $0.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        updateCompletionState(isCompleted: false)
    }
}

private extension HabitCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        [titleLabel, divider, completeView].forEach {
            containerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualTo(completeView.snp.leading).offset(-8)
        }
        
        completeView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    func updateCompletionState(isCompleted: Bool) {
        completeView.backgroundColor = isCompleted ? Colors.primary : .clear
        completeView.layer.borderColor = isCompleted ? Colors.primary.cgColor : UIColor.systemGray.cgColor
        checkImageView.isHidden = !isCompleted
    }
}

extension HabitCell {
    func configure(with habit: Habit) {
        titleLabel.text = habit.title
        updateCompletionState(isCompleted: habit.isCompleted)
    }
}
