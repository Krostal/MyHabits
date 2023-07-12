//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Konstantin Tarasov on 07.07.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    fileprivate let infoDataSource = Info.show()
    
    static let infoTableView: UITableView = {
        let infoView = UITableView()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = .white
        infoView.register(InfoViewCell.self, forCellReuseIdentifier: InfoViewCell.id)
        return infoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupNavigationBar()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = UIColor(named: "LightGrayColor")
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.title = "Информация"
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "LightGrayColor")
    }
    
    private func setupTableView() {
        view.addSubview(Self.infoTableView)
        Self.infoTableView.delegate = self
        Self.infoTableView.dataSource = self
        Self.infoTableView.rowHeight = UITableView.automaticDimension
        Self.infoTableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            Self.infoTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            Self.infoTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            Self.infoTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            Self.infoTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
        ])
    }
    
    @objc func reloadTableView() {
        Self.infoTableView.reloadData()
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoViewCell.id, for: indexPath) as? InfoViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(infoDataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = HeaderForSection()
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        
        if section == 0 {
            return sectionHeader
        } else {
            return nil
        }
    }
    

}
