//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 07.07.2023.
//
import UIKit

class HabitViewController: UIViewController {
    
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
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "НАЗВАНИЕ"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        return titleLabel
    }()
    
    private lazy var habitName: UITextField = {
        let habitName = UITextField()
        habitName.translatesAutoresizingMaskIntoConstraints = false
        habitName.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        habitName.textColor = .black
        habitName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        habitName.autocapitalizationType = .none
        
        habitName.autocorrectionType = UITextAutocorrectionType.no
        habitName.keyboardType = UIKeyboardType.default
        habitName.returnKeyType = UIReturnKeyType.done
        habitName.clearButtonMode = UITextField.ViewMode.whileEditing
        habitName.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        habitName.delegate = self
        return habitName
    }()
    
    //    private lazy var habitsName: UITextView = {
    //        let habitsName = UITextView()
    //        habitsName.translatesAutoresizingMaskIntoConstraints = false
    //        habitsName.contentInsetAdjustmentBehavior = .automatic
    //        habitsName.text = "Бегать по утрам, спать 8 часов и т.п."
    //        habitsName.textColor = UIColor(named: "BlueColor")
    //        habitsName.font = .systemFont(ofSize: 17, weight: .semibold)
    //        habitsName.backgroundColor = .systemPink
    //        habitsName.isEditable = true
    //        habitsName.autocapitalizationType = .none
    //        habitsName.clearsContextBeforeDrawing = true
    //        habitsName.delegate = self
    //
    //        habitsName.autocorrectionType = UITextAutocorrectionType.no
    //        habitsName.keyboardType = UIKeyboardType.default
    //        habitsName.returnKeyType = UIReturnKeyType.done
    //
    //        return habitsName
    //    }()
    
    private lazy var colorTitle: UILabel = {
        let colorTitle = UILabel()
        colorTitle.translatesAutoresizingMaskIntoConstraints = false
        colorTitle.text = "ЦВЕТ"
        colorTitle.textColor = .black
        colorTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        
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
    
    //    private lazy var colorPicker: UIView = {
    //        let colorPicker = UIView()
    //        colorPicker.translatesAutoresizingMaskIntoConstraints = false
    //        colorPicker.backgroundColor = UIColor(named: "OrangeColor")
    //        colorPicker.clipsToBounds = true
    //        colorPicker.layer.cornerRadius = 15
    //        return colorPicker
    //    }()
    
    private lazy var timeTitle: UILabel = {
        let timeTitle = UILabel()
        timeTitle.translatesAutoresizingMaskIntoConstraints = false
        timeTitle.text = "ВРЕМЯ"
        timeTitle.textColor = .black
        timeTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        
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
        dayField.font = .systemFont(ofSize: 17, weight: .regular)
        
        return dayField
    }()
    
    private lazy var timeField: UITextField = {
        let timeField = UITextField()
        timeField.translatesAutoresizingMaskIntoConstraints = false
        timeField.placeholder = "set time"
        timeField.textColor = UIColor(named: "PurpleColor")
        timeField.font = .systemFont(ofSize: 17, weight: .regular)
        
        return timeField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
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
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(habitName)
        scrollView.addSubview(colorTitle)
        scrollView.addSubview(colorPicker)
        scrollView.addSubview(timeTitle)
        scrollView.addSubview(dayAndTimeField)
        scrollView.addSubview(datePicker)
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
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func setupContentOfScrollView() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 74),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            habitName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            habitName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            habitName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitName.heightAnchor.constraint(equalToConstant: 22),
            
            colorTitle.topAnchor.constraint(equalTo: habitName.bottomAnchor, constant: 15),
            colorTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorTitle.widthAnchor.constraint(equalToConstant: 36),
            colorTitle.heightAnchor.constraint(equalToConstant: 18),
            
            colorPicker.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 7),
            colorPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorPicker.widthAnchor.constraint(equalToConstant: 30),
            colorPicker.heightAnchor.constraint(equalToConstant: 30),
            
            timeTitle.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 15),
            timeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeTitle.widthAnchor.constraint(equalToConstant: 47),
            timeTitle.heightAnchor.constraint(equalToConstant: 18),
            
            dayAndTimeField.topAnchor.constraint(equalTo: timeTitle.bottomAnchor, constant: 7),
            dayAndTimeField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayAndTimeField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dayAndTimeField.heightAnchor.constraint(equalToConstant: 22),
            
            datePicker.topAnchor.constraint(equalTo: timeField.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
        ])
        
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
    }
    
    private func setupNavigationBar() {
        
        self.title = "Создать"
        
        
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
    
//    private func createNewHabit() {
//
//    }
    
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
    
    @objc func save(_ sender: UIBarButtonItem) {
        // cоздаем привычку, сохраняем ее в HabitStore и закрываем окно
        let newHabit = Habit(name: "\(String(describing: habitName.text))",
                             date: datePicker.date,
                             color: (colorPicker.backgroundColor ?? .systemRed)
                             )
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        
        dismiss(animated: true)
    }
    
    @objc func cancelAndBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func colorPickerPressed(_ sender: UIButton) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.colorPicker.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
}


extension HabitViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//extension HabitViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        let size = CGSize(width: habitsName.frame.size.width, height: .infinity)
//        let estimatedSize = habitsName.sizeThatFits(size)
//
//        guard habitsName.contentSize.height < 100.0 else { habitsName.isScrollEnabled = true; return }
//
//        habitsName.isScrollEnabled = false
//        habitsName.constraints.forEach { (constraint) in
//            if constraint.firstAttribute == .height {
//                constraint.constant = estimatedSize.height
//            }
//        }
//    }
//
//}
            
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorPicker.backgroundColor = viewController.selectedColor
    }
 
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.colorPicker.backgroundColor = viewController.selectedColor
    }
    
}

