//
//  EventPackageConfiguration.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import MMCommon
import UIKit

public struct EventPackageConfiguration: PackageConfiguration {
    public static var eventActiveMinuteThreshold: Measurement<UnitDuration> = Measurement(value: 30.0, unit: .minutes)
    public static var accentColor: UIColor = .systemBlue
    public static var onAccentColor: UIColor = .white
}
