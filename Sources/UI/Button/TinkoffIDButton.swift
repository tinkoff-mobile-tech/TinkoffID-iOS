//
//  TinkoffIDButton.swift
//  TinkoffID
//
//  Copyright (c) 2021 Tinkoff
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit

final class TinkoffIDButton: UIButton {

    private let font: UIFont
    private let title: String
    private let badge: String?
    private let colorStyle: TinkoffIDButtonColorStyle
    private let cornerRadius: CGFloat

    private let defaultTitle = "Tinkoff"

    private var cachedSize: CGSize = .zero
    private var size: TinkoffIDButtonSize

    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = colorStyle.badgeTextColor
        label.text = badge
        label.font = font.withSize(size.badgeFontSize)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()

    private lazy var badgeInfoField: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = colorStyle.badgeFieldColor
        return view
    }()

    private lazy var imageBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = size.borderWidth
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearanceForCurrentState()
        }
    }
    
    init(configuration: TinkoffIDButtonConfiguration, title: String? = nil, badge: String? = nil) {
        self.size = configuration.size
        self.colorStyle = configuration.colorStyle
        self.cornerRadius = configuration.cornerRadius
        self.font = configuration.font
        self.badge = badge
        self.title = title ?? ""
        
        super.init(frame: .zero)
        
        didInitialize()
    }
    
    required init?(coder: NSCoder) {
        self.size = .medium
        self.colorStyle = .default
        self.cornerRadius = 8
        self.font = UIFont.systemFont(ofSize: 15)
        self.badge = nil
        self.title = ""
        
        super.init(coder: coder)

        self.setTitle(defaultTitle, for: .normal)
        
        didInitialize()
    }
    
    override var intrinsicContentSize: CGSize {
        if badge != nil {
            return CGSize(
                width: super.intrinsicContentSize.width + badgeInfoField.frame.width + size.badgeLeftOffset,
                height: size.defaultHeight
            )
        } else {
            return CGSize(width: super.intrinsicContentSize.width, height: size.defaultHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard cachedSize != bounds.size else { return }
        cachedSize = bounds.size

        size = TinkoffIDButtonSize(height: bounds.height)

        updateFonts()
        updateImage()

        badgeLabel.sizeToFit()

        if badge != nil {
            layoutWithBadge()
        } else {
            layoutWithoutBadge()
        }
        if colorStyle == .alternativeDark {
            addIconBorder()
        }
    }
    
    // MARK: - Private

    private func layoutWithBadge() {
        let imageWidth = self.imageView!.frame.width
        let titleWidth = self.titleLabel!.frame.width

        let rect = CGRect(
            x: self.bounds.width - badgeLabel.frame.width - size.horizontalLabelOffset - size.contentEdgePadding,
            y: (self.bounds.height - badgeLabel.frame.height - size.verticalLabelOffset) / 2,
            width: badgeLabel.frame.width + size.horizontalLabelOffset,
            height: badgeLabel.frame.height + size.verticalLabelOffset
        )
        badgeInfoField.frame = rect
        badgeLabel.center = badgeInfoField.center
        badgeInfoField.layer.cornerRadius = rect.height/2

        self.imageEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: titleWidth + size.imageRightPadding,
            bottom: .zero,
            right: -titleWidth - size.imageRightPadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: -imageWidth,
            bottom: .zero,
            right: imageWidth
        )

        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(
            top: size.contentVerticalPadding,
            left: size.contentEdgePadding,
            bottom: size.contentVerticalPadding,
            right: size.contentEdgePadding
        )
    }

    private func layoutWithoutBadge() {
        let imageWidth = self.imageView!.frame.width
        let titleWidth = self.titleLabel!.frame.width
        self.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: titleWidth + size.imageRightPadding / 2,
            bottom: 0,
            right: -titleWidth - size.imageRightPadding / 2
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageWidth - size.imageRightPadding / 2,
            bottom: 0,
            right: imageWidth + size.imageRightPadding / 2
        )
    }

    private func addIconBorder() {
        imageBorder.frame.size = CGSize(
            width: imageView!.frame.width + 2 * size.borderWidth,
            height: imageView!.frame.height + 2 * size.borderWidth
        )
        imageBorder.center = imageView!.center
        imageBorder.layer.cornerRadius = imageBorder.frame.height/2
    }
    
    private func didInitialize() {
        configure()
        updateAppearanceForCurrentState()
    }
    
    private func configure() {
        // Title
        titleLabel?.sizeToFit()
        
        // Image
        imageView?.contentMode = .scaleAspectFit

        // Content
        contentEdgeInsets = UIEdgeInsets(
            top: size.contentVerticalPadding,
            left: size.contentHorizontalPadding,
            bottom: size.contentVerticalPadding,
            right: size.contentHorizontalPadding
        )
        setContentHuggingPriority(.required, for: .vertical)

        if badge != nil {
            addSubview(badgeInfoField)
            addSubview(badgeLabel)
        }
        if colorStyle == .alternativeDark {
            addSubview(imageBorder)
        }

        // Appearance
        layer.cornerRadius = cornerRadius
        updateFonts()
        updateImage()
    }

    private func updateFonts() {
        let titleText = NSMutableAttributedString(
            string: title,
            attributes: [.font: font.withSize(size.titleFontSize), .foregroundColor: colorStyle.titleColor]
        )
        let defaultTitleText = NSAttributedString(
            string: defaultTitle,
            attributes: [
                .font: font.createBoldFont().withSize(size.titleFontSize),
                .foregroundColor: colorStyle.titleColor
            ]
        )
        titleText.append(defaultTitleText)
        setAttributedTitle(titleText, for: .normal)

        badgeLabel.font = font.withSize(size.badgeFontSize)
    }

    private func updateImage() {
        setImage(size.image, for: .normal)
        setImage(size.image, for: .highlighted)
    }
    
    private func updateAppearanceForCurrentState() {
        backgroundColor = colorStyle.backgroundColorFor(state: state)
    }
}

// MARK: - Private

private extension TinkoffIDButtonSize {

    /// Высота кнопки
    var defaultHeight: CGFloat {
        switch self {
        case .small:
            return 30
        case .medium:
            return 40
        case .large:
            return 60
        }
    }
    
    /// Шрифт
    var titleFontSize: CGFloat {
        switch self {
        case .small:
            return 13
        case .medium:
            return 15
        case .large:
            return 19
        }
    }

    /// Отступ между иконкой и текстом
    var imageRightPadding: CGFloat {
        switch self {
        case .small:
            return 4
        case .medium, .large:
            return 8
        }
    }

    /// Изображение
    var image: UIImage? {
        switch self {
        case .small:
            return Bundle.resourcesBundle?
                .imageNamed("idLogoS")
        case .medium:
            return Bundle.resourcesBundle?
                .imageNamed("idLogoM")
        case .large:
            return Bundle.resourcesBundle?
                .imageNamed("idLogoL")
        }
    }
    
    /// Отступы по горизонтали
    var contentHorizontalPadding: CGFloat {
        switch self {
        case .small:
            return 32
        case .medium:
            return 40
        case .large:
            return 60
        }
    }
    
    /// Отступы по вертикали
    var contentVerticalPadding: CGFloat {
        switch self {
        case .small:
            return 5
        case .medium:
            return 10
        case .large:
            return 16
        }
    }

    ///  Отступ от краев при отображении кэшбэка
    var contentEdgePadding: CGFloat {
        switch self {
        case .small:
            return 10
        case .medium:
            return 13
        case .large:
            return 20
        }
    }

    /// Отступы внутри кэшбэка
    var horizontalLabelOffset: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 13
        case .large:
            return 16
        }
    }
    var verticalLabelOffset: CGFloat {
        switch self {
        case .small:
            return 0
        case .medium:
            return 4
        case .large:
            return 4
        }
    }


    /// Шрифт кэшбэка
    var badgeFontSize: CGFloat {
        switch self {
        case .small, .medium:
            return 11
        case .large:
            return 13
        }
    }

    /// Минимальный отступ от бейджа слева
    var badgeLeftOffset: CGFloat {
        switch self {
        case .small:
            return 20
        case .medium:
            return 26
        case .large:
            return 40
        }
    }

    /// Ширина окантовки лого
    var borderWidth: CGFloat { 2 }
}

private extension UIFont {
    func createBoldFont() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
