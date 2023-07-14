import UIKit

class InfoViewCell: UITableViewCell {
    
    static let id = "InfoViewCell"
    
    private lazy var textInfo: UILabel = {
        let textInfo = UILabel()
        textInfo.translatesAutoresizingMaskIntoConstraints = false
        textInfo.font = .systemFont(ofSize: 17, weight: .regular)
        textInfo.tintColor = .black
        textInfo.numberOfLines = 0
        return textInfo
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        addSubview(textInfo)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([

            textInfo.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func configure(_ info: Info) {
        textInfo.text = info.text
    }
    
}

