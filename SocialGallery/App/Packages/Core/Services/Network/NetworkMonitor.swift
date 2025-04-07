import Network

protocol NetworkMonitorable {
    func startMonitoring()
    func stopMonitoring()
    var isReachable: Bool { get }
}

class NetworkMonitor {
    private let monitor: NWPathMonitor
    private var status: NWPath.Status = .requiresConnection
    private let queue: DispatchQueue
    var isReachable: Bool { status == .satisfied }
    
    init(queue: DispatchQueue = DispatchQueue(label: "NetworkMonitor")) {
        monitor = NWPathMonitor()
        self.queue = queue
    }
}

extension NetworkMonitor: NetworkMonitorable {
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
