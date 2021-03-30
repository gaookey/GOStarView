//
//  SPStarView.swift
//  demo
//
//  Created by 高文立 on 2021/3/29.
//

import UIKit
import SnapKit

public protocol SPStarViewDelegate: NSObjectProtocol {
    func didChangeValue(view: SPStarView, value: CGFloat)
}
extension SPStarViewDelegate {
    func didChangeValue(view: SPStarView, value: CGFloat) { }
}

public class SPStarView: UIView {
    
    weak open var delegate: SPStarViewDelegate?
    
    /// 当前值 0 - 1
    public var value: CGFloat = 0 {
        willSet {
            let result = getResultValue(newValue)
            
            UIView.animate(withDuration: animationDuration) {
                self.contentView.snp.remakeConstraints { (make) in
                    make.leading.top.bottom.equalTo(self)
                    make.width.equalTo(self.snp.width).multipliedBy(result)
                }
                self.layoutIfNeeded()
            } completion: { _ in
                self.delegate?.didChangeValue(view: self, value: result)
            }
        }
        didSet {
            value = getResultValue(value)
        }
    }
    /// 动画时间，默认0
    public var animationDuration: Double = 0
    /// 允许的最小值（0 - 1），默认 0。
    public var minValue: CGFloat = 0 {
        didSet {
            minValue = ((minValue < 0 ? 0 : minValue) > 1 ? 1 : minValue)
        }
    }
    /// 半颗星展示，默认 NO。
    public var isHalfStar = false {
        willSet {
            if newValue {
                isFullStar = false
            }
        }
    }
    /// 满颗星展示，默认 NO。
    public var isFullStar = false {
        willSet {
            if newValue {
                isHalfStar = false
            }
        }
    }
    /// 宽高比
    public var aspectRatio: CGFloat {
        get {
            guard let width = backImage?.size.width,
                  let height = frontImage?.size.height else { return 1 }
            return width / height
        }
    }
    public var backImage = UIImage(named: "SPStarView.bundle/star_normal.png") {
        willSet {
            backImageView.image = newValue
        }
    }
    public var frontImage = UIImage(named: "SPStarView.bundle/star_select.png") {
        willSet {
            frontImageView.image = newValue
        }
    }
    
    
    private lazy var backImageView = UIImageView(image: backImage)
    private lazy var frontImageView = UIImageView(image: frontImage)
    private lazy var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - public method
extension SPStarView {
    
    public func update(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let p = touch?.location(in: self),
              point(inside: p, with: event) else { return }
        
        if semanticContentAttribute == .forceRightToLeft {
            value = (bounds.width - p.x) / bounds.width
        } else {
            value = p.x / bounds.width
        }
    }
}

// MARK: - private method
extension SPStarView {
    
    private func initView() {
        addSubview(backImageView)
        addSubview(contentView)
        contentView .addSubview(frontImageView)
        
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self.snp.width)
        }
        frontImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func getResultValue(_ value: CGFloat) -> CGFloat {
        var result = ((value < 0 ? 0 : value) > 1 ? 1 : value)
        
        if isHalfStar || isFullStar { // 半颗星 & 满颗星
            result = result * 5.0
            
            if round(result) <= 0 { // 四舍五入 等于 0
                result = 0;
            } else if ceil(result) == round(result) { // 小数位大于 0.5
                result = ceil(result)
            } else { // 小数位小于 0.5
                result = floor(result) + (isHalfStar ? 0.5 : 0)
            }
            result = result / 5.0
        }
        
        return (result < minValue) ? minValue : result
    }
}
