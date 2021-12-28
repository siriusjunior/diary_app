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

        it 'フォローができること', js: true  do
            visit users_path
            expect {
                within "#follow-area-#{ other_user.id }" do
                    click_link 'フォローする'
                    expect(page).to have_content 'フォロー中'
                end
            }.to change(login_user.following, :count).by(1)
        end
        
        it 'フォローが外せること', js: true  do
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

    describe 'フォローユーザー・フォロワーの一覧' do
        let!(:login_user) { create(:user) }
        let!(:following) { create_list(:user, 3) }
        let!(:followers) { create_list(:user, 3) }
        before do
            login_as login_user
            following.each do |followed|
                login_user.follow(followed)
            end
            followers.each do |follower|
                follower.follow(login_user)
            end
        end

        it 'フォローユーザーの一覧が表示されていること', js: true do
            visit user_path(login_user)
            expect(page).to have_content login_user.following.count
            find('#following_user').click
            expect(current_path).to eq following_user_path(login_user)
            following.each do |followed|
                expect(page).to have_content followed.username
            end
            expect(page).not_to have_content followers.first.username
        end
        
        it 'フォローユーザーの一覧が表示されていること', js: true do
            visit user_path(login_user)
            expect(page).to have_content login_user.followers.count
            find('#followers_user').click
            expect(current_path).to eq followers_user_path(login_user)
            followers.each do |follower|
                expect(page).to have_content follower.username
            end
            expect(page).not_to have_content following.first.username
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

        it 'タグをクリックすると該当ユーザーが表示されること', js: true  do
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
        
        it 'タグをクリックすると該当ユーザーが表示されないこと', js: true  do
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

    describe 'プロフィール編集' do
        let!(:login_user) { create(:user) }
        before do
            login_as login_user
        end
        
        it 'プロフィール編集ができて反映がされること', js: true do
            find('#edit_mypage_account').click
            expect(current_path).to eq edit_mypage_account_path
            attach_file 'user_avatar', File.join(Rails.root + 'spec/fixtures/dummy.png')
            fill_in 'ユーザー名', with: '柿句恵子'
            fill_in 'プロフィール', with: 'プロフ編集のダミーテキスト'
            fill_in 'search-form-input', with: 'タグ7,タグ8,タグ9'
            click_button '更新する'
            expect(current_path).to eq user_path(login_user)
            login_user.reload
            expect(page).to have_content login_user.username
            expect(page).to have_content login_user.introduction
            expect(page).to have_content login_user.tags.first.name
            expect(page).to have_content 'プロフィールを更新しました'
        end
    end

end