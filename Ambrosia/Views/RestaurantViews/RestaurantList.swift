//
//  RestaurantList.swift
//  Ambrosia
//
//  Created by Nhung Tran on 09/09/2022.
//

import SwiftUI

struct RestaurantList: View {
    @EnvironmentObject var restaurantModel: RestaurantModel
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Popular")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                // MARK: display list of popular restaurants horizontally
                ScrollView {
                    LazyVStack {
                        ForEach(restaurantModel.restaurants, id: \.place_id) { res in
                            NavigationLink(destination: RestaurantDetailView(rest: res)) {
                                RestaurantCard(rest: res)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RestaurantList_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantList()
    }
}
