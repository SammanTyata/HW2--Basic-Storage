//
//  MediaView.swift
//  HW2--Basic-Storage
//
//  Created by Samman Tyata on 10/18/24.
//

import Foundation
import SwiftUI

struct MediaView: View {
    var body: some View {
        VStack {
            Text("Media Storage")
                .font(.headline)
                .padding()
            
            
            HStack {
                Button("Pick Image") {
                }
                .padding()
                
                Button("Save Image") {
                    
                }
                .padding()
                
                Button("Delete All Images") {
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    MediaView()
}
