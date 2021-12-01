//
//  AQICategoryConfiguration.swift
//  AQIAssignment
//
//  Created by Ankur Batham on 23/11/21.
//

import UIKit

enum AQICategoryConfiguration: Int {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe

    init?(rawValue: Int) {
        switch rawValue {
        case 0 ... 50: self = .good
        case 51 ... 100: self = .satisfactory
        case 101 ... 200: self = .moderate
        case 201 ... 300: self = .poor
        case 301 ... 400: self = .veryPoor
        case 401 ... 500: self = .severe
        default: return nil
        }
    }

}

extension AQICategoryConfiguration {
    
    var displayString: String {
        switch self {
        case .good : return "Good"
        case .satisfactory : return "Satisfcatory"
        case .moderate : return "Moderate"
        case .poor : return "Poor"
        case .veryPoor : return "VeryPoor"
        case .severe : return "Severe"
        }
    }

    var color: UIColor {
        switch self {
        case .good:
            return #colorLiteral(red: 0.2745098039, green: 0.4862071892, blue: 0.2352941176, alpha: 1)
        case .satisfactory:
            return #colorLiteral(red: 0.6274509804, green: 0.7843137255, blue: 0.2588235294, alpha: 1)
        case .moderate:
            return #colorLiteral(red: 0.9960784314, green: 0.8456647307, blue: 0.4097188363, alpha: 1)
        case .poor:
            return #colorLiteral(red: 0.9254901961, green: 0.5411764706, blue: 0.1568627451, alpha: 1)
        case .veryPoor:
            return #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        case .severe:
            return #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        }
    }
    
}
