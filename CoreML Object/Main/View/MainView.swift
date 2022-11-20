//
//  ContentView.swift
//  CoreML Object
//
//  Created by Егор Чирков on 20.11.2022.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.image{
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                }
                
                Text(viewModel.resultsText)
                
                HStack{
                    Button {
                        viewModel.onShowPicker(with: .photos)
                    } label: {
                        Text("Select photo")
                    }
                    
                    Text("OR")
                    
                    Button {
                        viewModel.onShowPicker(with: .camera)
                    } label: {
                        Text("Take photo")
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Fruit Detector")
        }
        .sheet(isPresented: $viewModel.isShowPicker) {
            ImagePickerView(selectedImage: $viewModel.image,
                            sourceType: viewModel.pickerSourceType)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
