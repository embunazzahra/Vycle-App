//
//  SuccessNotification.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

public struct AddSuccessNotification: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 241, height: 290)
                .cornerRadius(12)
                .foregroundStyle(Color.neutral.tint300)
            
            VStack (spacing: 4){
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.lima500)
                    .font(.system(size: 45))
                Text("Berhasil!")
                    .title2(.emphasized)
                    .foregroundColor(Color.lima500)
                Text("Pengingat servismu telah ditambahkan")
                    .frame(width: 150)
                    .foregroundColor(Color.neutral.tone100)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    print("back to pengingat page")
                }, label: {
                    NavigationLink (destination: PengingatView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 164, height: 44)
                                .cornerRadius(12)
                                .foregroundColor(Color.blue)
                            Text("Kembali ke pengingat")
                                .subhead(.regular)
                                .foregroundColor(Color.neutral.tint300)
                        } .padding(.top)
                    }
                })
            }
        }
    }
}

public struct EditSuccessNotification: View {
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 241, height: 290)
                .cornerRadius(12)
                .foregroundStyle(Color.neutral.tint300)
            
            VStack (spacing: 4){
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.lima500)
                    .font(.system(size: 45))
                Text("Berhasil!")
                    .title2(.emphasized)
                    .foregroundColor(Color.lima500)
                Text("Pengingat servismu telah diubah")
                    .frame(width: 150)
                    .foregroundColor(Color.neutral.tone100)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    print("back to pengingat page")
                }, label: {
                    NavigationLink (destination: PengingatView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 164, height: 44)
                                .cornerRadius(12)
                                .foregroundColor(Color.blue)
                            Text("Kembali ke pengingat")
                                .subhead(.regular)
                                .foregroundColor(Color.neutral.tint300)
                        } .padding(.top)
                    }
                })
            }
        }
    }
}


