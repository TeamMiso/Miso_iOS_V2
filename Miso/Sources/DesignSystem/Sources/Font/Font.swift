import UIKit

extension UIFont {
    enum Family: String {
        case regular = "Regular",
             thin = "Thin",
             extraLight = "ExtraLight",
             light = "Light",
             medium = "Medium",
             semiBold = "SemiBold",
             bold = "Bold",
             extraBold = "ExtraBold",
             heavy = "Heavy"
    }

    static func miso(size: CGFloat, family: Family) -> UIFont! {
        return UIFont(name: "SUITv1-\(family.rawValue)", size: size)
    }
}
