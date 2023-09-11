/**
 ゲームルール
 */

import SwiftUI

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

let infos = [
    Info(title: "概要", details:"""
        プレイ推奨人数：４人
        
        各プレイヤーに手札を2枚ずつ配布します。プレーヤーが順にカードを出していき、場に出ているカードと自分の手札のカードの数値の合計値が一致したとき「どてんこ」ができます。「どてんこ」をし、勝利するとそのプレイヤーが点数を獲得します。「どてんこ」され敗北したプレイヤーは点数がマイナスとなります。点数は、その回のレートと山札の下の通常カードの掛け算により計算されます。
        """, imageNames: []),
    Info(title: "使用カード", details: """
        使用カード：通常カード５２枚,特殊カード４枚
        """, imageNames: ["sride1"]),
    Info(title: "レート", details: """
        初期設定レート
        ゲーム開始前に、その回の初期レートを設定することができます。
        
        山札開帳フェーズ
        最初に場に出されたカードがレート上昇カードだった場合、その回のレートが２倍になります。レート上昇カードが連続して出た場合、その時点のレートが２倍されます。
        例) レート上昇カードが３枚連続した場合
        　　レート２倍＊レート２倍＊レート２倍＝レート８倍

        通常フェーズ
        また、以下の条件でもレートが２倍になります。
        同じ数字カードが３枚連続で場に出された時

        点数計算フェーズ
        「どてんこ」により勝利したプレイヤーは、その回のレートと山札の一番下の通常カードの値をかけた値のポイントを敗北したプレイヤーから得ることができます。
        山札の一番下のカードがレート上昇カードだった場合、その回のレートは上昇します。山札を下から捲り、通常カードになるまでこの操作は繰り返されます。

        """, imageNames: []),
]

let rules = [
    Rule(title: "準備", details:"""
         カードをシャッフルし、プレイヤーに２枚ずつ配布します。
         残りのカードは山札として、伏せた状態でテーブル中央に配置します。
         """, imageNames: ["sride2"]),
    Rule(title: "山札開帳フェーズとプレイヤーの行動", details: """
    山札はコンピュータが捲り、５秒後にプレイヤーが行動します。
    場にカードが出されたとき、全てのプレイヤーは以下の行動ができます。
    この際、最も早くカードを場に出したプレイヤーの行動が適応され、以降時計回りでゲームが進行します。


    １、場のカードと同じスーツ
       例)場のカードが♤の時、♤のスーツカードを出すことができる


    ２、場のカードと同じ数字
       例)場のカードが５の時、５の数字カードを出すことができる


    ３、自分の手札の数値を足した時、場のカードと同じ数値になる組み合わせ
       例)場のカードが１１の時、5・6の２枚の組み合わせ、１・３・７の３枚の組み合わせなどを出すことができる
    """, imageNames: ["sride3","sride4","sride5","sride6"]),
    Rule(title: "通常フェーズ", details: """
        プレイヤーは時計回りの順番で、場に出たカードに対して１、２、３の行動を繰り返します。
        １、２、３の行動ができない場合、「パス」と唱え山札からカードを１枚手札に加えます。「パス」をすると、次のプレイヤーに順番が回ります。
        もし自分の手札が７枚となり、自分のターンにカードを出せなかった場合、そのプレイヤーは「バースト」となり負けになります。「バースト」したプレイヤーは、その回のレートと山札一番下の通常カードを掛け算したポイントを全員に払います。
        """, imageNames: ["sride7"]),
    Rule(title: "どてんこ・どてんこ返し", details: """
        どてんこ
        場に出ているカードの数値と自分の全ての手札の数値を合計値が一致した場合、直前にカードを場に出したプレイヤー以外のプレイヤーは「どてんこ」をすることができます。
        「どてんこ」が発生した直前にカードを出したプレイヤーが「どてんこ返し」をできない場合、「どてんこ」したプレイヤーが勝利となり、「どてんこ」されたプレイヤーが敗北となります。勝利したプレイヤーは、その回のレートと山札の一番下の通常カードを掛け算したポイントを敗北したプレイヤーから得ます。
        
        
        どてんこ返し
        「どてんこ」されたプレイヤーの手札を全て合計した値が、「どてんこ」された場の数値と同じ場合、「どてんこ返し」をすることができます。「どてんこ」されたプレイヤーの手札を全て合計した値が、「どてんこ」された場の数値以下だった場合、「どてんこ返し」をするかその値を超えるまで、山札からカードを１枚ずつ手札に加えることができます。
        
        
        「どてんこ返し」の条件に当てはまっている場合、「どてんこ」したプレイヤー以外の全てのプレイヤーが「どてんこ返し」をすることができます。「どてんこ返し」をすると、「どてんこ」したプレイヤーが敗北となり、「どてんこ返し」をしたプレイヤーが勝利となります。「どてんこ」されたプレイヤーは、山札から１枚ずつ捲り、「どてんこ返し」のチャンスを得ます。どのプレイヤーも「どてんこ返し」ができなくなったとき、点数計算フェーズに移行します。
        """, imageNames: ["sride8","sride9","sride10"]),
    Rule(title: "しょてんこ・しょてんこ返し", details: """
しょてんこ
最初に山札のカードが場に出たとき、そのカードの数値と自分の全ての手札の数値を合計した値が一致した場合、全てのプレイヤーは「しょてんこ」をすることができます。「しょてんこ返し」がなかった場合、「しょてんこ」をしたプレイヤーの勝利となり、その回のレートと山札の一番下の通常カードを掛け算したポイントを敗北した全てのプレイヤーから得ます。


しょてんこ返し
「しょてんこ」をしたプレイヤー以外のプレイヤーは「どてんこ」の場合と同様に「どてんこ返し」と同様の行動をすることができます。これを「しょてんこ返し」と呼びます。 「しょてんこ返し」をすると、 「しょてんこ返し」をしたプレイヤーが勝利となり「しょてんこ」をしたプレイヤーの敗北となります。得られるポイントは「どてんこ」の場合と計算方法は同様ですが、全てのプレイヤーからそのポイントを得ます。
""", imageNames: ["sride11"]),
    Rule(title: "点数計算フェーズ", details:"""
        「どてんこ」により勝利したプレイヤーは、その回のレートと山札の一番下の通常カードの値をかけた値のポイントを敗北したプレイヤーから得ることができます。
        山札の一番下のカードがレート上昇カードだった場合、その回のレートは上昇します。山札を下から捲り、通常カードになるまでこの操作は繰り返されます。
        """, imageNames: ["sride12"])
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

struct InfoListView: View {
    let info: Info
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // tite
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("　　" + info.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
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
                        
                        // 文字列を改行で分割して各行を処理する
                        let lines = info.details.components(separatedBy: "\n\n")
                        
                        ForEach(lines.indices, id: \.self) { index in
                            let line = lines[index]
                            
                            let displayTextOnly = info.imageNames.isEmpty
                            
                            if displayTextOnly {
                                Text(line)
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 7)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                VStack {
                                    Text(line)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 7)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if index < info.imageNames.count {
                                        Image(info.imageNames[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 200)
                                    }
                                }
                            }
                        }
                    }
                        .padding() // 詳細横
                ))
                .background(Color.plusAutoBlack.opacity(0.3))
            }
        }
    }
}
    
struct RuleListView: View {
    let rule: Rule
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            
            // tite
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("　　" + rule.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
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

                        // 文字列を改行で分割して各行を処理する
                        let lines = rule.details.components(separatedBy: "\n\n")
                        
                        ForEach(lines.indices, id: \.self) { index in
                            let line = lines[index]
                            
                            let displayTextOnly = rule.imageNames.isEmpty
                            
                            if displayTextOnly {
                                Text(line)
                                    .font(.subheadline)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 7)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                            } else {
                                VStack {
                                    Text(line)
                                        .font(.subheadline)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 7)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if index < rule.imageNames.count {
                                        Image(rule.imageNames[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 200)
                                    }
                                }
                                
                            }
                        }
                    }
                        .padding()
                ))
                .background(Color.plusAutoBlack.opacity(0.3))
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
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.06, alignment: .leading)
                    .background(
                        Color.dtnkGreen01
                    )

                ForEach(infos.indices, id: \.self) { index in
                    InfoListView(info: infos[index])
                    if index < infos.count - 1 {
                        CustomDivider()
                    }
                }

                // section 2
                Text("  詳細ルール")
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.06, alignment: .leading)
                    .background(
                        Color.dtnkGreen01
                    )

                ForEach(rules.indices, id: \.self) { index in
                    RuleListView(rule: rules[index])
                    if index < rules.count - 1 {
                        CustomDivider()
                    }
                }
                CustomDivider()
            }
        }
        .navigationBarTitle("インフォメーション")
    }
}

/**
 ゲームルール
 */
struct GameRuleView: View {
    
    @State private var isRule1Expanded = false
    @State private var isRule2Expanded = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 広告用
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .position(x: UIScreen.main.bounds.width / 2, y: geo.size.height * 0.025)
                
                // back
                Button(action: {
                    Router().setBasePages(stack: [.home])
                }) {
                    Image(ImageName.Common.back.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .position(x: UIScreen.main.bounds.width * 0.10, y:  geo.size.height * 0.10)
                
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
                .frame(width: Constants.scrWidth, height: Constants.scrHeight * 0.65)
                .position(x:  Constants.scrWidth / 2, y: geo.size.height * 0.60)
            }
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
