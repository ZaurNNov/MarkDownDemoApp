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
    @IBOutlet weak var textView: CDMarkdownTextView!
    
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

    var editedString: String?
    var inputString: String =
    """
    *italic* or _italic_
    **bold** or __bold__
    
    # Header 1
    ## Header 2
    ### Header 3
    #### Header 4
    ##### Header 5
    ###### Header 6
    
    > Quote
    >> In Depth
    
    * List
    - List
    + List
    
    `code or syntax`
                    
    [Link](url)
    ![Image](url)
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
        textView.text = nil
        textView.isEditable = false
    }
    
    private func showEditedText() {
        attributedString = nil
        textView.text = nil
        editor?.isUserInteractionEnabled = true
        editor?.text = editedString?.notEmpty() ?? inputString
        //        let testFile = Bundle.main.path(forResource: "tests", ofType: "md")
        //        do {
        //            let text = try String(contentsOfFile: testFile!)
        //            editor.text = text
        //        } catch {
        //            print(error)
        //        }
    }
    
    private func showPreviewText() {
        // Parse markdown
        if attributedString == nil {
            attributedString = markdownParser?.parse(editedString ?? inputString)
            textView.attributedText = attributedString
        }
        
        editor?.text = nil
        editor?.isUserInteractionEnabled = false
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.lineSpacing = CGFloat(4)
        
        markdownParser = CDMarkdownParser(font: font, boldFont: boldFont, italicFont: italicFont, fontColor: fontColor, paragraphStyle: paragraphStyle, squashNewlines: true)
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView == editor {
            editedString = textView.text
        }
    }
}

/// Strind additions
extension String {
    func notEmpty() -> String? {
        return self != "" ? self : nil
    }
    
    func trimSpacesAndNotEmpty() -> String? {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.notEmpty()
    }
}
