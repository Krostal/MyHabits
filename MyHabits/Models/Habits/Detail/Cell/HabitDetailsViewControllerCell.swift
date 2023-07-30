import UIKit

final class HabitDetailsViewControllerCell: UITableViewCell {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16.0
        static let verticalSpacing: CGFloat = 11.0
    }
    
    static let id = "HabitDetailsViewControllerCell"
    
    private lazy var calendar: Calendar = Calendar.current
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 17, weight: .regular)
        dateLabel.tintColor = .black
        return dateLabel
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalSpacing),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalSpacing)
        ])
    }
    
    func configure(_ date: Date) {
        
        if Calendar.current.isDateInToday(date) {
            dateLabel.text = "Сегодня"
        } else if Calendar.current.isDateInYesterday(date) {
            dateLabel.text = "Вчера"
        } else if Calendar.current.isDateInDayBeforeYesterday(date) {
            dateLabel.text = "Позавчера"
        } else {
            dateLabel.text = dateFormatter.string(from: date)
        }
        
    }
}

private extension Date {
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: Calendar.current.startOfDay(for: self)) ?? self
    }
}

private extension Calendar {
    func isDateInDayBeforeYesterday(_ date: Date) -> Bool {
        return isDate(date, equalTo: date.dayBeforeYesterday, toGranularity: .day)
    }
}
