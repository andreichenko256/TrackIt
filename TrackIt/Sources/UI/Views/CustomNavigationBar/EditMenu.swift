import UIKit
import SnapKit

final class EditMenu: UIView {
    private lazy var ellipsis = {
        $0.image = UIImage(systemName: "ellipsis")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
        return $0
    }(UIImageView())
    
    private lazy var circleContainer = {
        $0.backgroundColor = Colors.primary
        $0.layer.cornerRadius = 20
        $0.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EditMenu {
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(circleContainer)
        circleContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleContainer.addSubview(ellipsis)
        ellipsis.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let button = UIButton(type: .system)
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(title: "", children: [
            UIAction(title: "Complete all", image: UIImage(systemName: "checkmark.circle")) { _ in
                print("Complete all tapped")
            },
            UIAction(title: "Delete completed", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("Delete tapped")
            }
        ])
        
        addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
