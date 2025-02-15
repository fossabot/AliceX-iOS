//
//  BaseUIControl.swift
//  AliceX
//
//  Created by lmcmz on 20/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit

class BaseControl: UIControl {
    @IBInspectable var highlightColor: UIColor?
    var normalColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDefaultValue()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initDefaultValue()
    }

    func initDefaultValue() {
        normalColor = backgroundColor
        highlightColor = UIColor(hex: "0xD9D9D9")
    }

    open override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightColor : normalColor
        }
    }
}
