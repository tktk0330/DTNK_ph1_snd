/**
 ゲームルール
 */

import SwiftUI

/**
 ゲームルール
 */
struct GameRuleView: View {
    
    @State private var isRule1Expanded = false
    @State private var isRule2Expanded = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // back
                BackButton(backPage: .home, geo: geo)
                
                // title
                Text("Rule")
                    .font(.custom(FontName.font01, size: 45))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding(5)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.15)

                // 内容
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        BorderedListView(content: AnyView(
                            RuleScreen()
                        ))
                    }
                }
                .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.7)
                .position(x:  Constants.scrWidth / 2, y: geo.size.height * 0.60)
            }
        }
    }
}

// スクロール部分
struct RuleScreen: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // section 1
                Text("  基本ルール")
                    .font(.custom(FontName.MP_Bl, size: 20))
                    .foregroundColor(Color.white)
                    .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.06, alignment: .leading)
                    .background(Color.white.opacity(0.3))

                ForEach(ruleInfo.indices, id: \.self) { index in
                    InfoListView(info: ruleInfo[index])
                    if index < ruleInfo.count - 1 {
                        CustomDivider()
                    }
                }

                // section 2
                Text("  詳細ルール")
                    .font(.custom(FontName.MP_Bl, size: 20))
                    .foregroundColor(Color.white)
                    .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.06, alignment: .leading)
                    .background(Color.white.opacity(0.3))

                ForEach(optionInfo.indices, id: \.self) { index in
                    InfoListView(info: optionInfo[index])
                    if index < optionInfo.count - 1 {
                        CustomDivider()
                    }
                }
                CustomDivider()
            }
        }
        .navigationBarTitle("インフォメーション")
    }
}

struct InfoListView: View {
    let info: RuleDetail
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // title
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("　　" + info.title)
                        .font(.custom(FontName.MP_EB, size: 15))
                        .foregroundColor(.white)
                        .frame(height: 50)
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .frame(width: 50)
                }
            }
            if isExpanded {
                BorderedListView(content: AnyView(
                    VStack(alignment: .leading, spacing: 7) {
                        
                        ForEach(info.details.indices, id: \.self) { index in
                            let detail = info.details[index]
                            
                            switch detail {
                            case .item(let item):
                                Text(item)
                                    .font(.custom(FontName.MP_EB, size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 7)
                                    .padding(.leading, 10)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineSpacing(10)
                            case .text(let text):
                                Text(text)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 7)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineSpacing(10)
                            case .image(let imageName):
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 200)
                                    .padding(.top, 7)
                            case .line1:
                                CustomLine()
                            case .item2(let item):
                                Text(item)
                                    .font(.custom(FontName.MP_EB, size: 18))
                                    .foregroundColor(Color.yellow)
                                    .padding(.top, 7)
                                    .padding(.leading, 10)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineSpacing(10)
                            case .cardView(let name):
                                RuleCardImage(cardImages: name)
                            case .customView(let view):
                                view
                            }
                        }
                    }
                        .padding()
                ))
                .background(Color.black.opacity(0.3))
            }
        }
    }
}

struct Info: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let imageNames: [String] // 画像ファイル名の配列
}

struct Rule: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let imageNames: [String] // 画像ファイル名の配列
}

struct RuleDetail: Identifiable {
    let id = UUID()
    let title: String
    let details: [Detail]
}

enum Detail {
    case item(String)
    case text(String)
    case image(String)
    case line1
    case item2(String)
    case cardView([String])
    case customView(AnyView)
}

let ruleInfo = [
    RuleDetail(title: "概要",
               details: [
                .item("どてんことは"),
                .line1,
                .text("""
                        ・ プレイ推奨人数は4人（2〜8人でも可能）
                        ・ 使用カードは52〜56(Jorkerは４枚まで追加可能)
                        ・ 自分のターンになったら条件に合うカードを出したり、パスをする。（詳しくはこちら）
                        ・ 場の数字と手札の合計数字が一致した時「どてんこ」と宣言し、勝者となることができる。「どてんこ」を宣言された時に、場の一番上のカードを出していた人が負けになる。
                        ・ ルールのカスタマイズが可能。（詳しくはこちら）
                        """),
                .item("流れ"),
                .line1,
                .text("""
                    １　各プレイヤーに手札を２枚ずつ配布する。
                    ２　山札の一番上のカードをめくり、場の初めのカードを決める。
                    ３　出せるカードがある場合は、早いもの順でカードを出す。1番はじめにカードを出した人から時計回りにゲームを開始する。
                    　※ 1番初めの山札からめくったカードに対して「どてんこ」（この場合は「しょてんこ」という）した場合、その人以外全員が敗者となる。
                    ４　ターンが回ってきたプレイヤーは以下の行動ができる。
                    　①　出せるカードがあるので出す
                    　②　出せるカードがあるけど、カードを引き、出す
                    　③　出せるカードがあるけど、カードを引き、パス
                    　④　出せるカードがないので、カードを引き、出せるようになったので出す
                    　⑤　出せるカードがないので、カードを引き、出せるようになったけどパス
                    　⑥　出せるカードがないので、カードを引き、出せるようにならなかったのでパス
                    　※ カードを出せるパターンについてはこちら。
                    　※ カードを引けるのは１ターン１枚です。
                    　※ カードを引かずにパスはできません。
                    ５　山札がなくなったら、場の1番上のカードだけを残し、他を山札に加えて再生成する。
                    ６　誰かが「どてんこ」をしたらチャレンジフェーズへ移動する。
                    　※ 「バースト」場合は得点計算フェーズへ移動する。
                    ７　チャレンジフェーズではどてんこのチャンスがある人が、山札からカードを１枚ずつ引いていく。全てのプレイヤーのチャンスがなくなったら、点数計算フェーズへ移動する。（詳しくはこちら）
                    ８　点数計算フェーズではそのラウンドでのスコアを確定させる。山札の１番下のカードを確認する。特殊カードが出た場合レート上昇や勝敗の逆転が発生し、特殊カード以外のカードになるまでめくる。カード確定後、スコアを計算し次のゲームへ。（詳しくはこちら）
                    """),
                .item("カードの出し方"),
                .line1,
                .text("""
                      自分のターンでは場のカードに対し以下の条件でカードを出すことができる。
                    
                    < 1枚で出す場合 >
                    ・ 場のカードと同じ数字である。
                    ・ 場のカードと同じスートである。
                    
                    < 複数枚で出す場合 >
                    ・ 場のカードの数字と出すカードの数字の合計が同じ。
                    """),
                .customView(AnyView(Patern01())),
                .text("""
                    ・ 場のカードと出すカードの数字が全て同じ。
                    """),
                .customView(AnyView(Patern02())),
                .text("""
                    ・ 場のカードと出す一番下のカードのスートが同じ　＋　出すカードの数字が全て同じ。
                    """),
                .customView(AnyView(Patern03())),
               ]
              ),
    RuleDetail(title: "イベント",
               details: [
                .item("イベント"),
                .line1,
                .item2("どてんこ"),
                .text("""
                    ・ 誰かが出した場のカードの数字と、自分の手札全ての合計数字が一致した時「どてんこ」と宣言できる。
                    勝者：どてんこした人
                    敗者：どてんこされたカードを出した人
                    """),
                .image(ImageName.Rule.dotenko.rawValue),
                .item2("しょてんこ"),
                .text("""
                    ・ １番はじめに山札から捲られたカードの数字と、自分の手札全ての合計数字が一致した時「しょてんこ」と宣言できる。
                    勝者：しょてんこした人
                    敗者：その他全員
                    例画像
                    
                    """),
                .item2("どてんこ返し（しょてんこ返し）"),
                .text("""
                    ・ 誰かが「どてんこ」を宣言した際、別のプレイヤーも「どてんこ」できる状態であった場合、「どてんこ返し」と宣言し、勝者を上書きすることができる。
                    この場合、勝者が最後に「どてんこ返し」した人、敗者が１つ前に「どてんこ」した人である。
                    勝者：１番最後に「どてんこ」した人
                    敗者：１つ前に「どてんこ」した人
                    例画像
                    
                    """),
                .item2("チャレンジ"),
                .text("""
                    ・ どてんこが確定した時、チャレンジフェーズに移る。どてんこが発生した場の数字に対し、自分の手札の合計が小さい場合、チャレンジに参加することができまる。どてんこした人から時計回りにチャレンジを実施する。チャレンジする人に対し、山札の上からカードを１枚ずつ引く。新規に追加されたカードによって場のカードと手札の合計が一致した場合、「どてんこ返し」が発生する。手札の数字の合計が場の数字より大きくなるまで（どてんこの可能性がなくなるまで）山札から引き続ける。この際「どてんこ返し」された人は、手札をリセットし、チャレンジに参加する。誰もどてんこチャンスがなくなった時、チャレンジフェーズが終了し、点数計算フェーズに移行する
                    例画像
                    
                    """),
                .item2("バースト"),
                .text("""
                    ・ 手札が７枚の時パスをするとバーストとなり自分の１人負けとなる。
                    勝者：その他全員
                    敗者：自分
                    
                    """),
                .item2("ラウンドスコアの決定"),
                .text("""
                    点数計算フェーズでは、ラウンドスコアを計算する。スコアは下記の掛け算によって算出。
                      ① 初期レート
                      ② 上昇レート
                      ③ 山札裏のカード数字
                    　※ 特殊カードによってレートが上昇するイベントがある。
                    例画像
                    
                    """),
                ]
               ),
    RuleDetail(title: "カード",
               details: [
                .item("使用カード"),
                .line1,
                .item2("Jorker"),
                .cardView([ImageName.Card.whiteJorker.rawValue, ImageName.Card.blackJorker.rawValue]),
                .text("""
                手札 ： -1 0 1のいずれかとして扱うことができる
                                
                """),
                .customView(AnyView(Patern00())),
                .text("""
                
                ゲーム開始フェーズ ： レートを✖︎２する
                点数計算フェーズ ： レートを✖︎２する
                
                """),
                .item2("１・２"),
                .cardView([ImageName.Card.spade1.rawValue, ImageName.Card.diamond1.rawValue, ImageName.Card.club1.rawValue, ImageName.Card.heart1.rawValue, ImageName.Card.spade2.rawValue, ImageName.Card.diamond2.rawValue, ImageName.Card.club2.rawValue, ImageName.Card.heart2.rawValue]),
                .text("""
                手札 ： その数字として扱う
                ゲーム開始フェーズ ： レートを✖︎２する
                点数計算フェーズ ： レートを✖︎２する
                
                """),
                .item2("♠️３・♣️３"),
                .cardView([ImageName.Card.spade3.rawValue, ImageName.Card.club3.rawValue]),
                .text("""
                手札 ： 3として扱う
                ゲーム開始フェーズ ： 3として扱う
                点数計算フェーズ ： 勝敗を無条件で逆転させる
                
                """),
                .item2("♦️３"),
                .cardView([ImageName.Card.diamond3.rawValue]),
                .text("""
                手札 ： 3として扱う
                ゲーム開始フェーズ ： 3として扱う
                点数計算フェーズ ： 数字を30として扱う
                    
                その他のカードはそのカードの意味のまま利用する。
                """),
               ]
               ),
]

let optionInfo = [
    RuleDetail(title: "ゲーム数",
               details: [
                .text("""
                    ラウンド(1/2/3/5/10)を選べます。
                """),
                ]
               ),
    RuleDetail(title: "ジョーカー枚数",
               details: [
                .text("""
                    Jorkerの枚数(0/2/4)を選べます。
                """),
                ]
               ),
    RuleDetail(title: "レート",
               details: [
                .text("""
                   初期レート(1/2/5/10/50/100)を選べます。
                """),
                ]
               ),
    RuleDetail(title: "スコア上限",
               details: [
                .text("""
                    １ラウンドのスコア上限(あり/なし)を選べます。
                """),
                ]
               ),
    RuleDetail(title: "重ねレートアップ",
               details: [
                .text("""
                    場に同じカードが連続で重なった時(3/4/なし)のレートアップを選べます。
                """),
                ]
               ),
    RuleDetail(title: "デッキサイクル",
               details: [
                .text("""
                    デッキリミット(1/3/5/なし)を選べます。
                """),
                ]
               ),
    ]

struct BorderedListView<Content: View>: View {
    let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
             .frame(maxWidth: .infinity)
        }
    }
}

// 罫線
struct CustomDivider: View {
    var body: some View {
        Divider()
            .frame(height: 3)
            .background(Color.plusAutoBlack.opacity(0.3))
    }
}

struct CustomLine: View {
    var body: some View {
        HStack() {
            Spacer()
            Rectangle()
                .fill(Color.yellow)
                .frame(width: Constants.scrWidth * 0.9, height: 1)
            Spacer()
        }
    }
}

struct RuleCardImage: View {
    let cardImages: [String]
    var body: some View {
        ZStack {
            HStack(spacing: -10) {
                ForEach(cardImages, id: \.self) { item in
                    RuleCardView(cardName: item)
                }
            }
        }
    }
}

// Jorkerパターン
struct Patern00: View {
    var body: some View {
        
        HStack(spacing: 20) {
            HStack(spacing: -10) {
                RuleCardView(cardName: ImageName.Card.blackJorker.rawValue)
                RuleCardView(cardName: ImageName.Card.club1.rawValue)
                RuleCardView(cardName: ImageName.Card.heart7.rawValue)
            }
            VStack() {
                Text("例）7, 8, 9のいずれかとして扱える")
                    .font(.system(size: 15))
                    .foregroundColor(Color.white)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(.yellow)
                .frame(width: Constants.scrWidth * 0.8, height: 100)
        )
        .padding(20)
    }
}

//　提出説明１
struct Patern01: View {
    var body: some View {

        HStack() {
            Spacer()
            RuleCardView(cardName: ImageName.Card.diamond13.rawValue)
            Spacer()
            HStack() {
                HStack(spacing: -15) {
                    RuleCardView(cardName: ImageName.Card.diamond6.rawValue)
                    RuleCardView(cardName: ImageName.Card.spade7.rawValue)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 3)
                )
                RuleCardView(cardName: ImageName.Card.club1.rawValue)
                RuleCardView(cardName: ImageName.Card.heart10.rawValue)
            }
            Spacer()
        }
    }
}

//　提出説明２
struct Patern02: View {
    var body: some View {

        HStack() {
            Spacer()
            RuleCardView(cardName: ImageName.Card.diamond13.rawValue)
            Spacer()
            HStack() {
                HStack(spacing: -15) {
                    RuleCardView(cardName: ImageName.Card.spade13.rawValue)
                    RuleCardView(cardName: ImageName.Card.club13.rawValue)
                    RuleCardView(cardName: ImageName.Card.heart13.rawValue)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 3)
                )
                RuleCardView(cardName: ImageName.Card.club1.rawValue)
            }
            Spacer()
        }
    }
}

//　提出説明３
struct Patern03: View {
    var body: some View {

        HStack() {
            Spacer()
            RuleCardView(cardName: ImageName.Card.diamond13.rawValue)
            Spacer()
            HStack() {
                HStack(spacing: -15) {
                    RuleCardView(cardName: ImageName.Card.diamond5.rawValue)
                    RuleCardView(cardName: ImageName.Card.club5.rawValue)
                    RuleCardView(cardName: ImageName.Card.heart5.rawValue)
                }
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 3)
                )
                RuleCardView(cardName: ImageName.Card.club1.rawValue)
            }
            Spacer()
        }
    }
}

// カード
struct RuleCardView: View {
    let cardName: String
    var body: some View {
        Image(cardName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50)
    }
}

