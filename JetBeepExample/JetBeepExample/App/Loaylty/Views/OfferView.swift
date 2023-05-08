//
//  OfferView.swift
//  JetBeepExample
//
//  Created by Max Tymchii on 28.03.2023.
//  Copyright © 2023 Max Tymchii. All rights reserved.
//

import SwiftUI
import JetBeepFramework

protocol OfferViewProtocol {
    var title: String { get }
    var subtitle: String { get }
    var price: Int { get }
    var oldPrice: Int { get }
    var thumbnailUrl: String? { get }
    var daysLeft: Int? { get }
    var isPersonalised: Bool { get }
}

private struct FakeOffer: OfferViewProtocol {
    let title: String
    let subtitle: String
    let price: Int
    let oldPrice: Int
    let thumbnailUrl: String?
    let daysLeft: Int?
    let isPersonalised: Bool

    static func fakeOffer() -> FakeOffer {
        return FakeOffer(title: "Title", subtitle: "Description", price: 100, oldPrice: 200, thumbnailUrl: "https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387__480.png", daysLeft: 10, isPersonalised: true)
    }
}

extension LinearGradient {
    private static let firstColor = UIColor.primaryColor.withAlphaComponent(0.3).toColor()
    private static let secondColor = UIColor.secondaryColor.withAlphaComponent(0.5).toColor()
    
    static let personalised = LinearGradient(gradient: Gradient(colors: [ firstColor, secondColor]),
                                             startPoint: .topLeading, endPoint: .bottomTrailing)

}

struct OfferView: View {
    let offer: OfferViewProtocol

    var body: some View {
        HStack(spacing: 16) {
            thumbnailView
                .padding(.leading, 8)
            VStack(alignment: .leading, spacing: 8) {
                titleView
                priceView
                daysLeftView
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(offer.isPersonalised ? LinearGradient.personalised : nil)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .cornerRadius(8)
    }

    private var thumbnailView: some View {
        if let imageUrl = offer.thumbnailUrl,
           let url = URL(string: imageUrl) {
            if #available(iOS 15.0, *) {
                return AnyView(
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                )
            } else {
                return AnyView(
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                )
            }
        } else {
            return AnyView(
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            )
        }
    }

    private var titleView: some View {
        Text(offer.title)
            .font(.headline)
    }

    private var priceView: some View {
        HStack(spacing: 8) {
            Text("\(offer.oldPrice ) $")
                .strikethrough()

            Text("\(offer.price) $")
                .font(.headline)
                .foregroundColor(.green)
        }
    }

    private var daysLeftView: some View {
        if let daysLeft = offer.daysLeft {
            return Text("\(daysLeft) days left")
                .font(.footnote)
                .foregroundColor(.red)
        } else {
           return Text("")
        }
    }
}

struct OfferView_Previews: PreviewProvider {
    static var previews: some View {
        OfferView(offer: FakeOffer.fakeOffer())
    }
}
