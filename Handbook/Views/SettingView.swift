import Foundation
import SwiftUI

private let ContributorsText = String(format: "特别感谢以下朋友的贡献: %@",
                                      Contributors.isEmpty ? "欢迎你来贡献！" : Contributors.joined(separator: ", "))

struct SettingView: View {

    @Environment(\.dismiss)
    private var dismiss

    @AppStorage("defaultGroupingMethod", store: .standard)
    private var groupingMethod = LawGroupingMethod.department

    @AppStorage("defaultSearchHistoryType")
    private var searchHistoryType = SearchHistoryType.share

    @State
    private var showSafari: Bool = false

    @State
    private var url: String?
    
    var body: some View {
        List{
            Section(header: Text("内容来源"), footer: Text("如果您发现了任何错误，包括但不限于排版、错字、缺失内容，请使用以下联系方式告知开发者，以便修复")){
                Link(title: "国家法律法规数据库", url: "https://flk.npc.gov.cn")
                Link(title: "最高人民法院", url: "https://www.court.gov.cn")
            }
            Section(header: Text("偏好设置")) {
                HStack {
                    Text("分组方式")
                    Spacer()
                    Picker("分组方式", selection: $groupingMethod) {
                        ForEach(LawGroupingMethod.allCases, id: \.self) {
                            Text($0.rawValue)
                       }
                    }
                    .pickerStyle(.menu)
                }
                HStack {
                    Text("搜索历史")
                    Spacer()
                    Picker("搜索历史", selection: $searchHistoryType) {
                        ForEach(SearchHistoryType.allCases, id: \.self) {
                            Text($0.rawValue)
                       }
                    }
                    .pickerStyle(.menu)
                }
                NavigationLink {
                    FontSettingView()
                        .navigationBarTitle("字体设置")
                } label: {
                    Text("字体设置")
                }
            }
            Section(header: Text("开发者")){
                Text("@RanKKI")
                Text(DeveloperMail)
                    .foregroundColor(.accentColor)
                    .underline()
                    .onTapGesture {
                        OpenMail(subject: "问题反馈：", body: "")
                    }
            }
            Section(footer: Text("自豪地采用 SwiftUI")){
                Button("给 App 评分！") {
                    if let url = URL(string: "itms-apps://apple.com/app/id1612953870") {
                        UIApplication.shared.open(url)
                    }
                }
                Text("[在 GitHub 上贡献](https://github.com/RanKKI/LawRefBook)")
            }
            Section(header: Text("其他")) {
                NavigationLink {
                    LicenseView()
                } label: {
                    Text("LICENSE")
                }
            }
            Text(COPYRIGHT_DECLARE)
                .listRowBackground(Color.clear)
                .font(.footnote)
            
            Text(ContributorsText)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .multilineTextAlignment(.leading)
                .font(.footnote)
                .padding(.top, 16)

            Section {
                InAppPurchaseView()
            } header: {
                Text("请开发者喝点什么")
            } footer: {
                Text("如果你觉得这个 App 做得还不错，对你有所帮助的话，请开发者喝点什么吧。")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                CloseSheetItem() {
                    dismiss()
                }
            }
        }
    }
}


fileprivate struct Link: View {
    
    var title: String
    var url: String
    
    @State
    private var showSafari = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text(url)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "arrow.turn.up.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showSafari.toggle()
        }
        .foregroundColor(.accentColor)
        .fullScreenCover(isPresented: $showSafari, content: {
            SFSafariViewWrapper(url: URL(string: url)!)
        })
    }
}
