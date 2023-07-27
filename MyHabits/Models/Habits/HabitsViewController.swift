import UIKit

final class HabitsViewController: UIViewController {
    
    private enum Constants {
        static let verticalSectionSpacing: CGFloat = 12.0
        static let horizontalSpacing: CGFloat = 16.0
        static let progresssSectionHeihgt: CGFloat = 60.0
        static let habitSectionHeihgt: CGFloat = 130.0
    }
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
    
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupLayouts()
        setupNavigationBar()
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(named: "LightGrayColor")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupLayouts() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
        
        self.navigationItem.title = "Cегодня"
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "PurpleColor")
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewHabit(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func addNewHabit(_ sender: UIBarButtonItem) {
        let habitViewController = HabitViewController.init()
        
        habitViewController.addNewHabit = { [weak self] newHabit in
            
            HabitsStore.shared.habits.append(newHabit)
            HabitsStore.shared.save()
            let newIndexPath = IndexPath(item: HabitsStore.shared.habits.count - 1, section: 1)
            self?.collectionView.insertItems(at: [newIndexPath])
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        let navigationVC = UINavigationController(rootViewController: habitViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        
        let itemsInRow: CGFloat = 1
        let totalSpacing: CGFloat = 2 * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width, spacing: Constants.horizontalSpacing)
        if indexPath.section == 0 {
            return CGSize(width: width, height: Constants.progresssSectionHeihgt)
        } else {
            return CGSize(width: width, height: Constants.habitSectionHeihgt)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: Constants.verticalSectionSpacing + 10, left: 0, bottom: Constants.verticalSectionSpacing + 6, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: Constants.verticalSectionSpacing, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.verticalSectionSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.verticalSectionSpacing
    }
    
}

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return HabitsStore.shared.habits.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section == 0 {
            guard let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else {
                return UICollectionViewCell()
            }
            progressCell.updateProgress()
            return progressCell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as? HabitCollectionViewCell else {
                return UICollectionViewCell()
            }
            let habits = HabitsStore.shared.habits[indexPath.row]
            cell.setup(with: habits)
            cell.onLabelTapped = { [weak self] in
                let habitDetailsVC = HabitDetailsViewController(habit: habits)
                
                habitDetailsVC.updateHabit = { [weak self] habit in
                    
                    if let index = HabitsStore.shared.habits.firstIndex(where: { $0 == habit }) {
                        HabitsStore.shared.habits[index] = habit
                        HabitsStore.shared.save()
                        
                        let indexPath = IndexPath(item: index, section: 1)
                        self?.collectionView.reloadItems(at: [indexPath])
                    }
                }
                
                habitDetailsVC.deleteHabit = { [weak self] habit in
                    
                    if let index = HabitsStore.shared.habits.firstIndex(where: { $0 == habit }) {
                        HabitsStore.shared.habits.remove(at: index)
                        HabitsStore.shared.save()
                        
                        let indexPath = IndexPath(item: index, section: 1)
                        self?.collectionView.deleteItems(at: [indexPath])
                        self?.collectionView.reloadSections(IndexSet(integer: 0))
                    }
                }
                
                self?.navigationController?.pushViewController(habitDetailsVC, animated: true)
            }
            
            cell.delegate = self
            return cell
        }
    }

}

extension HabitsViewController: HabitCellDelegate {
    func updateProgressCell() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

