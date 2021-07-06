//
//  GOStarView.swift
//  GOStarView
//
//  Created by 高文立 on 2021/3/29.
//

import UIKit
import SnapKit

@objc public enum GOStarType: Int {
    case none
    case half // 半颗星
    case full // 满颗星
}

@objc public protocol GOStarViewDelegate: NSObjectProtocol {
    @objc optional func didChangeValue(view: GOStarView, value: CGFloat)
}

@objcMembers public class GOStarView: UIView {
    
    weak open var delegate: GOStarViewDelegate?
    
    /// 当前值 0 - 1。
    public var value: CGFloat = 0 {
        didSet {
            layoutView()
        }
    }
    /// ✨✨ 类型
    public var starType = GOStarType.none {
        didSet {
            layoutView()
        }
    }
    /// 允许的最小值（0 - 1），默认 0。
    public var minValue: CGFloat = 0 {
        didSet {
            let result = (minValue < 0 ? 0 : minValue)
            minValue = (result > 1 ? 1 : result)
            layoutView()
        }
    }
    /// 图片宽高比，以 selectedImageView 计算。
    public var viewRatio: CGFloat {
        get {
            guard let width = selectedImageView.image?.size.width,
                  let height = selectedImageView.image?.size.height,
                  width > 0,
                  height > 0 else { return 1 }
            return width / height
        }
    }
    /// 动画时间，默认0
    public var duration: Double = 0
    /// 正常状态图片
    public var normalImage: UIImage = UIImage() {
        willSet {
            normalImageView.image = newValue
        }
    }
    /// 选中状态图片
    public var selectedImage: UIImage = UIImage() {
        willSet {
            selectedImageView.image = newValue
        }
    }
    
    private lazy var normalImageView = UIImageView(image: UIImage(named: "GOStarView_star_normal", in: Bundle(for: GOStarView.self), compatibleWith: nil))
    private lazy var selectedImageView = UIImageView(image: UIImage(named: "GOStarView_star_select", in: Bundle(for: GOStarView.self), compatibleWith: nil))
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    /// 初始化
    /// - Parameter value: 初始值
    public init(value: CGFloat = 0) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        self.value = value
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - public method
extension GOStarView {
    
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
extension GOStarView {
    
    private func initView() {
        addSubview(normalImageView)
        addSubview(contentView)
        contentView .addSubview(selectedImageView)
        
        normalImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(self.value)
        }
        selectedImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func getResultValue(_ value: CGFloat) -> CGFloat {
        var result = (value < 0 ? 0 : value)
        result = (result > 1 ? 1 : result)
        result = (result < minValue) ? minValue : result
        
        guard result > 0, result < 1 else { return result }
        guard starType == .full || starType == .half else { return result }
        
        let handler = NSDecimalNumberHandler(roundingMode: .plain, scale: 1, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        result = CGFloat(NSDecimalNumber(value: Float(result)).multiplying(by: NSDecimalNumber(value: 5.0), withBehavior: handler).floatValue)
        guard let last = String(format: "%.1f", result).components(separatedBy: ".").last, let lastObject = NSInteger(last) else { return result }
        
        if (lastObject == 0) { // = 0.0
            
        } else if (lastObject > 0 && lastObject < 5) { // < 0.5
            result = round(result);
            if (starType == .half) {// 半颗星显示
                result += 0.5;
            } else if (starType == .full) { // 满颗星显示
                result += 1;
            }
        } else if (lastObject > 5 && lastObject < 10) { // > 0.5
            result = round(result);
        } else { // = 0.5
            if (starType == .full) {// 满颗星显示
                result = round(result);
            }
        }
        
        return result / 5.0;
    }
    
    private func layoutView() {
        let result = getResultValue(value)
        
        UIView.animate(withDuration: duration) {
            self.contentView.snp.remakeConstraints { (make) in
                make.leading.top.bottom.equalTo(self)
                make.width.equalTo(self.snp.width).multipliedBy(result)
            }
            self.layoutIfNeeded()
        } completion: { _ in
            self.delegate?.didChangeValue?(view: self, value: result)
        }
    }
}
