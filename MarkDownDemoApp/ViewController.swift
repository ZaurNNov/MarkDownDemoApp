//
//  ViewController.swift
//  MarkDownDemoApp
//
//  Created by ZG on 14.12.2022.
//

import UIKit
import CDMarkdownKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var showEdited: UIButton!
    @IBAction func showEditedAction(_ sender: UIButton) {
        showEditedText()
    }
    @IBOutlet weak var showPreview: UIButton!
    @IBAction func showPreviewAction(_ sender: UIButton) {
        showPreviewText()
    }
    
    // Create editor
    var editor: Notepad?
    // Create parser
    var markdownParser: CDMarkdownParser?

    var string: String =
        """
        # Header 1
        ## Header 2
        ### Header 3
        \n
        - Some text
        --- Some text with in dept
        
        first paragraph
        second paragraph
        
        [x] some x
        [ ] some without
        - [ x ] some x
        - [ x ] some without
        \n\n
        This is some **bold** text.
        This is some *italic* text.
        This is some `inline code`.
        This is a custom @regex rule.
        \n\n\n
        This is a custom [google URL](https://google.com).
        """
    var attributedString: NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneMarkdownParser()
        editor = Notepad(frame: textContainerView.bounds, themeFile: .systemMinimal)
        editor?.textContainerInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        editor?.delegate = self
        if let editor = editor {
            textContainerView.addSubview(editor)
        }
        attributedString = nil
        previewLabel.text = nil
        previewLabel.isUserInteractionEnabled = false // нечего тыкать в превью текст
    }
    
    private func showEditedText() {
        attributedString = nil
        previewLabel.text = nil
        editor?.isUserInteractionEnabled = true
        editor?.text = string
        //        let testFile = Bundle.main.path(forResource: "tests", ofType: "md")
        //        do {
        //            let text = try String(contentsOfFile: testFile!)
        //            editor.text = text
        //        } catch {
        //            print(error)
        //        }
    }
    
    private func showPreviewText() {
        editor?.text = nil
        editor?.isUserInteractionEnabled = false

        /// вместо использования лейбла можно использовать текствью либо текствью из либы
        /// previewTextView: CDMarkdownTextView!
        /// тогда можно тонко настравать этот текствью, либо markdownParser как в этом примере
        // Parse markdown
        if attributedString == nil {
            attributedString = markdownParser?.parse(string)
            previewLabel.attributedText = attributedString
        }
    }
    
    private func tuneMarkdownParser() {
        /*
         init(font: CDFont = CDFont.systemFont(ofSize: 12),
         boldFont: CDFont? = nil,
         italicFont: CDFont? = nil,
         fontColor: CDColor = CDColor.black,
         backgroundColor: CDColor = CDColor.clear,
         paragraphStyle: NSParagraphStyle? = nil,
         imageSize: CGSize? = nil,
         automaticLinkDetectionEnabled: Bool = true,
         squashNewlines: Bool = true,
         customElements: [CDMarkdownElement] = [])
         */
        let font = CDFont.systemFont(ofSize: 16, weight: .regular)
        let boldFont = CDFont.systemFont(ofSize: 16, weight: .bold)
        let italicFont = CDFont.italicSystemFont(ofSize: 16)
        let fontColor = CDColor(named: "textColor") ?? .label
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.lineSpacing = CGFloat(4)
        
        markdownParser = CDMarkdownParser(font: font, boldFont: boldFont, italicFont: italicFont, fontColor: fontColor, paragraphStyle: paragraphStyle, squashNewlines: true)
    }
}

extension ViewController: UITextViewDelegate {
    
}
