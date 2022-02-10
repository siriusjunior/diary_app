require 'rails_helper'

RSpec.describe "チャットルーム", type: :system do
  let!(:sender) { create(:user) }
  let!(:receiver) { create(:user) }
  # payjp_cutomer.rbのPlan.find_byでエラーが起きるためplanを作成
  let!(:basic_plan) { create(:plan, :basic_plan) }
  let!(:premium_plan) { create(:plan, :premium_plan) }

  describe 'ユーザー詳細ページ' do
    context 'チャットルームが存在しない場合' do
      before do
        login_as sender
        visit user_path(receiver)
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
      end

      it 'ユーザー詳細ページにてフォローするとDMボタンが出現すること', js: true do
        within ".userprofile__icons" do
          expect(page).to have_selector '#message-button__container', class: 'active'
        end
      end

      it 'ユーザー詳細ページにてアンフォローするとDMボタンが表示されないこと', js: true do
        within ".userprofile__icons" do
          expect(page).to have_selector '#message-button__container', class: 'active'
        end
        within "#follow-area-#{ receiver.id }" do
          click_link('フォロー中')
        end
        within ".userprofile__icons" do
          expect(page).not_to have_selector '#message-button__container', class: 'active'
        end
      end

      it 'チャットルームボタンを押すとルームが作られること', js: true do
        find('#message-button').click
        expect(current_path).to eq chatroom_path(Chatroom.first)
        click_link '参加者一覧'
        expect(page).to have_content sender.username
        expect(page).to have_content receiver.username
      end
    end

    context 'チャットルームが存在する場合', js: true do
      before do
        login_as sender
        visit user_path(receiver)
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        find('#message-button').click
      end

      it 'ユーザー詳細ページにてアンフォローしてもDMボタンが表示されていること', js: true do
        expect(current_path).to eq chatroom_path(Chatroom.first)
        visit user_path(receiver)
        expect(current_path).to eq user_path(receiver)
        within "#follow-area-#{ receiver.id }" do
          click_link('フォロー中')
        end
        expect(page).to have_css('#message-button__container', visible: true)
      end

    end
    # ユーザー詳細ページ
  end

  describe 'チャットルーム詳細ページ' do

    describe 'メッセージの送受信者ごとの表示切替え', js: true do
      context '送信者の場合' do
        before do
          login_as sender
          visit user_path(receiver)
          within "#follow-area-#{ receiver.id }" do
            click_link('フォローする')
          end
          find('#message-button').click
        end
        it 'メッセージが投稿できること', js: true do
          expect(current_path).to eq chatroom_path(Chatroom.first)
          fill_in 'メッセージ', with: 'hello world'
          click_on('送信')
          expect(page).to have_content('hello world')
        end
    
        it 'メッセージの編集ができること', js: true do
          expect(current_path).to eq chatroom_path(Chatroom.first)
          fill_in 'メッセージ', with: 'hello world'
          click_on('送信')
          expect(page).to have_css('.edit-button')
          find('.edit-button').click
          fill_in "message-edit", with: 'hello edit world'
          click_on('保存')
          expect(page).to have_content 'hello edit world'
          expect(page).not_to have_content 'hello world'
        end
        
        it 'メッセージの削除ができること', js: true do
          expect(current_path).to eq chatroom_path(Chatroom.first)
          fill_in 'メッセージ', with: 'hello world'
          click_on('送信')
          expect(page).to have_css('.delete-button')
          page.accept_confirm { find('.delete-button').click }
          expect(page).not_to have_content 'hello world'
        end
        
      end

      context '受信者の場合' do
        before do
          login_as sender
          visit user_path(receiver)
          within "#follow-area-#{ receiver.id }" do
            click_link('フォローする')
          end
          find('#message-button').click
        end

        it 'メッセージを受信していたら送信者の詳細ページにDMボタンが表示されていること', js: true do
          expect(current_path).to eq chatroom_path(Chatroom.first)
          within "#header-container" do
            page.accept_confirm { click_on('ログアウト') }
          end
          expect(page).to have_content 'ログアウトしました'
          login_as receiver
          visit user_path(sender)
          within ".userprofile__icons" do
            expect(page).to have_selector '#message-button__container', class: 'active'
          end
        end
        
        it 'メッセージの編集・削除ボタンが表示されていないこと', js: true do
          fill_in 'メッセージ', with: 'hello world'
          # senderがまだルーム内なのでメッセージを残しておく
          click_on('送信')
          within "#header-container" do
            page.accept_confirm { click_on('ログアウト') }
          end
          expect(page).to have_content 'ログアウトしました'
          login_as receiver
          visit user_path(sender)
          find('#message-button').click
          expect(current_path).to eq chatroom_path(Chatroom.first)
          expect(page).to have_content 'hello world'
          expect(page).not_to have_css('.edit-button')
          expect(page).not_to have_css('.delete-button')
        end
      end
    end
    # メッセージの送受信者ごとの表示切替え

    describe 'DMメッセージ投稿数の制限' do
      let!(:no_subscriber) { create(:user) }
      let!(:basic_subscriber) { create(:user) }
      let!(:premium_subscriber) { create(:user) }
      let!(:invited) { create(:user) }
      let!(:basic_plan) { create(:plan, :basic_plan) }
      let!(:premium_plan) { create(:plan, :premium_plan) }
      before do
        charge_mock = double(:charge_mock)
          allow(charge_mock).to receive(:id).and_return(SecureRandom.uuid)
          allow(Payjp::Charge).to receive(:create).and_return(charge_mock)
        basic_subscriber.subscript!(basic_plan)
        premium_subscriber.subscript!(premium_plan)
      end
      
      context '未契約ユーザー' do
        before do
          login_as(no_subscriber)
          visit user_path(invited)
          within "#follow-area-#{ invited.id }" do
            click_link('フォローする')
          end
          find('#message-button').click
          @chatroom = Chatroom.chatroom_with_users([no_subscriber] + [invited])
          create_list(:message, 9, user: no_subscriber, chatroom: @chatroom)
        end

        it 'メッセージ10件目を投稿できること', js: true do
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
          expect(page).to have_content 'Lorem ipsum dolor sit amet'
        end
        it 'メッセージ11件目を投稿しようとするとアラートが表示されること', js: true do
          # 10件目の投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
          # 11件目の投稿
          fill_in 'message_body', with: 'Nec dui nunc mattis enim'
          click_on '送信'
          # '今月のメッセージ可能回数をオーバーしました'に付与されるcss
          expect(page).to have_css('.alert')
        end
      end
      # 未契約ユーザー
      context 'ベーシックプラン契約者' do
        before do
          login_as(basic_subscriber)
          visit user_path(invited)
          within "#follow-area-#{ invited.id }" do
            click_link('フォローする')
          end
          find('#message-button').click
          @chatroom = Chatroom.chatroom_with_users([basic_subscriber] + [invited])
          create_list(:message, 19, user: basic_subscriber, chatroom: @chatroom)
        end

        it 'メッセージ20件目を投稿してもアラートが表示されないこと', js: true do
          # 20件目の投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
          expect(page).to have_content 'Lorem ipsum dolor sit amet'
        end
        # it 'メッセージ21件目を投稿しようとするとアラートが表示されること', js: true do
        #   # 20件目の投稿
        #   fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
        #   click_on '送信'
        #   # 21件目の投稿
        #   fill_in 'message_body', with: 'Nec dui nunc mattis enim'
        #   click_on '送信'
        #   sleep(5)
        #   # '今月のメッセージ可能回数をオーバーしました'に付与されるcss
        #   expect(page).to have_css('.alert')
        # end
      end
      # ベーシックプラン契約者
      context 'プレミアムプラン契約者' do
        before do
          login_as(premium_subscriber)
          visit user_path(invited)
          within "#follow-area-#{ invited.id }" do
            click_link('フォローする')
          end
          find('#message-button').click
          @chatroom = Chatroom.chatroom_with_users([premium_subscriber] + [invited])
          create_list(:message, 22, user: premium_subscriber, chatroom: @chatroom)
        end

        it 'メッセージ23件目を投稿してもアラートが表示されないこと', js: true do
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
          expect(page).to have_content 'Lorem ipsum dolor sit amet'
          expect(page).not_to have_css('.alert')
        end
      end
      # プレミアムプラン契約者
    end
    # DMメッセージ投稿数の制限
    describe '文字数の制限' do
      before do
        login_as sender
        visit user_path(receiver)
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        find('#message-button').click
      end
      context 'メッセージ投稿' do
        it '文字数を超えて投稿するとアラートが表示されること', js: true do
          # およそ320文字を投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'
          click_on '送信'
          expect(page).to have_content('メッセージは300文字以内で入力してください')
        end
        it 'アラート表示後に再投稿でアラートが除去されること', js: true do
          # およそ320文字を投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'
          click_on '送信'
          expect(page).to have_content('メッセージは300文字以内で入力してください')
          # 制限文字数以内で投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
          expect(page).not_to have_css('.alert')
          expect(page).not_to have_content('メッセージは300文字以内で入力してください')
        end
      end
      # メッセージ投稿
      context 'メッセージ編集' do
        before do
          # 有効なメッセージを投稿
          fill_in 'message_body', with: 'Lorem ipsum dolor sit amet'
          click_on '送信'
        end
        it '文字数を超えて編集するとアラートが表示されること', js: true do
          expect(page).to have_content('Lorem ipsum dolor sit amet')
          find('.edit-button').click
          # およそ320文字で編集
          fill_in 'message-edit', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'
          click_on '保存'
          expect(page).to have_content('メッセージは300文字以内で入力してください')
        end
        it 'アラート表示後に再編集でアラートが除去されること', js: true do
          find('.edit-button').click
          # およそ320文字で編集
          fill_in 'message-edit', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod'
          click_on '保存'
          expect(page).to have_content('メッセージは300文字以内で入力してください')
          # 制限文字数以内で再編集
          fill_in 'message-edit', with: 'Lorem ipsum dolor sit amet'
          click_on '保存'
          expect(page).not_to have_content('メッセージは300文字以内で入力してください')
        end
      end
      # メッセージ編集
    end
    # 文字数の制限
  end
  # チャットルーム詳細ページ
end