//
//  InformationView.swift
//  itfood_del
//
//  Created by Chi Tang Sun on 2020/3/5.
//  Copyright © 2020 dp103g3. All rights reserved.
//

import SwiftUI

struct InformationView: View {
        
    var body: some View {
        ScrollView{
         VStack{
            Text("發佈時間：2020年")
                .padding(.top,20)
                .foregroundColor(Color.colorTextOnP)
            Text("在您使用itfood的產品和服務前，請詳讀以下的服務條款。不論是透過網站或是手機APP，只要您使用產品和服務，即表示您同意本條款。").padding(20)
                .foregroundColor(Color.colorTextOnP)
            Text("""
                介紹　我們是itfood，此服務係由 Dp103  G3 提供。
            定義
            本網站所提及的『合約』，係指使用者對於提供予服務之條款、訂單方式與付款方式；
            『隱私權條款』係指本網站如何處理客戶於使用本網站服務時，所蒐集到及留存的個人隱私資料；
            本文中提到的『您』意指所有使用 itfood這個網路平台以及任何訂購商品或服務的人；
            本文中的『我』、『我們』、和 『itfood』代表本公司；
            『商品』指任何本網站所提供以及出售的商品；
            『服務』指任何經由本網站所提供的服務；
            『合作商家』係指第三方公司同意提供商品和服務予我方公司；
            『食物外送』係指食物(易腐貨物)透過任何形式的送貨方式送達至消費者所指定地址；
            『網站』代表本網站http://www.itfood.com.tw或手機應用程式提供的商品與服務。
            訂單
            自我們的平台完成訂購後，即達成委託itfood為您處理訂購餐點/商品事宜的合約，包括將您的訂單轉介給合作餐廳及店家。
            當您自美食外送平台下訂單，店家將負責準備您的訂單餐點，並交由itfood運送。若因餐點內容錯誤、傾覆等致須要求退款，請您聯繫itfood客服人員。您同意您於訂貨完成時所提供的資料為真實、準確且完整。同時保證您於訂購時所提供的信用卡或銀行卡持卡人為您本人，並且確認和保證您有足夠的資金支付您的訂單。若須退款時，您亦保證您所提供之帳戶資訊為您本人所有且正確無誤。
            當您自熊貓商城訂購非美食之商品下訂單且付款方式為線上付款，店家將負責準備您的訂單商品，並交由將由itfood負責處理退款運送，但關於訂購餐點/商品的準備則交由各店家負責，itfood將依據各店家之退換貨規範處理退款。若您消費者於收到商品後7日猶豫期內若有退貨需求，請先與您請先與下訂單之店家確認是否能退貨。若可退貨，您須將商品回復至原始出貨時狀態，，若可退貨，請攜帶商品及、APP訂單紀錄、發票單據(免用統一發票店家除外)，前往該下訂店家提出退貨需求並索取退貨單，接著將退貨單回傳至itfood的服務信箱support@itfood.tw。若您所訂購的商品有瑕疵，，經itfood確認退貨資訊無誤，我們將完成退款給您。您同意您於訂購時訂貨完成時所提供的資料為真實並保證這些資訊在訂貨完成時細節為、準確且及完整。同時可以保證您所提供的信用卡或銀行卡持卡人為您本人，並且確認和保證您有足夠的資金支付您的訂單。若須退款時，您亦保證您所提供之帳戶資訊為您本人所有且正確無誤。
            提醒您，原則上，以下所列商品不得退貨退款：易於腐敗、保存期限較短或解約時即將逾期之商品(例如現做的食物、蛋糕、麵包、蔬果、牛奶等)；依您要求所為之客製化給付(例如為您量身訂做的服飾、首飾、印製之相片等)；報紙、期刊或雜誌；經您拆封之影音商品或電腦軟體(例如音樂CD、影片DVD、電腦軟體等)；經消費者事先同意始提供之非以有形媒介提供之數位內容或一經提供即為完成之線上服務；已拆封之個人衛生用品等(例如內衣褲、泳裝、塑身衣、襪子、除毛刀、刮鬍刀等)。
            請注意本公司所提供的產品有可能只適合某特定年齡層所使用，您應該要詳細檢查所訂購之產品適合將來使用者。
            當您從本平台訂餐時您可能會需要提供電子信箱及密碼，您必須確保您的個人資料和密碼等資料安全並且確定您不提供這些資料給第三方。
            在我們的權利內，採行所有合理的注意事項以保存您的訂單和支付安全的所有細節。如果第三方在未授權的情況使用您的資料使用本網站，並且在我們沒有疏忽的情況下，我們不負責您可能遭受的損失。
            您任何的訂單是我們以及任何有參與的餐廳/店家共同負責，我們將確認其產品的安全性和運送服務。當您確認並且送出訂單，我們將發送一封郵件來通知我們確實收到此訂單。此郵件是自動發送給您來確認訂單的詳細資訊確認信。當您發現您的訂單有錯誤時，請馬上透過線上客服通知我們。收到我們確認訂單的郵件並不代表我們或參與的餐廳/店家會完成訂單。當我們收到確認訂單郵件時，我們將會確認發出產品存貨及運送量調查。
            如果食物及其運送量被其它餐廳/店家確認過後，參與餐廳/店家便會接受合約並通知itfood，如果其訂單資料正確，那其合約、商品、或服務，將會使用簡訊/APP/電子郵件通知來確認訂單。
            當訂單或產品是由itfood提供或訂購時，itfood會同時或分開的確認其存貨和運送能力。
            確認的電子郵件將會提供交貨細節，包括時間、商品交貨價格，訂購的商品和服務。
            如果外賣或商品存貨不足或是無法運送，我們將以電子郵件/APP通知您。
            價錢和付款
            在網站上列出的所有價格都是正確的，然而，我們仍然保有在未來改變這些價格的權利。最後顯示的訂單價格已經包含所有銷售稅和外送費。我們同時還保留改變在網站上出售的商品及提供的服務，同時也能停止所列餐館之商品及服務權利。
            所有列在外送服務內的價格是由合作之餐廳/店家或第三方在上市時所提供。我們會維持最新的資訊。如果您訂購的商品上市的價格和餐廳/店家更新後的價格有差異，我們將與您聯繫，並且詢問您是否要取消訂單。
            所有由第三方所提供的價錢都是由餐廳/店家提供，我們盡力確保餐點/商品價格與店內販售時價格一致，若有價格不同情況則以「非店內價」標示，若消費者有任何意見，請發信至itfood的服務信箱feedback@itfood.tw。
            當您在下訂單時，產品或是服務的總價格，包括送貨及其他費用，將會顯示在網站上。費用必須完全以現金或網上付款方式付清，當貨品送達或服務提供時。
            如果您選擇在網上支付，您必須在線上訂購前付款。為了確保網上購物的安全，您的銀行卡/信用卡的詳細資料將被加密，以防止他人瀏覽或是在網上傳送的可能性。
            如果您選擇在網上支付並透過您的銀行卡/信用卡支付款項， itfood 並不會額外收取任何手續費，但少部分銀行卡/信用卡發卡銀行會針對於國外以新台幣交易時，收取國外交易授權結匯手續費，此筆費用為發卡銀行所收取，若有任何疑問可來信至 itfood的服務信箱support@itfood.tw。


            外送
            在訂貨時所提供的交貨時間僅為大約時間，視情形而有不同。商品將會被運送到您在訂貨時所指定的時間和地址。
            當送貨服務由itfood提供時，我們將會注意並準時地提供其服務。不過若有任何延遲交付的情況發生時，我們仍然有在未來保留處理這種狀況的權利。
            所有的訂單將由itfood外送團隊負責。我們及任一合作餐廳/店家會極力地確保交貨時間，如果商品不在我們估計的時間內到達，請先聯繫itfood線上客服，我們將盡力確保你能儘快收到商品。
            在晚交貨的情況下，itfood將不會退還或取消運費。
            交貨完成時，所有食品和商品的任何風險與責任將同時轉移給您。
            如果您不能準時接受我們準備的交貨或是您沒有給予足夠的說明或授權時，此貨物將被視為已交貨，所有責任則轉移到您的身上。任何儲存、保險及其他因素使我們無法交貨給您而產生的費用應由您全額賠償。
            您必須確保運送到的食物或是貨物的安排，包括交貨地點是否可以通行是否安全等。我們不能負責在貨物因為您未能提供適合方式或是安排交付而造成的任何成本或費用承擔等責任的損害。
            合作餐廳/店家將準備您的訂單。
            為給您提供產品，您的訂單需提供您要求的交貨地點。
            交付餐廳/店家確認是否能在時間內準備餐點/商品。
            並通知您如果itfood或餐廳/店家無法在預計的交貨時間內送達。
            參與餐廳/店家和我們將不承擔任何損失、費用，或由延遲交付所產生的費用給您。
            請注意，參與餐廳/店家不一定能外送到某些區域。如果是這樣的情況下，我們將使用您供給我們的聯絡方式通知您，並提供您取消訂單或是改變外送地址等服務。
            當外送夥伴將餐點/商品送至消費者訂餐地點後，將撥打電話通知消費者取餐，基本上我們會於消費者訂餐地點等待十分鐘，若於時間內皆無獲得消費者回應，為確保服務和餐點/商品品質，外送夥伴將離開執行下張單派送。但因此筆訂單已出餐/出貨，視同消費者放棄該餐點/商品，故該單無法退費。
            當訂餐選擇現金付款時，請主動與外送夥伴當面點清，一旦任一方離開後，itfood 將不承擔任何後續清點金額之責任。

            取消
            你可於訂單成立後五分鐘內取消訂單。請注意，由於我們的合作餐廳/店家有可能在訂單成立後短時間內開始準備你的餐點/商品，如遇餐廳/店家已開始準備你的餐點/商品，則此訂單將無法取消且無法退款。當發生以上狀況且你選擇現金支付此筆訂單，我們將依舊外送此筆訂單至你指定的位置並向你收取現金；如你未收取此筆訂單，未來你將無法選擇使用現金付款功能。
            當因各種因素商品不再供應時，我們可以取消合約。我們將通知您並且全額退還此費用。
            如果您在時間內取消您的訂單且我們亦取得合作餐廳的同意或是收到您的商品退貨單，我們將會在14天內全額退還，其中包括服務費用。
            萬一合作的餐廳/店家提供了錯誤的商品，您可以拒絕接受此商品，而將會全額退還該商品費用。但如果您有特殊餐點/商品備註，請了解餐廳/店家可能無法完全滿足您的特殊需求，請您下單前選擇更適合您的餐點/商品或餐廳/店家。
            您的資訊
            如果我們要求您提供資訊以完成食品/商品的外送，您同意提供給我們準確和完整的資訊。
            您授權我們使用、儲存或以其他方式處理您的個人資訊，以便提供外賣、商品或服務。其目的可能包含為了提供服務（外送、商品等）和您可能感興趣的資訊或可能是法律上的需要，我們將提供您的個人資信給第三方。更多的資訊可以在我們的隱私條款中找到。
            您有權要求我們所持有的您的個人資料副本。如果有需要，請與我們聯絡。
            連接網站　可能有我們相信您會感興趣的網站連結到第三方的網站。我們並不對該網站的商品或服務負責，我們也無法控制該網站的內容與是否可用。我們也不對他們可提供給您的商品、服務、或是該網站的內容負責。
            我們非常重視您的意見，並且希望會在五天內給予您回應。所有的意見可寄到itfood的服務信箱support@itfood.tw。
            責任限制
            我們已採取謹慎的措施以確保本網站提供的信息是正確無誤的。我們對可能發生的任何錯誤或遺漏深表歉意。我們不能保證使用本平台時將會沒有錯誤或符合您的目的，我們將即時修正。我們也無法保證服務器內部含病毒或該網站的可靠性等，我們在此持保留權利並不做任何擔保。
            通過接受這些使用條款，您同意免除我們及任何餐廳/店家因提供的信息錯誤對您所造成之困擾及責任，如遇我們及任何餐廳/店家提供之信息有誤，煩請您不吝於透過我們的聯絡信箱告知我們，我們將盡快調整相關錯漏。我們不承擔任何現行法律允許範圍下有關的服務和商品供應之責任。這並不影響您作為消費者的法定權利。如果我們發現任何損失和傷害承擔責任，這種責任是在您所支付金額的有關商品和服務。我們將不承擔您可能得到的間接損失，包括利潤等。此責任限制並不適用於人身傷害或死亡所產生的直接損失。
            我們不承擔因我們的網頁而造成的任何延誤、故障、錯誤、遺漏或丟失傳送的資料，轉發的病毒或其他汙染，破壞屬性的任何責任。
            我們恕不為任何店家的延誤、疏忽，與因不可抗力因素影響造成的延遲或疏忽負責。
            在不可抗力情形下，致我們因此無法完全盡我們在本合約下之義務，而我們有超過一位使用者提供相同或類似的訂單，我們有絕對權利決定我們將完成的訂定及其範圍。
            我們所售出的產品僅提供給個人或消費者使用。因此，訂單中的任何間接損失、數據遺失、收入或利潤的損失、損失的財產或使用本網站而產生的第三方索賠損失的損害的責任，我們恕不承擔。
            我們已採取了可以合理防止網路詐騙的方式，並確保您私人資料的安全。但我們恕不因重大事件﹝如因電腦伺服器的受損或破壞、第三方的違約﹞負責。
            對於任何超出合理控制範圍而發生的不可抗力之事件如戰亂、暴動、民變、政府命令或第三方行為等，itfood恕不為此所造成之延遲送達甚至於無法送達的非正常營運情況負責。
            一旦有濫用折扣優惠碼或其他可疑的詐騙情形發生，itfood保有立即停止並拒絕再次提供店家(或消費者)任何服務之權利。此外，itfood亦保有對違規或濫用者求償之權利。
            itfood有權在任何時間以及不另行告知的情況下撤消活動優惠。
            保險
            我們與富昇保代合作提供食品中毒補償保險，如您有保險需求，登錄即可獲贈，請點選連結: https://www.efubon.com.tw/food/。
            其他事項
            所有價格均以新台幣計算及呈現。
            根據相關條款和條件，我們將保留於任何時間點可隨時指定或更換任何我們所提供的服務內容的權利。我們所做的任何異動不須經過您的同意或另行通知您。
            我們有權在任何時間更改服務條款內容，恕不另行通知您。
            付款必須在訂單程序中完成，您可在線上使用信用卡付款，或在貨品送到時以現金付款。未能按時支付將導致您的訂單被取消。
            請勿在我們的網站上使用任何自動化或外掛補丁來連接線上訂單的程序。
            請勿從我們的網站收集或尋求任何可識別的個人資訊、使用網站上提供的通信系統以做為任何商業招攬之目的之事項、以任何理由招攬網站上提交訂單的使用者、發佈或發放任何折價卷或網站連接的代碼、破壞或破解網站。
            服務條款及隱私條款、任何訂單、及付款指南構成了您與我們之間的全部協議。其他明示或暗示的條款將不構成本約之一部分。如這些條款或網站上之規定有任何衝突，將以服務條款為準則。
            如有任何服務條款或協議應視為無效、觸犯法律、或為無法執行的應將視為無效，但該協議的其餘部分應繼續視為有效的條款。
            這些服務條款及我們的協議將依照臺灣當地法律管轄及解釋。我們與您將在此提交管轄權給臺灣法院為唯一管轄法院。
            在此協議下，任何延遲或未能執行我們的權利或賠償，都不能視為我們放棄此類權利或賠償，除非以書面形式確認放棄。
            這這些服務條款及合約 ﹝與其他所有的非合約義務或有關聯的內容﹞將依照臺灣當地法律管轄及解釋。臺灣法院為唯一管轄法院。所有買賣交易與我們和您的通信連繫應當使用中文進行。


            itfood.com.tw的所有權為itfood GmbH。 若您有任何訂餐相關問題，請使用live chat線上客服系統與我們客服團隊聯繫，謝謝。
            """)
            .padding(20)
                .foregroundColor(Color.colorNormalText)
             Spacer()
         }
         .navigationBarTitle("itfood服務條款")
        }.background(Color.colorBackground)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
