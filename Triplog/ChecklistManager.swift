//
//  ChecklistManager.swift
//  Triplog
//
//  Created by 배수빈 on 6/15/25.
//

import UIKit

class ChecklistManager {
    static let shared = ChecklistManager()

    private let key = "checklist_items"

    func save(_ items: [ChecklistItem]) {
        let data = try? JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> [ChecklistItem] {
        if let data = UserDefaults.standard.data(forKey: key),
           let items = try? JSONDecoder().decode([ChecklistItem].self, from: data) {
            return items
        }
        return []
    }
    
}
