#if os(OSX)
import AppKit
typealias Color = NSColor

#else
import UIKit
typealias Color = UIColor

#endif

enum NodeProperties {
    enum Names {
        static let player = "PlayerNode"
        static let floor = "Floor"
        static let empty = "Empty"
        static let exit = "Exit"
    }
    
    enum Colors {
        enum Fill {
            static let empty: Color = .clear
            static let exit: Color = .brown
            static let floor: Color = .purple
        }
        
        enum Stroke {
            static let empty: Color = .clear
            static let exit: Color = .white
            static let floor: Color = .white
        }
    }
}
