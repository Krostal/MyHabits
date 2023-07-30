import Foundation
import UIKit

final class ProgressCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let verticalSpacing: CGFloat = 10.0
        static let horizontalSpacing: CGFloat = 12.0
        static let textSize: CGFloat = 13.0
    }
    
    var habit: Habit?
    
    private lazy var motivationLabel: UILabel = {
        let motivationLabel = UILabel()
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        motivationLabel.font = .systemFont(ofSize: Constants.textSize, weight: .semibold)
        motivationLabel.textColor = .systemGray
        return motivationLabel
    }()
    
    private lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = .systemFont(ofSize: Constants.textSize, weight: .semibold)
        progressLabel.textColor = .systemGray
        return progressLabel
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.layer.cornerRadius = 5
        progressBar.trackTintColor = UIColor(named: "ProgressBackgrounColor")
        progressBar.progressTintColor = UIColor(named: "PurpleColor")
        return progressBar
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
    }
    
    private func setupSubviews() {
        contentView.addSubview(motivationLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(progressBar)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            motivationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            motivationLabel.widthAnchor.constraint(equalToConstant: 216),
            motivationLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressLabel.centerYAnchor.constraint(equalTo: motivationLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            progressLabel.heightAnchor.constraint(equalToConstant: 18),
            
            progressBar.topAnchor.constraint(lessThanOrEqualTo: motivationLabel.bottomAnchor, constant: Constants.verticalSpacing),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            progressBar.heightAnchor.constraint(equalToConstant: 7),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
        ])
    }
    
    func updateProgress() {
        progressLabel.text = String(format: "%.2f", HabitsStore.shared.todayProgress*100) + "%"
        progressBar.progress = HabitsStore.shared.todayProgress
        if progressBar.progress == 1 {
            motivationLabel.text = "Ты молодец! Так держать!"
        } else {
            motivationLabel.text = "У тебя получится!"
        }
    }

}
