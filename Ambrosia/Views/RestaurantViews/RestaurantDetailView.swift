/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 26/07/2022
 Last modified: 07/08/2022
 Acknowledgement:
 - Canvas, CodeWithChris Course
 - https://stackoverflow.com/questions/59158476/how-to-have-text-in-shapes-in-swiftui
 - https://blckbirds.com/post/stretchy-header-and-parallax-scrolling-in-swiftui/
 - https://stackoverflow.com/questions/57582653/how-to-create-tappable-url-phone-number-in-swiftui
 */

import SwiftUI

struct RestaurantDetailView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userModel: UserModel
    @StateObject var firebaseService: FirebaseService = FirebaseService.services

    @EnvironmentObject var restaurantModel: RestaurantModel
    @State var showOpenningHours = false
    @State var showReview = false
    @State var clickFavourite = false
    var btnBack: some View {
        Button(action: {
            // Sound effect
            SoundModel.clickOtherSound()
            
            self.presentationMode.wrappedValue.dismiss()
            // background music
            SoundModel.startBackgroundMusic(bckName: "home")
        }) {
            CircleButtonView(buttonImage: "arrow.left")
        }.buttonStyle(PlainButtonStyle())
    }
    
    var btnBackProgress: some View {
        Button(action: {
            // Sound effect
            SoundModel.clickOtherSound()
            
            self.presentationMode.wrappedValue.dismiss()
            // background music
            SoundModel.startBackgroundMusic(bckName: "home")
        }) {
            HStack(spacing: 10) {
                ImageSystemHier(name: "chevron.backward", color: "PrimaryColor", size: 12)
                Text("Home")
                    .font(.system(size: 16))
                    .foregroundColor(Color("PrimaryColor"))
            }

        }.buttonStyle(PlainButtonStyle())
    }
    
    var favouriteBtn: some View {
        Button(action: {
            SoundModel.clickCardSound()
            clickFavourite = firebaseService.changeFavorites(userModel: userModel, restaurant: restaurantModel.currentRestaurant ?? Restaurant(placeId: ""))

        }, label: {
            CircleButtonView(buttonImage: "heart\(clickFavourite ? ".fill" : "")")
                .onAppear() {
                    clickFavourite = userModel.isRestaurantFavorite(restaurant: restaurantModel.currentRestaurant ?? Restaurant(placeId: "click favorite")) == nil ? false : true
            }
        })
        
    }

    var body: some View {
        if restaurantModel.currentRestaurant != nil {
            GeometryReader{
                geo in
                ScrollView{
                        Image("random-eat").resizable().aspectRatio(contentMode: .fill).frame(width: geo.size.width, height: geo.size.height/2.7)

                    
                        //MARK: Rectange Resutaurant Detail Card
                    VStack(spacing:20){

                        ZStack {
                            Rectangle().foregroundColor(.white).frame(width: geo.size.width - 30, height: geo.size.height / 4.5).cornerRadius(10).shadow(color: .black.opacity(0.5), radius: 5)
                            VStack(spacing: 5) {
                                HStack {
                                    Text("⏰").font(.system(size: 12))
                                    Text(restaurantModel.currentRestaurant?.temporarilyClosed == false ? "OPEN" : "CLOSED").font(.system(size: 12)).foregroundColor(.red)

                                }
                                Text(restaurantModel.currentRestaurant?.title ?? "Mr.Sir - Mì Sir - Salad Sir - Sir nè").foregroundColor(Color("TextColor")).bold().font(.system(size: 30)).multilineTextAlignment(.center).frame(width:geo.size.width-70).lineLimit(2)
                                HStack{
                                    Text("\(restaurantModel.currentRestaurant?.distance ?? 0,specifier: "%.1f") km").font(.system(size: 14)).foregroundColor(Color("SubTextColor")).bold()
                                    Text("•").foregroundColor(Color("SubTextColor"))
                                    Text(restaurantModel.currentRestaurant?.address ?? "Sir street, Sir city, Sir ngu").foregroundColor(Color("SubTextColor")).lineLimit(1).font(.system(size: 14))
                                    
                                }.frame(width:geo.size.width-100)
                                HStack{
                                    Text("Price:").font(.system(size: 14)).foregroundColor(Color("SubTextColor"))

                                    Text(restaurantModel.type ?? "Inexpensive").font(.system(size: 14)).foregroundColor(Color("SubTextColor")).bold()
                                }

                            }.frame(width: geo.size.width - 30,height: geo.size.height / 4.5)
                        }
                        
                        // MARK: Restaurant detail Vstack section
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "clock.circle").foregroundColor(Color("PrimaryColor"))
                                    Text("Open Hours:  Monday-Sunday").font(.system(size: 14)).foregroundColor(Color("PrimaryColor"))
                                    Spacer()
                                    Button {
                                        showOpenningHours = true
                                    } label: {
                                        Text("See More").foregroundColor(Color("SecondaryColor")).font(.system(size: 14)).bold()
                                    }.sheet(isPresented: $showOpenningHours) {
                                        OpeningHoursView()
                                    }

                                }


                                Divider()
                                HStack{
                                    Image(systemName:"phone.circle.fill").foregroundColor(Color("TextColor"))
                                    Text("Phone number: \(restaurantModel.currentRestaurant?.phone ?? "No contact")").font(.system(size: 14)).foregroundColor(Color("TextColor"))
                                    Spacer()

                                    Text("Call").foregroundColor(Color("SecondaryColor")).font(.system(size: 14)).bold()



                                }
                                Divider()
                                
                                HStack{
                                    
                                    Image(systemName:"star.fill").foregroundColor(.yellow)
                                    Text("\(restaurantModel.currentRestaurant?.totalScore ?? 0,specifier: "%.1f")").font(.system(size: 14)).foregroundColor(Color("TextColor"))
                                    Text("(\(restaurantModel.currentRestaurant?.rank ?? 0 ))").font(.system(size: 12)).foregroundColor(Color("SubTextColor")).offset(x:-5)
                                    Spacer()
        //                            NavigationLink(destination: {
        //                                ReviewView()
        //                            }) {
        //                                Text("Read Reviews").foregroundColor(Color("SecondaryColor")).font(.system(size: 14)).bold()
        //                            }
                                    Button {
                                        showReview = true
                                    } label: {
                                        Text("See More").foregroundColor(Color("SecondaryColor")).font(.system(size: 14)).bold()
                                    }.sheet(isPresented: $showReview) {
                                        ReviewView()
                                    }

                                }
                                Divider()

                                VStack(alignment: .leading) {
                                    if (restaurantModel.currentRestaurant?.serviceOptionsArr.count != 0){
                                        Breadcrumbs(options:"Service")
                                    }
                                    if (restaurantModel.currentRestaurant?.diningOptionsArr.count != 0){
                                        Breadcrumbs(options:"Dining")
                                    }
                                    if (restaurantModel.currentRestaurant?.paymentsArr.count != 0){
                                        Breadcrumbs(options:"Payment")
                                    }
                                    if (restaurantModel.currentRestaurant?.planingArr.count != 0){
                                        Breadcrumbs(options:"Planing")
                                    }

                                }
                                
                                Divider()
                                
                                VStack(alignment:.leading){
                                    Text("🎖 User Ratings:")
                                    RatingContributionView(rating: Int(restaurantModel.currentRestaurant?.totalScore ?? 0))

                                }

                            }
                        
                    }.padding().offset(y:-100)
          

                }
            }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack, trailing: favouriteBtn)


        }
        else {
            ProgressView() {
                VStack {
                    GifView(name: "nothing").offset(y: 120)
                }
            }
                .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBackProgress)
                .onAppear() {
                    // background music
                    SoundModel.startBackgroundMusic(bckName: "detail")
                }
        }
    }




}


//struct RestaurantDetailPreview: PreviewProvider {
//    static var previews: some View {
//        RestaurantDetailView()
//            .environmentObject(RestaurantModel())
//    }
//}
