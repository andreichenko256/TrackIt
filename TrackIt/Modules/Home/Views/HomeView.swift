import UIKit
import SnapKit

final class HomeView: UIView {
    let addHabbitButton = PrimaryButton(title: "Add Habbit")
    let habbitsTableView = HabitsTableView()
    let customNavigationBar = CustomNavigationBar()
    
    private lazy var gradientLayer = {
        $0.colors = Colors.Gradients.primaryBg
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        return $0
    }(CAGradientLayer())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

private extension HomeView {
    func setupUI() {
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupConstraints() {
        [customNavigationBar, habbitsTableView, addHabbitButton].forEach {
            addSubview($0)
        }
        
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(safeTop).inset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        habbitsTableView.snp.makeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(addHabbitButton.snp.top).offset(-16)
        }
        
        addHabbitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeBottom).inset(24)
        }
    }
}
