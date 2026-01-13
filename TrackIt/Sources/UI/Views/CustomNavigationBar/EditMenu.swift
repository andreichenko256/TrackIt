import UIKit
import SnapKit

final class EditMenu: UIView {
    var onCompleteAll: VoidBlock?
    var onDeleteCompleted: VoidBlock?
    
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
    
    private lazy var menuButton = {
        $0.showsMenuAsPrimaryAction = true
        return $0
    }(UIButton(type: .system))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMenu() {
        menuButton.menu = UIMenu(title: "", children: [
            UIAction(title: "Complete all", image: UIImage(systemName: "checkmark.circle")) { [weak self] _ in
                self?.onCompleteAll?()
            },
            UIAction(title: "Delete completed", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.onDeleteCompleted?()
            }
        ])
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
        
        addSubview(menuButton)
        menuButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
