import UIKit

protocol CoreDataManagerable {
    func fetchData() -> [InfoData] //Load from CoreData
    func deleteAllData() //Clear CoreData
    func updateLikeStatus(id: Int16) //Change status Like under person
    func createData(image: UIImage, title: String, body: String, like: Bool, id: Int16) //Load to CoreData a new person
}
