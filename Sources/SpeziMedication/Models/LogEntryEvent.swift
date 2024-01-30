//
//  File.swift
//  
//
//  Created by Paul Shmiedmayer on 1/28/24.
//

import SwiftUI


public enum LogEntryEvent: Codable, CaseIterable {
    case skipped
    case taken
    
    
    public var localizedDescription: String {
        switch self {
        case .skipped:
            String(localized: "Skipped", bundle: .module)
        case .taken:
            String(localized: "Taken", bundle: .module)
        }
    }
}
