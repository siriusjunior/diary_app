require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
    
    describe 'ユーザー登録' do
        context '入力情報が正しい場合' do
            it 'ユーザー登録ができること' do
                visit new_user_path
                fill_in 'ユーザー名', with: '阿井上男'
                fill_in 'メールアドレス', with: 'aiueo@example.com'
                fill_in 'パスワード', with: '12345678'
                fill_in 'パスワード確認', with: '12345678'
                click_button '登録'
                expect(current_path).to eq login_path
                expect(page).to have_content 'メールを送信いたしました。メールをご確認の上、アカウントを有効化してください'
            end
        end

        context '入力情報に誤りがある場合' do
            it 'ユーザー登録ができないこと' do
                visit new_user_path
                fill_in 'ユーザー名', with: ''
                fill_in 'メールアドレス', with: ''
                fill_in 'パスワード', with: ''
                fill_in 'パスワード確認', with: ''
                click_button '登録'
                expect(page).to have_content 'ユーザーの作成に失敗しました'
                expect(page).to have_content 'ユーザー名を入力してください'
                expect(page).to have_content 'メールアドレスを入力してください'
                expect(page).to have_content 'パスワードは8文字以上で入力してください'
                expect(page).to have_content 'パスワード確認を入力してください'
            end
        end
    end

    describe 'フォロー' do
        let!(:login_user) { create(:user) }
        let!(:other_user) { create(:user) }
        before do
            login_as login_user
        end

        it 'フォローができること' do
            visit users_path
            expect {
                within "#follow-area-#{ other_user.id }" do
                    click_link 'フォローする'
                    expect(page).to have_content 'フォロー中'
                end
            }.to change(login_user.following, :count).by(1)
        end
        
        it 'フォローが外せること' do
            login_user.follow(other_user)
            visit users_path
            expect {
                within "#follow-area-#{ other_user.id }" do
                    click_link 'フォロー中'
                    expect(page).to have_content 'フォローする'
                end
            }.to change(login_user.following, :count).by(-1)
        end
    end

    describe 'ユーザータグ検索' do
        let!(:no_tag_user) { create(:user) }
        # タグ1登録ユーザー
        let!(:one_tag_user) { create(:user, :user_with_tag, username: '1tag') }
        # タグ1~3登録ユーザー
        let!(:three_tags_user) { create(:user, :user_with_3_tags, username: '3tags') }
        # タグ1~5登録ユーザー
        let!(:five_tags_user) { create(:user, :user_with_5_tags, username: '5tags') }
        before do
            login_as no_tag_user
        end

        it 'タグ登録されていること' do
            visit edit_mypage_account_path
            expect {
                fill_in "search-form-input", with: "タグA,タグB,タグC"
                click_button '更新する'
            }.to change(no_tag_user.tag_links, :count).by(3)
            tag_names = no_tag_user.tags.pluck(:name)
            visit users_path
            tag_names.each do |tag_name|
                expect(page).to have_content tag_name
            end
        end

        it 'タグをクリックすると該当ユーザーが表示されること' do
            tag_names = Tag.all.pluck(:name)
            find('#users_icon').click
            expect(current_path).to eq users_path
            tag_names.each do |tag_name|
                expect(page).to have_content tag_name
            end
            within("#tags") do
                click_link 'タグ1'
            end
            expect(page).to have_content one_tag_user.username
            expect(page).not_to have_content no_tag_user.username
        end
        
        it 'タグをクリックすると該当ユーザーが表示されないこと' do
            find('#users_icon').click
            expect(current_path).to eq users_path
            within("#tags") do
                click_link 'タグ5'
            end
            expect(page).not_to have_content one_tag_user.username
            expect(page).not_to have_content three_tags_user.username
            expect(page).to have_content five_tags_user.username
            within("#tags") do
                click_link 'タグ3'
            end
            expect(page).not_to have_content one_tag_user.username
            expect(page).to have_content three_tags_user.username
            expect(page).to have_content five_tags_user.username
        end

    end

end