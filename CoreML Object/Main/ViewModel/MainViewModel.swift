//
//  MainViewModel.swift
//  CoreML Object
//
//  Created by Егор Чирков on 20.11.2022.
//

import SwiftUI
import Vision
import CoreML

enum ImageSourceType{
    case photos
    case camera
}

class MainViewModel: ObservableObject{
    
    @Published var isShowPicker = false
    
    @Published var image: UIImage? = nil{
        didSet{
            guard let _ = image else {
                return
            }
            detectFruit()
        }
    }
    
    @Published var currentImageSource: ImageSourceType = .photos
    
    var resultsText: String{
        resultIdentificator.isEmpty ? "" : "Most likely, the photo shows a fruit: " + resultIdentificator
    }
    
    var resultIdentificator: String = ""
    
    var pickerSourceType: UIImagePickerController.SourceType{
        switch currentImageSource {
        case .photos:
            return .photoLibrary
        case .camera:
            return .camera
        }
    }
    
    private func detectFruit(){
        guard let model = try? VNCoreMLModel(for: FruitClassifier_1().model) else {
            debugPrint("detect: model not found")
            return
        }
        
        guard let image = image else {
            debugPrint("detect: image not load")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            if let results = request.results as? [VNClassificationObservation]{
                
                let identificator = results.first.map({ $0.identifier })
                
                if let identificator = identificator{
                    self.resultIdentificator = identificator
                }
            }
        }
        
        request.imageCropAndScaleOption = .centerCrop
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        do {
            try handler.perform([request])
        }catch{
            debugPrint("detect: failed request with ", error)
        }
    }
    
    func onShowPicker(with type: ImageSourceType){
        currentImageSource = type
        isShowPicker.toggle()
    }
}
