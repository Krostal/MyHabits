import UIKit

final class HabitsViewController: UIViewController {
    
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
        collectionView.reloadData()
//        collectionView.refreshControl?.endRefreshing()
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
        let width = itemWidth(for: view.frame.width, spacing: 16)
        if indexPath.section == 0 {
            return CGSize(width: width, height: 60)
        } else {
            return CGSize(width: width, height: 130)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 0, bottom: 18, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
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
                self?.navigationController?.pushViewController(habitDetailsVC, animated: true)
            }
            return cell
        }
    }

}

