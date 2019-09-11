//
//  LockScreenInfo.swift
//  StackOverflowExample
//
//  Created by Dave Troupe on 9/11/19.
//  Copyright © 2019 High Tree Development. All rights reserved.
//

import Foundation

final class LockScreenInfo {

    private let q = DispatchQueue(label: "LockScreenInfo")
    private var lockScreenPlayingInfo: [String: Any]?

    func setValues(_ dict: [String: Any]) {
        q.sync { [weak self] in
            guard let sself = self else { return }

            sself.lockScreenPlayingInfo = dict
        }
    }

    func updateValues(_ dict: [String: Any]) {
        q.sync { [weak self] in
            guard let sself = self else { return }

            for (key, value) in dict {
                sself.lockScreenPlayingInfo?[key] = value
            }
        }
    }

    func clearAllValues() {
        q.sync { [weak self] in
            guard let sself = self else { return }

            sself.lockScreenPlayingInfo = [:]
        }
    }

    func getValues() -> [String: Any]? {
        return q.sync { [weak self] in
            guard let sself = self else { return nil }

            return sself.lockScreenPlayingInfo
        }
    }
}

