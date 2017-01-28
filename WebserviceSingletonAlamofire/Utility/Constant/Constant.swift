
import Foundation
import UIKit

// Configure
struct Config {
    
    // MARK: Reachability class
    static func isNetworkAvailable() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus().rawValue;
        var isAvailable  = false;
        
        switch networkStatus {
        case (NotReachable.rawValue):
            isAvailable = false;
            break;
        case (ReachableViaWiFi.rawValue):
            isAvailable = true;
            break;
        case (ReachableViaWWAN.rawValue):
            isAvailable = true;
            break;
        default:
            isAvailable = false;
            break;
        }
        return isAvailable;
    }
    
}

// Storyboard Identifier
struct StoryBoardIdentifier {
    static let SignUpViewController    = "signUpIdentifier"
}

//Static Strings
struct StaticString {
    static let InternetConnectionAlert = "Internet connection is unavailable"
    static let ServerError = "Server is busy, please try again"
    static let SomeError = "Some error from server, and its notification is already displayed to user"
}

// Screen size
struct Screen {
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    static func isIphone6() -> Bool {
        return height == 667 ? true : false
    }
    static func isIphone5() -> Bool {
        return height == 568 ? true : false
    }
    static func isIphone6Plus() -> Bool {
        return height == 736 ? true : false
    }
    static func isIphone4() -> Bool {
        return height == 480 ? true : false
    }
}

var appDelegate = UIApplication.shared.delegate as! AppDelegate

//Show alert toast
func showToastWithMessage(message: String) {
    
}
