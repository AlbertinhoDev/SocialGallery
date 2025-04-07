import UIKit

final class MainViewController: UIViewController {
    var presenter: MainPresenterLogic?
    private let refreshControl = UIRefreshControl()
    private let personsTableView = UITableView()
    private var sections: [Section] = []
    var persons: [TableCellModel] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .lightGray
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.fetchData(loadIsNeeded: true)
        setupViewController()
        setupRefreshControl()
    }
    
    private func setupViewController() {
        view.addSubview(personsTableView)
        personsTableView.separatorStyle = .none
        personsTableView.translatesAutoresizingMaskIntoConstraints = false
        personsTableView.backgroundColor = .clear
        personsTableView.showsVerticalScrollIndicator = false
        personsTableView.dataSource = self
        personsTableView.delegate = self
        personsTableView.register(MainTableViewCell.self)
        NSLayoutConstraint.activate([
            personsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            personsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            personsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .lightGray
        personsTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        presenter?.fetchData(loadIsNeeded: false)
    }
}

extension MainViewController: MainDisplayLogic {
    func update(sections: [Section], persons: [TableCellModel]) {
        refreshControl.endRefreshing()
        self.sections = sections
        self.persons = persons
        self.personsTableView.reloadData()
    }
    
    func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let rowType = sections[section].rows[row]
        
        switch rowType {
        case .person:
            let cell = tableView.dequeueReusableCell(MainTableViewCell.self, indexPath: indexPath)
            let person = persons[indexPath.row]
            cell.configureCell(with: person)
            cell.onLikeButtonTapped = { [weak self] person in
                let id = person.id
                self!.presenter?.updateLike(id: id)
                self!.personsTableView.reloadData()
            }
            return cell
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
        if indexPath.section == lastSection && indexPath.row == lastRow {
            presenter?.fetchData(loadIsNeeded: true)
        }
    }
}
