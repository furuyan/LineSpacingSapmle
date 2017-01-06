import UIKit
import TextAttributes
import SnapKit

class ViewController: UIViewController {
    let font = UIFont.systemFont(ofSize: 14)
    
    lazy var jaSingleLineLabel: LineSpacingLabel = {
        let label = LineSpacingLabel()
        label.backgroundColor = .red
        label.attributedText = self.attrText(with: "あ")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var jaMultiLineLabel: LineSpacingLabel = {
        let label = LineSpacingLabel()
        label.backgroundColor = .red
        label.attributedText = self.attrText(with: "あ\nあ")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var engSingleLineLabel: LineSpacingLabel = {
        let label = LineSpacingLabel()
        label.backgroundColor = .red
        label.attributedText = self.attrText(with: "a")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var engMultiLineLabel: LineSpacingLabel = {
        let label = LineSpacingLabel()
        label.backgroundColor = .red
        label.attributedText = self.attrText(with: "a\na")
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(jaSingleLineLabel)
        view.addSubview(jaMultiLineLabel)
        view.addSubview(engSingleLineLabel)
        view.addSubview(engMultiLineLabel)
        
        jaSingleLineLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(engSingleLineLabel)
            make.width.equalTo(jaMultiLineLabel)
            make.width.equalTo(engMultiLineLabel)
        }
        
        engSingleLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jaSingleLineLabel)
            make.left.equalTo(jaSingleLineLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
        }
        
        jaMultiLineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(jaSingleLineLabel)
            make.top.equalTo(jaSingleLineLabel.snp.bottom).offset(10)
        }
        
        engMultiLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jaMultiLineLabel)
            make.left.equalTo(jaMultiLineLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func attrText(with text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: TextAttributes().lineSpacing(10).font(font))
    }
}

class LineSpacingLabel: UILabel {
    var adjustedHeight = CGFloat(0.0)
    var adjustedForLineSpacingBug = false
    
    override func drawText(in rect: CGRect) {
        var baseRect = rect
        
        if adjustedForLineSpacingBug {
            baseRect.origin.y = adjustedHeight / 2.0
        }
        
        super.drawText(in: baseRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        
        adjustedHeight = 0.0
        adjustedForLineSpacingBug = false
        
        // lineSpacingを設定しているかつlineSpacingが0以外の時のみ処理を行う
        if let paragraphStyle = attributedText?.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSParagraphStyle,
            paragraphStyle.lineSpacing != 0.0 {
         
            let fontHeight = ceil(self.font.lineHeight)
            let lineSpacing = paragraphStyle.lineSpacing
            
            // 固有サイズの高さがフォントの高さ+行間スペースの場合(1行だけど下に行間スペースが挿入されている場合)
            // 本来の高さに変更する
            if baseSize.height == fontHeight + lineSpacing {
                adjustedHeight = lineSpacing
                adjustedForLineSpacingBug = true
                return CGSize(width: baseSize.width, height: fontHeight)
            }
        }
        
        return baseSize
    }
}

