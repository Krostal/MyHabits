import UIKit

final class HabitViewController: UIViewController {
    
    private enum Constants {
        static let titleHeight: CGFloat = 18.0
        static let contentHeight: CGFloat = 22.0
        static let horizontalPadding: CGFloat = 16.0
        static let colorPickerheight: CGFloat = 30
        static let titleTopSpacing: CGFloat = 15.0
        static let contentTopSpacing: CGFloat = 7.0
        static let titleTextSize: CGFloat = 13.0
        static let contentTextSize: CGFloat = 17.0
    }
    
    let store = HabitsStore.shared
    var currentHabit: Habit?
    
    var changeTitleClosure: (() -> Void)?
    
    var addNewHabit: ((Habit) -> Void)?
    
    var updateHabit: ((Habit) -> Void)?
    
    var deleteHabit: ((Habit) -> Void)?
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Удалить привычку", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: Constants.contentTextSize, weight: .regular)
        deleteButton.addTarget(self, action: #selector(deleteThisHabit(_:)), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "НАЗВАНИЕ"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: Constants.titleTextSize, weight: .semibold)
        
        return titleLabel
    }()
    
    private lazy var habitName: UITextField = {
        let habitName = UITextField()
        habitName.translatesAutoresizingMaskIntoConstraints = false
        habitName.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        habitName.textColor = .black
        habitName.font = UIFont.systemFont(ofSize: Constants.contentTextSize, weight: .regular)
        habitName.autocapitalizationType = .none
        habitName.autocorrectionType = UITextAutocorrectionType.no
        habitName.keyboardType = UIKeyboardType.default
        habitName.returnKeyType = UIReturnKeyType.done
        habitName.clearButtonMode = UITextField.ViewMode.whileEditing
        habitName.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        habitName.delegate = self
        return habitName
    }()
    
    private lazy var colorTitle: UILabel = {
        let colorTitle = UILabel()
        colorTitle.translatesAutoresizingMaskIntoConstraints = false
        colorTitle.text = "ЦВЕТ"
        colorTitle.textColor = .black
        colorTitle.font = .systemFont(ofSize: Constants.titleTextSize, weight: .semibold)
        
        return colorTitle
    }()
    
    private lazy var colorPicker: UIButton = {
        let colorPicker = UIButton()
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.backgroundColor = UIColor(named: "OrangeColor")
        colorPicker.clipsToBounds = true
        colorPicker.layer.cornerRadius = 15
        colorPicker.addTarget(self, action: #selector(colorPickerPressed(_:)), for: .touchUpInside)
        
        return colorPicker
    }()
    
    private lazy var timeTitle: UILabel = {
        let timeTitle = UILabel()
        timeTitle.translatesAutoresizingMaskIntoConstraints = false
        timeTitle.text = "ВРЕМЯ"
        timeTitle.textColor = .black
        timeTitle.font = .systemFont(ofSize: Constants.titleTextSize, weight: .semibold)
        
        return timeTitle
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.tintColor = UIColor(named: "PurpleColor")
        datePicker.addTarget(self, action: #selector(setTime), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var dayAndTimeField: UIStackView = {
        let dayAndTimeField = UIStackView()
        dayAndTimeField.translatesAutoresizingMaskIntoConstraints = false
        dayAndTimeField.spacing = 0
        dayAndTimeField.axis = .horizontal
        dayAndTimeField.addArrangedSubview(dayField)
        dayAndTimeField.addArrangedSubview(timeField)
        return dayAndTimeField
    }()
    
    private lazy var dayField: UILabel = {
        let dayField = UILabel()
        dayField.translatesAutoresizingMaskIntoConstraints = false
        dayField.text = "Каждый день в "
        dayField.textColor = .black
        dayField.font = .systemFont(ofSize: Constants.contentTextSize, weight: .regular)
        
        return dayField
    }()
    
    private lazy var timeField: UITextField = {
        let timeField = UITextField()
        timeField.translatesAutoresizingMaskIntoConstraints = false
        timeField.placeholder = "укажи время"
        timeField.textColor = UIColor(named: "PurpleColor")
        timeField.font = .systemFont(ofSize: Constants.contentTextSize, weight: .regular)
        
        return timeField
    }()
    
    var timer: Timer?
    
    init(currentHabit: Habit? = nil) {
        self.currentHabit = currentHabit
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.currentHabit = Habit(name: "", date: Date(), color: .white)
        super.init(coder: coder)
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupView()
        setupConstraints()
        setupContentOfScrollView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(habitName)
        contentView.addSubview(colorTitle)
        contentView.addSubview(colorPicker)
        contentView.addSubview(timeTitle)
        contentView.addSubview(dayAndTimeField)
        contentView.addSubview(datePicker)
        contentView.addSubview(deleteButton)
    }
    
    private func setupView() {
        if let currentHabit = self.currentHabit {
            self.title = "Править"
            habitName.text = currentHabit.name
            colorPicker.backgroundColor = currentHabit.color
            datePicker.date = currentHabit.date
            deleteButton.isEnabled = true
        } else {
            self.title = "Создать"
            deleteButton.isHidden = true
        }
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupContentOfScrollView() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.widthAnchor.constraint(equalToConstant: 74),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            
            habitName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentTopSpacing),
            habitName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            habitName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            habitName.heightAnchor.constraint(equalToConstant: Constants.contentHeight),
            
            colorTitle.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: Constants.titleTopSpacing),
            colorTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            colorTitle.widthAnchor.constraint(equalToConstant: 36),
            colorTitle.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            
            colorPicker.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: Constants.contentTopSpacing),
            colorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            colorPicker.widthAnchor.constraint(equalToConstant: Constants.colorPickerheight),
            colorPicker.heightAnchor.constraint(equalToConstant: Constants.colorPickerheight),
            
            timeTitle.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: Constants.titleTopSpacing),
            timeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            timeTitle.widthAnchor.constraint(equalToConstant: 47),
            timeTitle.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            
            dayAndTimeField.topAnchor.constraint(equalTo: timeTitle.bottomAnchor, constant: Constants.contentTopSpacing),
            dayAndTimeField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            dayAndTimeField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dayAndTimeField.heightAnchor.constraint(equalToConstant: Constants.contentHeight),
            
            datePicker.topAnchor.constraint(equalTo: timeField.bottomAnchor, constant: Constants.titleTopSpacing),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            datePicker.heightAnchor.constraint(equalToConstant: 216),
            
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.contentHeight),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
        
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    private func setupNavigationBar() {
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "PurpleColor")
        
        let rightBarButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(save(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancelAndBack(_:)))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Удалить привычку",
            message: "Вы хотите удалить привычку \"\(currentHabit?.name ?? "Имя привычки не определено")\"?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] action in
            if let deletedHabit = self?.currentHabit {
                self?.deleteHabit?(deletedHabit)
                if let habitsVC = self?.presentingViewController as? UITabBarController {
                    if let navigationVC = habitsVC.viewControllers?.first as? UINavigationController {
                        navigationVC.popToRootViewController(animated: true)
                    }
                }
            }
            self?.dismiss(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func infoAlert() {
        let alert = UIAlertController(title: "Введите имя привычки", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(dismissInfoAlert), userInfo: ["alert": alert], repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }
    
    @objc func dismissInfoAlert(timer: Timer) {
        guard
            let userInfo = timer.userInfo as? [String: Any],
            let alert = userInfo["alert"] as? UIAlertController
        else { return }
        alert.dismiss(animated: true)
    }
    
    @objc func setTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        timeField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
        
    }
    
    @objc private func save(_ sender: UIBarButtonItem) {
        
        let newHabit = Habit(name: habitName.text ?? "Error!",
                             date: datePicker.date,
                             color: (colorPicker.backgroundColor ?? .systemRed)
        )
        
        if deleteButton.isHidden {
            if newHabit.name.isEmpty {
                infoAlert()
            } else {
                addNewHabit?(newHabit)
                dismiss(animated: true)
            }
            
        } else {
            if let updatedHabit = self.currentHabit {
                if updatedHabit.name.isEmpty {
                    infoAlert()
                } else {
                    updatedHabit.name = newHabit.name
                    updatedHabit.color = newHabit.color
                    updatedHabit.date = newHabit.date
                    updateHabit?(updatedHabit)
                    dismiss(animated: true, completion: changeTitleClosure)
                }
            }
        }
    }
    
    @objc private func cancelAndBack(_ sender: UIBarButtonItem) {
            dismiss(animated: true)
    }
    
    @objc private func colorPickerPressed(_ sender: UIButton) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.colorPicker.backgroundColor ?? .white
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc private func deleteThisHabit(_ sender: UIButton) {
        showAlert()
    }
    
}


extension HabitViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
            
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorPicker.backgroundColor = viewController.selectedColor
    }
 
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.colorPicker.backgroundColor = viewController.selectedColor
    }
    
}

