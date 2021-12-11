require 'rails_helper'

RSpec.describe "チャットルーム", type: :system do
  describe 'ユーザー詳細ページ' do
    let!(:sender) { create(:user) }
    let!(:receiver) { create(:user) }
    context 'チャットルームが存在しない場合' do
      before do
        login_as sender
        visit user_path(receiver)
      end

      it 'ユーザー詳細ページにてフォローするとDMボタンが出現すること', js: true do
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        expect(page).to have_selector '#message-button__container', class: 'active'
      end

      it 'ユーザー詳細ページにてアンフォローするとDMボタンが削除されること', js: true do
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        expect(page).to have_css '#message-button'
        expect(page).to have_content 'フォロー中'
        within "#follow-area-#{ receiver.id }" do
          click_link('フォロー中')
        end
        expect(page).to have_selector '#message-button__container'
        expect(page).not_to have_selector '#message-button__container', class: 'active'
      end

      it 'チャットルームボタンを押すとルームが作られること' do
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        find('#message-button').click
        expect(current_path).to eq chatroom_path(Chatroom.first)
        click_link '参加者一覧'
        expect(page).to have_content sender.username
        expect(page).to have_content receiver.username
      end
    end

    context 'チャットルームが存在する場合' do
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
        expect(page).to have_selector '#message-button__container', class: 'active'
      end

    end
  end

  describe 'チャットルーム詳細ページ' do
    
    context '送信者の場合' do
      let!(:sender) { create(:user) }
      let!(:receiver) { create(:user) }

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
        expect(page).to have_content 'hello world'
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
      let!(:sender) { create(:user) }
      let!(:receiver) { create(:user) }

      before do
        login_as sender
        visit user_path(receiver)
        within "#follow-area-#{ receiver.id }" do
          click_link('フォローする')
        end
        find('#message-button').click
      end

      it 'メッセージを受信していたら送信者の詳細ページにDMボタンが表示されていること' do
        expect(current_path).to eq chatroom_path(Chatroom.first)
        within "#header-container" do
          page.accept_confirm { click_on('ログアウト') }
        end
        expect(current_path).to eq root_path
        login_as receiver
        visit user_path(sender)
        expect(page).to have_selector '#message-button__container', class: 'active'
      end
      
      it 'メッセージの編集・削除ボタンが表示されていないこと' do
        fill_in 'メッセージ', with: 'hello world'
        # senderがまだルーム内なのでメッセージを残しておく
        click_on('送信')
        within "#header-container" do
          page.accept_confirm { click_on('ログアウト') }
        end
        expect(current_path).to eq root_path
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
end
