//
//  ViewController.swift
//  FileHandlerv2
//
//  Created by Esben Gaarsmand on 08/11/2021.
//
import UIKit
import Foundation
import UniformTypeIdentifiers
import MobileCoreServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnClick(_ sender: Any) {
        var documentsPicker: UIDocumentPickerViewController?
        
        // Setup UIDocumentPicker.
        if #available(iOS 14, *) {
            documentsPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.text,
                                                                                      UTType.utf8PlainText,
                                                                                      UTType.flatRTFD,
                                                                                      UTType.pdf])
        } else {
            documentsPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),
                                                                             String(kUTTypeUTF8PlainText),
                                                                             String(kUTTypeFlatRTFD),
                                                                             String(kUTTypePDF)], in: .open)
        }
        
        documentsPicker?.delegate = self
        documentsPicker?.allowsMultipleSelection = false
        
        // Force user to have only one way to cancel screen.
        documentsPicker?.modalPresentationStyle = .fullScreen
        
        if let docPicker = documentsPicker {
            self.present(docPicker, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let originalUrl = urls.first else { return }
        
        let securityResults = originalUrl.startAccessingSecurityScopedResource()
        print("Security allowed?: " + securityResults.description)
        
        // Release the security-scoped resource when we finish.
        defer { originalUrl.stopAccessingSecurityScopedResource() }
        
        do {
            let bookmark = try originalUrl.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            print("We have a bookmark: " + bookmark.debugDescription)
        } catch {
            print(error)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("cancelled")
    }
}
