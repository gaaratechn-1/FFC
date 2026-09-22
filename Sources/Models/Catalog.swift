//
//  Catalog.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import Foundation

public struct SliderPolicy: Codable, Hashable {
    public let min: Double
    public let max: Double
    public let step: Double
    public let initial: Double
    
    public init(min: Double, max: Double, step: Double, initial: Double) {
        self.min = min
        self.max = max
        self.step = step
        self.initial = initial
    }
}

public struct FeatureSection: Codable, Identifiable, Hashable {
    public let id: String
    public let title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}

public struct FeatureOption: Codable, Identifiable, Hashable {
    public let id: String
    public let section: String
    public let title: String
    public let subtitle: String?
    public let symbol: String?
    public let radius: Bool?
    public let h0: Bool?
    public let a0: Bool?
    public let exclusiveGroup: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case section
        case title
        case subtitle
        case symbol
        case radius
        case h0
        case a0
        case exclusiveGroup = "exclusive_group"
    }
    
    public init(id: String, section: String, title: String, subtitle: String? = nil, symbol: String? = nil, radius: Bool? = nil, h0: Bool? = nil, a0: Bool? = nil, exclusiveGroup: String? = nil) {
        self.id = id
        self.section = section
        self.title = title
        self.subtitle = subtitle
        self.symbol = symbol
        self.radius = radius
        self.h0 = h0
        self.a0 = a0
        self.exclusiveGroup = exclusiveGroup
    }
}

public struct Catalog: Codable, Hashable {
    public let version: Int
    public let sections: [FeatureSection]
    public let options: [FeatureOption]
    public let radius: SliderPolicy
    public let h0: SliderPolicy // Headshot rate slider policy
    
    public init(version: Int, sections: [FeatureSection], options: [FeatureOption], radius: SliderPolicy, h0: SliderPolicy) {
        self.version = version
        self.sections = sections
        self.options = options
        self.radius = radius
        self.h0 = h0
    }
    
    public static var `default`: Catalog {
        return Catalog(
            version: 4,
            sections: [
                FeatureSection(id: "combat", title: "Combat & Aim"),
                FeatureSection(id: "visual", title: "Visual & ESP"),
                FeatureSection(id: "memory", title: "Memory & Bypass")
            ],
            options: [
                FeatureOption(
                    id: "aimbot_smooth",
                    section: "combat",
                    title: "Aimbot Smooth",
                    subtitle: "Auto-aligns crosshair smoothly to active target",
                    symbol: "scope",
                    radius: true,
                    h0: true,
                    a0: true,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "auto_headshot",
                    section: "combat",
                    title: "Auto Headshot 100%",
                    subtitle: "Forces hit-box calculations directly to head node",
                    symbol: "target",
                    radius: false,
                    h0: true,
                    a0: false,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "magic_bullet",
                    section: "combat",
                    title: "Magic Bullet",
                    subtitle: "Expands bullet raycast detection envelope",
                    symbol: "bolt.fill",
                    radius: true,
                    h0: false,
                    a0: false,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "esp_line",
                    section: "visual",
                    title: "ESP Snaplines",
                    subtitle: "Renders distance tracer lines to visible enemies",
                    symbol: "line.diagonal",
                    radius: false,
                    h0: false,
                    a0: false,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "esp_box",
                    section: "visual",
                    title: "ESP Box 2D",
                    subtitle: "Bounding box indicators for player entities",
                    symbol: "rectangle",
                    radius: false,
                    h0: false,
                    a0: false,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "anti_recoil",
                    section: "memory",
                    title: "No Recoil",
                    subtitle: "Neutralizes weapon spread and camera recoil",
                    symbol: "shield.fill",
                    radius: false,
                    h0: false,
                    a0: false,
                    exclusiveGroup: nil
                ),
                FeatureOption(
                    id: "fast_scope",
                    section: "memory",
                    title: "Fast Switch Scope",
                    subtitle: "Bypasses optic transition and zoom animations",
                    symbol: "gauge.with.needle.fill",
                    radius: false,
                    h0: false,
                    a0: false,
                    exclusiveGroup: nil
                )
            ],
            radius: SliderPolicy(min: 20.0, max: 360.0, step: 5.0, initial: 120.0),
            h0: SliderPolicy(min: 0.0, max: 100.0, step: 5.0, initial: 85.0)
        )
    }
}
