import UIKit

final class MainPresenter {
    weak var viewController: MainDisplayLogic?
    private let mainApiService: MainApiServicable
    private let coreDataManager: CoreDataManagerable
    private let networkMonitor: NetworkMonitorable
    private var persons: [TableCellModel] = []

    private var currentPage = 0
    
    init(
        mainApiService: MainApiServicable,
        coreDataManager: CoreDataManagerable,
        networkMonitor: NetworkMonitorable
    ) {
        self.mainApiService = mainApiService
        self.coreDataManager = coreDataManager
        self.networkMonitor = networkMonitor
    }
}

extension MainPresenter: MainPresenterLogic {
    func fetchData(loadIsNeeded: Bool) {
        if currentPage <= 10 {
            if loadIsNeeded {
                downloadData(loadIsNeeded: loadIsNeeded)
                self.currentPage += 1
            } else {
                self.currentPage = 1
                downloadData(loadIsNeeded: loadIsNeeded)
            }
        }
    }
    
    private func downloadData(loadIsNeeded: Bool) {
        DispatchQueue.main.async {
            self.viewController?.showLoading(true)
        }
        Task {
            do {
                let response = try await mainApiService.loadData(urlString: "https://jsonplaceholder.typicode.com/users/\(currentPage)/posts")
                var personsWithImages = [TableCellModel]()
                let dispatchGroup = DispatchGroup()
                for person in response {
                    dispatchGroup.enter()
                        let image = await downloadImage(id: person.id)
                        personsWithImages.append(TableCellModel(
                            image: image,
                            title: person.title,
                            body: person.body,
                            like: false,
                            id: person.id
                        ))
                        dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) {
                    if loadIsNeeded {
                        self.persons.append(contentsOf: personsWithImages)
                    } else {
                        self.persons = personsWithImages
                    }
                    self.saveCoreData(persons: self.persons)
                    self.buildingTableView()
                    self.viewController?.showLoading(false)
//                    self.coreDataManager.deleteAllData()
//                    let t = self.coreDataManager.fetchData()
//                    t.forEach { item in
//                        print(item.like)
//                    }
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                    self.viewController?.showLoading(false)
                }
            }
        }
    }
    
    private func downloadImage(id: Int) async -> UIImage {
        do {
            let imageResponse = try await mainApiService.loadImage(urlString: "https://picsum.photos/id/\(id)/200/300")
            return imageResponse ?? UIImage(named: "NilImage")!
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            print("id: \(id)")
            return UIImage(named: "NilImage")!
        }
    }
    
    private func buildingTableView() {
        createTableView(persons: persons)
    }
    
    private func createTableView(persons: [TableCellModel]) {
        let sections: [Section]  = [
            .init(type: .persons, rows: Array(repeating: .person, count: persons.count))
        ]
        viewController?.update(sections: sections, persons: persons)
    }
    
    private func saveCoreData(persons: [TableCellModel]) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            do {
                persons.forEach { item in
                    self.coreDataManager.createData(image: item.image, title: item.title, body: item.body, like: item.like, id: Int16(item.id))
                }
            }
        }
    }
    
    func updateLike(id: Int) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            do {
                coreDataManager.updateLikeStatus(id: Int16(id))
                DispatchQueue.main.async {
                    let newLikeStatus = self.persons.map {
                        if $0.id == id {
                            var updateLike = $0
                            updateLike.like = !$0.like
                            return updateLike
                        }
                        return $0
                    }
                    self.persons = newLikeStatus
                    self.createTableView(persons: self.persons)
                }
            }
        }
    }
}
