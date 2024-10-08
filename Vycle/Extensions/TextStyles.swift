//
//  TextStyles.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 04/10/24.
//

import SwiftUI

extension Text {
    func largeTitle(_ style: TitleStyle) -> Text {
        return self
            .font(InterLargeTitle().font(style))
            .kerning(-0.4)
    }

    func title1(_ style: TitleStyle) -> Text {
        return self
            .font(InterTitle1().font(style))
            .kerning(0.38)
    }

    func title2(_ style: TitleStyle) -> Text {
        return self
            .font(InterTitle2().font(style))
            .kerning(-0.26)
    }

    func title3(_ style: TitleStyle) -> Text {
        return self
            .font(InterTitle3().font(style))
            .kerning(-0.45)
    }

    func headline() -> Text {
        return self
            .font(.custom("Inter", size: 17).weight(.semibold))
            .kerning(-0.43)
    }

    func body(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterBody().font(style))
            .kerning(-0.43)
    }

    func callout(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterCallout().font(style))
            .kerning(-0.31)
    }
    
    func subhead(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterSubhead().font(style))
            .kerning(-0.23)
    }

    func footnote(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterFootnote().font(style))
            .kerning(-0.08)
    }

    func caption1(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterCaption1().font(style))
            .kerning(0)
    }

    func caption2(_ style: NonTitleStyle) -> Text {
        return self
            .font(InterCaption2().font(style))
            .kerning(0.06)
    }
}

enum TitleStyle {
    case regular, emphasized
}

enum NonTitleStyle {
    case regular, emphasized, italic, emphasizedItalic
}

enum FontSize: CGFloat {
    case largeTitle = 34
    case title1 = 28
    case title2 = 22
    case title3 = 20
    case body = 17
    case callout = 16
    case subhead = 15
    case footnote = 13
    case caption1 = 12
    case caption2 = 11
}

struct InterLargeTitle {
    func font(_ style: TitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.largeTitle.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.largeTitle.rawValue).bold()
        }
    }
}

struct InterTitle1 {
    func font(_ style: TitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.title1.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.title1.rawValue).bold()
        }
    }
}

struct InterTitle2 {
    func font(_ style: TitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.title2.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.title2.rawValue).bold()
        }
    }
}

struct InterTitle3 {
    func font(_ style: TitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.title3.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.title3.rawValue).weight(.semibold)
        }
    }
}

struct InterBody {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.body.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.body.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.body.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.body.rawValue).weight(.semibold)
        }
    }
}

struct InterCallout {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.callout.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.callout.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.callout.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.callout.rawValue).weight(.semibold)
        }
    }
}

struct InterSubhead {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.subhead.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.subhead.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.subhead.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.subhead.rawValue).weight(.semibold)
        }
    }
}

struct InterFootnote {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.footnote.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.footnote.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.footnote.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.footnote.rawValue).weight(.semibold)
        }
    }
}

struct InterCaption1 {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.caption1.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.caption1.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.caption1.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.caption1.rawValue).weight(.semibold)
        }
    }
}

struct InterCaption2 {
    func font(_ style: NonTitleStyle) -> Font {
        switch style {
        case .regular:
            return .custom("Inter", size: FontSize.caption2.rawValue)
        case .emphasized:
            return .custom("Inter", size: FontSize.caption2.rawValue).weight(.semibold)
        case .italic:
            return .custom("Inter-Italic", size: FontSize.caption2.rawValue)
        case .emphasizedItalic:
            return .custom("Inter-Italic", size: FontSize.caption2.rawValue).weight(.semibold)
        }
    }
}
