//
//  FFLanguage.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public enum FFLanguage: String, CaseIterable, Identifiable, Codable {
    case english = "english"
    case indonesian = "indonesian"
    case vietnamese = "vietnamese"
    case portuguese = "portuguese"
    case moroccan = "moroccan"
    case arabic = "arabic"
    case taiwanese = "taiwanese"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .english:
            return "English"
        case .indonesian:
            return "Bahasa Indonesia"
        case .vietnamese:
            return "Tiếng Việt"
        case .portuguese:
            return "Português (Brasil)"
        case .moroccan:
            return "Darija (المغرب)"
        case .arabic:
            return "العربية"
        case .taiwanese:
            return "繁體中文 (台灣)"
        }
    }
    
    public var isRTL: Bool {
        return self == .arabic || self == .moroccan
    }
}
