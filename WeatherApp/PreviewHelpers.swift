//
//  PreviewHelpers.swift
//  WeatherApp
//
//  Created by Devansh Sharma on 03.08.25.
//

import Foundation
import SwiftUI

struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> some View) {
        self._value = State(initialValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }
    
    var body: some View {
        content($value)
    }
}
