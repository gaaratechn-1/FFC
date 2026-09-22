//
//  AppLog.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation
import Combine

public final class AppLog: ObservableObject {
    public static let shared = AppLog()
    
    public struct Entry: Identifiable {
        public let id = UUID()
        public let timestamp: Date
        public let message: String
        public let level: Level
        
        public enum Level: String {
            case info = "INFO"
            case warning = "WARN"
            case error = "ERR"
            case success = "OK"
        }
    }
    
    @Published public private(set) var entries: [Entry] = []
    
    private init() {}
    
    public func log(_ message: String, level: Entry.Level = .info) {
        let entry = Entry(timestamp: Date(), message: message, level: level)
        DispatchQueue.main.async {
            self.entries.append(entry)
            if self.entries.count > 200 {
                self.entries.removeFirst()
            }
        }
        print("[\(level.rawValue)] \(message)")
    }
    
    public func info(_ message: String) { log(message, level: .info) }
    public func warning(_ message: String) { log(message, level: .warning) }
    public func error(_ message: String) { log(message, level: .error) }
    public func success(_ message: String) { log(message, level: .success) }
    
    public func clear() {
        DispatchQueue.main.async {
            self.entries.removeAll()
        }
    }
}
