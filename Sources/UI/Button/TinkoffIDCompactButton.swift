//
//  TinkoffIDRoundButton.swift
//  TinkoffID
//
//  Copyright (c) 2022 Tinkoff
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

final class TinkoffIDCompactButton: UIButton {

    /// Высота кнопки
    private var size: CGFloat { 56 }
    
    /// Изображение
    private var image: UIImage? {
        Bundle.resourcesBundle?
            .imageNamed("logo")
    }
    
    private let colorStyle: TinkoffIDButtonColorStyle
    
    override var isHighlighted: Bool {
        didSet {
            updateAppearanceForCurrentState()
        }
    }
    
    init(colorStyle: TinkoffIDButtonColorStyle) {
        self.colorStyle = colorStyle
        
        super.init(frame: .zero)

        didInitialize()
    }
    
    required init?(coder: NSCoder) {
        self.colorStyle = .default
        
        super.init(coder: coder)
        didInitialize()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: size, height: size)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height/2
    }

    // MARK: - Private
    
    private func didInitialize() {
        configure()
        updateAppearanceForCurrentState()
    }
    
    private func configure() {
        
        // Image
        imageView?.contentMode = .scaleToFill
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill

        setContentHuggingPriority(.required, for: .vertical)

        contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
    }
    
    private func updateAppearanceForCurrentState() {
        backgroundColor = colorStyle.backgroundColorFor(state: state)
    }
}
