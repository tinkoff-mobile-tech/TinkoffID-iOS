//
//  TinkoffIDButton.swift
//  TinkoffID
//
//  Created by Dmitry on 17.12.2020.
//

import UIKit

final class TinkoffIDButton: UIButton {
    
    private let style: TinkoffIDButtonStyle
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearanceForCurrentState()
        }
    }
    
    init(_ style: TinkoffIDButtonStyle) {
        self.style = style
        
        super.init(frame: .zero)
        
        didInitialize()
    }
    
    required init?(coder: NSCoder) {
        self.style = .default
        
        super.init(coder: coder)
        
        didInitialize()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: style.height)
    }
    
    // MARK: - Private
    
    private func didInitialize() {
        configure()
        updateAppearanceForCurrentState()
    }
    
    private func configure() {
        // Title
        setTitle(style.title, for: .normal)
        
        // Image
        imageView?.contentMode = .scaleAspectFit
        setImage(style.image, for: .normal)
        setImage(style.image, for: .highlighted)
        
        imageEdgeInsets = UIEdgeInsets(top: .zero,
                                       left: -style.imageRightPadding,
                                       bottom: .zero,
                                       right: style.imageRightPadding)
        
        // Content
        contentEdgeInsets = UIEdgeInsets(top: style.contentVerticalPadding,
                                         left: style.contentHorizontalPadding + style.imageRightPadding,
                                         bottom: style.contentVerticalPadding,
                                         right: style.contentHorizontalPadding)
        setContentHuggingPriority(.required, for: .vertical)
        
        // Appearance
        layer.cornerRadius = style.cornerRadius
        titleLabel?.font = style.titleFont
    }
    
    private func updateAppearanceForCurrentState() {
        backgroundColor = style.backgroundColorFor(state: state)
        setTitleColor(style.titleColorFor(state: state), for: state)
    }
}

// MARK: - Private

private extension TinkoffIDButtonStyle {
    /// Возвращает цвет фона для соответствующего состояния
    /// - Parameter state: Состояние кнопки
    func backgroundColorFor(state: UIControl.State) -> UIColor {
        switch state {
        case .highlighted:
            return UIColor(red: 1, green: 0.803922, blue: 0.2, alpha: 1)
        default:
            return UIColor(red: 1, green: 0.86, blue: 0.1764, alpha: 1)
        }
    }
    
    /// Возвращает цвет текста для соответствующего состояния
    /// - Parameter state: Состояние кнопки
    func titleColorFor(state: UIControl.State) -> UIColor {
        UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    }
    
    /// Высота кнопки
    var height: CGFloat {
        switch self {
        case .compact:
            return 40
        case .default:
            return 56
        }
    }
    
    /// Степень скругления краёв
    var cornerRadius: CGFloat {
        switch self {
        case .compact:
            return 12
        case .default:
            return 16
        }
    }
    
    /// Заголовок
    var title: String? {
        Bundle.resourcesBundle?
            .localizedString("SignInButton.Title")
    }
    
    /// Шрифт
    var titleFont: UIFont {
        let size: CGFloat
        
        switch self {
        case .default:
            size = 17
        case .compact:
            size = 15
        }
        
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    /// Изображение
    var image: UIImage? {
        Bundle.resourcesBundle?
            .imageNamed("logo")
    }
    
    /// Отступы по горизонтали
    var contentHorizontalPadding: CGFloat { 32 }
    
    /// Отступы по вертикали
    var contentVerticalPadding: CGFloat { 6 }
    
    /// Отступ между изображением и текстом
    var imageRightPadding: CGFloat { 8 }
}
