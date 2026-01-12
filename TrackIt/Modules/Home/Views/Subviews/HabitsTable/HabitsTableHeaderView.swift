import UIKit
import SnapKit

final class HabitsTableHeaderView: UIView {
    
    private lazy var titleLabel = {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = Colors.primary
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var divider = {
        $0.backgroundColor = Colors.primary.withAlphaComponent(0.3)
        $0.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HabitsTableHeaderView {
    func setupUI() {
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        [titleLabel, divider].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
    }
}

extension HabitsTableHeaderView {
    func configure(with title: String) {
        titleLabel.text = title
    }
}
