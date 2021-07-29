//
//  Attatchment.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-02-15.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
enum attatchmentType: String, CaseIterable {
    case png, jpeg, heic, pdf, image, none

    static func getImageCases() -> [String] {
        
        return [attatchmentType.png.rawValue, attatchmentType.jpeg.rawValue, attatchmentType.heic.rawValue, attatchmentType.image.rawValue]
    }
}

class Attatchment {
    var image: UIImage?
    var attatchmentURL: URL?
    var type: attatchmentType?

    init(image: UIImage, url: URL) {
        self.image = image
        self.attatchmentURL = url
        self.type = getType(url.absoluteString)
    }

    init(url: URL) {
        self.attatchmentURL = url
        self.type = getType(url.absoluteString)

        if type == .pdf {
        self.image = generatePdfThumbnail(of: CGSize(width: 50, height: 50), for: url, atPage: 0)
        } else {
            if let imageData = try? Data(contentsOf: url) {

            self.image = UIImage(data: imageData)
            }
        }
        }

    init(image: UIImage) {
        self.image = image
        self.type = .png
    }

    func getType(_ url: String) -> attatchmentType {
        let fileExtension = String(url.split(separator: ".").last ?? "")

        switch fileExtension {
        case "png":
            return attatchmentType.png
        case "pdf":
            return attatchmentType.pdf
        case "heic":
            return attatchmentType.heic
        case "image":
            return attatchmentType.image
        case "jpeg":
            return attatchmentType.jpeg
        default:
            return attatchmentType.none
        }
    }

    func generatePdfThumbnail(of thumbnailSize: CGSize, for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
}
