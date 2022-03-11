# ダイアリー体験フォーラム(diary_app)
<img width="600" alt="スクリーンショット 2022-03-08 7 19 56" src="https://user-images.githubusercontent.com/74279208/157127651-02ce7cda-dc3b-4d99-be91-62b3bf3c3c66.png">

- ユーザーが日々の生活で感じたこと、生活観をダイアリーとして投稿できるアプリです。
- 投稿したダイアリーは期間をおいて「チェック」機能で後に自分のダイアリーを見直しメモを入れることができます。
- ユーザーの生活観を他のユーザーとシェアをして、コメントをもらうことができて、必要に応じてコメントをオフにすることもできます。

## 公開リンク
https://www.diaryapp.net/

- 常時SSL化（httpsへのリダイレクト）
- レスポンシブデザインに対応
- ゲストログインボタンより、ゲストログインができます。

## アプリの概要とペルソナ
大学時代にメンタルヘルスのついて学ぶ機会があり、セルフケアを含めて、日々の生活態度を日記をに落とし込むことは、
非常に意義のある行いであることを学んだ([参考サイト](https://lineblog.me/mental_health/archives/429913.html))。

実際に専門のカウンセラーに立ち会わないと、メンタル面で自身の抱えている課題・問題点を共有できない、
自身の生活態度について思い悩む人々が多いことを知ったため、気軽に日記投稿としてご自身の生活態度を見直せるサービスを考えた。
想定されるペルソナは、おもに以下の特徴を設定した。

- 不安を抱えながらも建設的に生活したい人
- メンタルヘルスの健全性を保ちたい人
- 建設的なライフワークにおいて他の実践者と繋がりたい人

## インフラ構成図
<img width="600" alt="スクリーンショット 2022-03-08 11 24 57" src="https://user-images.githubusercontent.com/74279208/157154008-dd481377-89b7-4af1-ad72-e01a74871b61.png">

## 使用技術
### フロントエンド
- HTML/CSS
- Bootstrap
- jQuery
### バックエンド
- Ruby: 2.6.4
- Rails: 5.2.6
- Rubocop（Lintチェック）
- RSpec(モデルスペック,システムスペック)
- MySQL:5.7.37
- Nginx
- Puma
- PayJP(決済API)
### インフラ
- AWS（EC2,RDS,ElastiCache,S3,Route53,ELB,CloudFront,SES）
### 開発環境
- Git/GitHub（Pull requestsで擬似チーム開発）
- docker-compose（開発、テスト環境）
- CircleCI

## 実装機能
- ダイアリー投稿機能
  - 日数カウント・リセット機能(Ajax)
  - 投稿数制御(１日１投稿まで)
  - 画像投稿・リセット(CarrierWave)
  - 画像プレビュー(lightbox)
  - ダイアリーいいね機能(Ajax)
  - コメント認可
- コメント投稿機能(Ajax)
  - コメントいいね機能(Ajax)
  - ダイアリー所有者によるコメントいいね認知
- ダイアリーのキーワード検索機能
- ユーザーのタグ検索機能(Ajax)
- プロフィール編集機能
  - プロフィール画像投稿(CarrierWave) 
  - タグサジェスト検索・登録・バリデーション(jQuery、Ajax、Gem未使用)
  - クレジットカード登録(月額制によるプラン契約項目)
  - 支払い履歴
- フォロー・コメント・いいね時の通知機能(Sidekiqによる非同期メイラー処理)
  - 通知設定のユーザー制御
  - 通知一覧ページ
- ページネーション機能(Kaminari, Ajax)
  - ダイアリー、通知リソース、タグ検索結果のユーザー
- クレジットカード決済機能(Payjp)
  - プラン別にチャット投稿数を制御
- リアルタイムチャット機能(ActionCable, Ajax)

### Payjpのテストカード
|  項目  |  内容  |
| ---- | ---- |
|  カード番号 |  4242424242424242  |
|  有効期限  |  任意の期日  |
|  CVC番号  | 任意の3桁  |
|  名前  | 任意   |

## テーブル設計(ER図)
<img width="600" alt="スクリーンショット 2022-03-08 12 12 32" src="https://user-images.githubusercontent.com/74279208/157159217-efd2ee81-d897-4a91-9f80-9101430917db.png">

## 実装機能の詳細
### ログイン後のヘッダー内のアイコンについて
ログインユーザーにはヘッダーアイコンが現れます。
左から通知一覧,チャットルーム一覧,ユーザー一覧,プロフィール編集,ダイアリー新規作成へのページリンクが貼られています。
したがって、ダイアリー自体の閲覧はログインをしなくてもできますが、ダイアリー作成・フォロー機能・いいねなどはログインが求められます。

<img width="600" alt="スクリーンショット 2022-03-11 12 00 22" src="https://user-images.githubusercontent.com/74279208/157794025-38910718-83f8-4c12-87e9-5bf9df6084bb.png">

左から1番目のアイコンはクリックをすると、最新10件の通知一覧がドロップダウンで表示され、通知一覧ページに誘導されるリンクを「すべて確認」に設置していて、ドロップダウン内の各項目をクリックすると、通知に該当するリソースに遷移します。
たとえば、ログインユーザーがコメントにいいねされたら通知されるので当該コメントへのリンクが貼られています。任意の通知を確認したら既読になり、薄暗くなります。

<img width="600" alt="スクリーンショット 2022-03-11 12 03 12" src="https://user-images.githubusercontent.com/74279208/157794182-5baff2fd-7e1f-4bd5-b189-d139bec8ca95.png">

### 日数リセット機能
ダイアリーは１日１投稿までで、投稿する度に１日目、２日目...と増えて作成されていきますが、ユーザーの都合でダイアリー作成日数に区切りを付けて１日目から作成したい場合はリセットボタンをクリックして新規作成することができます。

<a href="https://gyazo.com/c13c8618a42eeb93a1f9acd8cb2d9a33"><img src="https://i.gyazo.com/c13c8618a42eeb93a1f9acd8cb2d9a33.gif" alt="Image from Gyazo" width="600"/></a>

### 投稿数制御(1日1回まで)
ユーザーは最後に作成したダイアリーより24時間経過していない場合、新規作成ページに遷移できません。
以下では、8分前にダイアリーを作成してから作成ページに遷移しようとすると、エラーが発生します。

<a href="https://gyazo.com/6fb2fa69799a2fe3be9a0ef39c0c030b"><img src="https://i.gyazo.com/6fb2fa69799a2fe3be9a0ef39c0c030b.gif" alt="Image from Gyazo" width="600"/></a>

### 画像添付・プレビュー機能
ダイアリー作成ページ内で画像を添付することができ、ダイアリーに添付する予定の画像をプレビューすることができます。

<a href="https://gyazo.com/83508a9f03d9170b464fa67ae5a11ad7"><img src="https://i.gyazo.com/83508a9f03d9170b464fa67ae5a11ad7.gif" alt="Image from Gyazo" width="600"/></a>

### コメント編集機能
ダイアリーのリソースごとにダイアリー投稿者を含めたすべてのユーザーがコメントを直観的に投稿することができます。以下では投稿したコメントを非同期通信(Ajax)で書き換えています。

<a href="https://gyazo.com/e8ecd4277cdb7bdb7bdcb1a05011d4b3"><img src="https://i.gyazo.com/e8ecd4277cdb7bdb7bdcb1a05011d4b3.gif" alt="Image from Gyazo" width="600"/></a>

### コメント認可、所有者いいね認知
一方で、必要に応じてダイアリー投稿者は事前にコメントを非承認にすることができます。

<img width="600" alt="スクリーンショット 2022-03-11 14 34 49" src="https://user-images.githubusercontent.com/74279208/157809191-07180bdc-29bd-48ce-ad4e-49c96bdedea6.png">
<img width="600" alt="スクリーンショット 2022-03-11 14 39 02" src="https://user-images.githubusercontent.com/74279208/157809228-2710254d-51ec-4134-93b2-e7c405aa21b8.png">

これは、viewだけではなく、コメントを扱う`CommentsController`単位でも制御をおこなっています。
```ruby
class CommentsController < ApplicationController
 before_action :check_authorization, only: %i[create]
 .
 .
 .
 private
    def check_authorization
            @diary = Diary.find(params[:diary_id])
            if !@diary.comment_authorization
                # 0つまりfalseだった場合
                end
            end
        end
```

また、ダイアリー所有者がいいねした場合には、アバターとハートマークを組み合わせたアイコンが登場します。以下のコメントに対するいいねの総数は6ですが、ダイアリー所有者のいいねを含んでいます。

<img width="600" alt="スクリーンショット 2022-03-11 14 46 27" src="https://user-images.githubusercontent.com/74279208/157809721-ff46d9ed-03d8-4aac-a9b4-8c6c4f90a42a.png">

### タグによるユーザー検索
ユーザーはタグを登録でき、ユーザーの一覧ページから任意のタグをクリックすると、当該タグを所有するユーザーを非同期通信(Ajax)により出力します。

<a href="https://gyazo.com/6c87fc12ff5088c12d2b9a3c7ebb672e"><img src="https://i.gyazo.com/6c87fc12ff5088c12d2b9a3c7ebb672e.gif" alt="Image from Gyazo" width="600"/></a>

### タグ登録機能
ユーザー編集ページでタグを５つまで登録できます。フォームに入力すると、他のユーザーに登録されているタグの候補をサジェストで出力します。登録されていないタグは新規に作成しますが、登録されて使われなくなったタグに関しては削除されます。

<a href="https://gyazo.com/02fe96e78f0dd9356f6f617c7cad5a06"><img src="https://i.gyazo.com/02fe96e78f0dd9356f6f617c7cad5a06.gif" alt="Image from Gyazo" width="600"/></a>

また、タグを5文字を超えて投稿しようとしたり、追加で登録しようとするとバリデーションエラーが出力されます。そのほか重複するタグを登録しようとすると弾かれるようになっています。jQueryで扱う配列内で管理しているためそのような仕様になっています([該当コード](https://github.com/siriusjunior/diary_app/blob/develop/app/assets/javascripts/mypage.js))。

<a href="https://gyazo.com/70d2d4dc693d73f421e7eb8a8ab652dc"><img src="https://i.gyazo.com/70d2d4dc693d73f421e7eb8a8ab652dc.gif" alt="Image from Gyazo" width="600"/></a>

### クレジットカード登録機能、サブスクリプションによる制御
クレジットカードを登録していないユーザーは、チャットルーム内で送信できるメッセージは10件までに制限されていて、サブスクリプションの契約形態を設けているのでベーシックプランに加入すると月間で20件までは投稿でき、プレミアムプランに加入すると無制限にメッセージが投稿できます。

<a href="https://gyazo.com/e27f382c27644b8973a6de1817f41ea1"><img src="https://i.gyazo.com/e27f382c27644b8973a6de1817f41ea1.gif" alt="Image from Gyazo" width="600"/></a>
<a href="https://gyazo.com/7a172c3a1677239b88c9bcd220aebed9"><img src="https://i.gyazo.com/7a172c3a1677239b88c9bcd220aebed9.gif" alt="Image from Gyazo" width="600"/></a>

なお、上限が来ても投稿したメッセージを削除すると、再度新規にメッセージが投稿できます。

## 【補足】 アプリの設計・ワイアーフレームの作成

###  ペルソナの課題(ジョブ理論)
アプリ設計に際して、独自にペルソナの解決すべき課題として[ジョブ理論](https://www.harpercollins.co.jp/hc/books/detail/10971)を採用し、スプレッドシートにジョブと機能を洗出した。

<img width="600" alt="スクリーンショット 2022-03-08 10 25 10" src="https://user-images.githubusercontent.com/74279208/157148074-ef2f7501-aaf9-44ae-8dc8-848fd6119091.png">

これを元に具体的なワイヤーフレームをFigmaで作成し開発をスタートした。

<img width="600" alt="スクリーンショット 2022-03-08 10 43 56" src="https://user-images.githubusercontent.com/74279208/157149272-6bb0e247-f445-4a83-ba6e-2deef7f4293a.png">

### 画面設計
<img width="600" alt="スクリーンショット 2022-03-08 10 52 25" src="https://user-images.githubusercontent.com/74279208/157150338-4c62dc8d-d93d-4a9d-a4f3-208526f36984.png">

