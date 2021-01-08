//
//  EventPackageConfiguration.swift
//  
//
//  Created by Lennart Fischer on 06.01.21.
//

import Foundation
import MMCommon

public struct EventPackageConfiguration: PackageConfiguration {
    public static var eventActiveMinuteThreshold: Measurement<UnitDuration> = Measurement(value: 30.0, unit: .minutes)
}
