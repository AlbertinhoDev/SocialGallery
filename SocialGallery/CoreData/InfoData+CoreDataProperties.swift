import CoreData
import Foundation

@objc(InfoData)
public class InfoData: NSManagedObject {}

extension InfoData {
    
    @NSManaged public var body: String?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var like: Bool
    @NSManaged public var id: Int16
}

extension InfoData : Identifiable {}
