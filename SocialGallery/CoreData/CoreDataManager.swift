import CoreData
import UIKit

final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    override init() {}
    private let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
}

extension CoreDataManager: CoreDataManagerable {
    public func fetchData() -> [InfoData] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InfoData")
        do {
            return try context.fetch(fetchRequest) as! [InfoData]
        } catch {
            print("Ничего не найдено")
            return []
        }
    }
    
    public func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InfoData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Ошибка при удалении: \(error.localizedDescription)")
        }
        PersistenceController.shared.saveContext()
    }
    
    public func updateLikeStatus(id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InfoData")
        do {
            guard let data = try? context.fetch(fetchRequest) as? [InfoData],
            let like = data.first(where: { $0.id == id }) else {
                print("Что-то придумать")
                return
            }
            like.like = !like.like
        }
        PersistenceController.shared.saveContext()
    }
    
    public func createData(image: UIImage, title: String, body: String, like: Bool, id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InfoData")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if !existingItems.isEmpty {
                    return
                }
                let newData = InfoData(context: context)
                newData.id = id
                newData.title = title
                newData.body = body
                newData.like = like
                newData.image = pictureToData(image: image)
                PersistenceController.shared.saveContext()
            } catch {
                print("Ошибка при сохранении: \(error.localizedDescription)")
            }
    }
        
    private func pictureToData(image: UIImage) -> Data {
        if let imageData = image.jpegData(compressionQuality: 1) {
            return imageData
        } else {
            return Data()
        }
    }
}
