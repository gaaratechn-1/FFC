//
//  LanguagePickerView.swift
//  YABAOCHEAT
//
//  Decompiled and reconstructed from YABAOCHEAT (FFXC Private Edition)
//

import SwiftUI

public struct LanguagePickerView: View {
    @ObservedObject var languageStore = LanguageStore.shared
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                FFXCBackdrop()
                
                List {
                    ForEach(FFLanguage.allCases) { lang in
                        Button(action: {
                            languageStore.setLanguage(lang)
                            dismiss()
                        }) {
                            HStack {
                                Text(lang.title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15, weight: .medium))
                                
                                Spacer()
                                
                                if languageStore.current == lang {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.white.opacity(0.04))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(languageStore.text("select_language"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.25, green: 0.58, blue: 0.98))
                }
            }
        }
    }
}
