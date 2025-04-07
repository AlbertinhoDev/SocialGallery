import UIKit

protocol MainDisplayLogic: AnyObject {
    func update(sections: [Section], persons: [TableCellModel])
    func showLoading(_ show: Bool)
}

