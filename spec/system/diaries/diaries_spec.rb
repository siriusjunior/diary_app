require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
    
    describe 'ダイアリー一覧' do
        let!(:user) { create(:user) }
        let!(:user_2) { create(:user) }
        let!(:diary_1_by_others) { create(:diary) }
        let!(:diary_2_by_others) { create(:diary) }
        let!(:diary_by_user) { create(:diary, user: user) }

        context 'ログインしている,かつフィードがある場合' do
            before do
                login_as user
                user.follow(diary_1_by_others.user)
            end
            it 'フォロワーと自分の投稿だけが表示されること' do
                visit diaries_path
                expect(page).to have_content diary_1_by_others.body
                expect(page).to have_content diary_by_user.body
                expect(page).not_to have_content diary_2_by_others.body
            end
        end

        context 'ログインしている,かつフィードがない場合' do
            before do
                login_as user_2
            end
            it 'すべての投稿が表示されること' do
                visit diaries_path
                expect(page).to have_content diary_1_by_others.body
                expect(page).to have_content diary_2_by_others.body
                expect(page).to have_content diary_by_user.body
            end
        end

        context 'ログインしていない場合' do
            it 'すべての投稿が表示されること' do
                visit diaries_path
                expect(page).to have_content diary_1_by_others.body
                expect(page).to have_content diary_2_by_others.body
                expect(page).to have_content diary_by_user.body
            end
        end
    end

    describe 'ダイアリー投稿' do
        context '投稿内容が有効な場合' do
            it 'ダイアリーが投稿できること' do
                login_as user_2
                visit new_diary_path
                within '#post_form' do
                    attach_file 'アップロード画像(任意)', Rails.root.join('spec','fixtures','dummy.png')
                    fill_in 'ダイアリー本文', with: 'テスト投稿のダミーテキスト'
                    page.accept_confirm { click_button '投稿する' }
                end
                expect(page).to have_content 'ダイアリー1日目を投稿しました'
                expect(page).to have_content 'テスト投稿のダミーテキスト'
            end
        end
        context '投稿内容が無効な場合' do
            it 'ダイアリーが投稿できないこと' do
                login_as user_2
                visit new_diary_path
                within '#post_form' do
                    fill_in 'ダイアリー本文', with: ''
                    page.accept_confirm { click_button '投稿する' }
                end
                expect(page).to have_content 'ダイアリーの投稿に失敗しました'
                expect(page).to have_content 'ダイアリー本文を入力してください'
            end
        end
        
    end

    describe 'ダイアリー更新' do
        let!(:user) { create(:user) }
        let!(:diary_1_by_others) { create(:diary) }
        let!(:diary_2_by_others) { create(:diary) }
        let!(:diary_by_user) { create(:diary, user: user) }
        before do
            login_as user
        end
        it '自分の投稿に編集ボタンが表示されること' do
            visit diaries_path
            within "#diary-#{ diary_by_user.id }" do
                expect(page).to have_css '.delete-button'
                expect(page).to have_css '.edit-button'
            end
        end
        it '自分以外の投稿には編集ボタンが表示されないこと' do
            user.follow(diary_1_by_others.user)
            visit diaries_path
            within "#diary-#{ diary_1_by_others.id }" do
                expect(page).not_to have_css '.delete-button'
                expect(page).not_to have_css '.edit-button'
            end
        end
        context '編集内容が無効な場合' do
            it '投稿が更新できないこと' do
                visit edit_diary_path(diary_by_user)
                within '#edit_form' do
                    fill_in 'ダイアリー本文', with: ''
                    page.accept_confirm { click_button '保存する' }
                end
                expect(page).to have_content 'ダイアリーの保存に失敗しました'
                expect(page).to have_content 'ダイアリー本文を入力してください'
            end
        end
        context '編集内容が有効な場合' do
            it '投稿が更新できること' do
                visit edit_diary_path(diary_by_user)
                within '#edit_form' do
                    attach_file 'アップロード画像(任意)', Rails.root.join('spec','fixtures','dummy.png')
                    fill_in 'ダイアリー本文', with: 'テスト編集のダミーテキスト'
                    page.accept_confirm { click_button '保存する' }
                end
                expect(page).to have_content 'ダイアリーの変更を保存しました'
                expect(page).to have_content 'テスト編集のダミーテキスト'
            end
        end
    end

    describe 'ダイアリー削除' do
        let!(:user){ create(:user) }
        let!(:diary_by_others){ create(:diary)}
        let!(:diary_by_user) { create(:diary, user: user) }
        before do
            login_as user
        end
        it '投稿を削除できること' do
            visit diaries_path
            within "#diary-#{ diary_by_user.id }" do
                page.accept_confirm { find('.delete-button').click }
            end
            expect(page).to have_content 'ダイアリーを削除しました'
            expect(page).not_to have_content diary_by_user.body
        end
    end

    describe 'ダイアリー詳細' do
        let!(:user) { create(:user) }
        let!(:diary_by_user) { create(:diary, user: user) }
        before do
            login_as user
        end

        it '投稿の詳細画面が閲覧できること' do
            visit diary_path(diary_by_user)
            expect(current_path).to eq diary_path(diary_by_user)
        end
    end

    describe 'コメント投稿' do
        let!(:user) { create(:user) }
        let!(:diary_by_user) { create(:diary, user: user) }
        before do
            login_as user
        end
        
        it 'コメントを投稿できること' do
            visit diary_path(diary_by_user)
            within '#comment_body' do
                fill_in :body, with: 'テスト投稿のダミーコメント'
                click_button 'コメント'
            end
            expect(page).to have_content 'テスト投稿のダミーコメント'
        end
    end

    describe 'コメント更新' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary) }
        let!(:comment_by_others) { create(:comment, diary: diary) }
        let!(:comment_by_user) { create(:comment, diary: diary, user: user) }
        before do
            login_as user
        end
        it '自分のコメントに編集ボタンが表示されること' do
            visit diary_path(diary)
            within "#comment-#{comment_by_user.id}" do
                expect(page).to have_css '.comment-edit-button'
                expect(page).to have_css '.comment-delete-button'
            end
        end
        
        it '自分以外のコメントに編集ボタンが表示されないこと' do
            visit diary_path(diary)
            within "#comment-#{comment_by_others.id}" do
                expect(page).not_to have_css '.comment-edit-button'
                expect(page).not_to have_css '.comment-delete-button'
            end
        end
    end

    describe 'コメント削除' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary) }
        let!(:comment_by_user) { create(:comment, diary: diary, user: user) }
        before do
            login_as user
        end
        it 'コメントが削除できること' do
            visit diary_path(diary)
            within "#comment-#{comment_by_user.id}" do
                page.accept_confirm { find('.comment-delete-button').click }
            end
            expect(page).not_to have_content comment_by_user.body
        end
    end













    describe 'いいね' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary) }
        before do
            login_as user
            user.follow(diary.user)
        end

        it 'ダイアリーにいいねができること' do
            visit diary_path(diary) 
            expect {
                within "#diary-#{diary.id}" do
                    find('.like_button').click
                    expect(page).to have_css '.unlike-button'
                end
            }.to change(user.like_diaries, :count).by(1)
        end
        
        it 'ダイアリーにいいねの取り消しができること' do
            user.like(diary)
            visit diary_path(diary) 
            expect {
                within "#diary-#{diary.id}" do
                    find('.unlike_button').click
                    expect(page).to have_css '.like-button'
                end
            }.to change(user.like_diaries, :count).by(-1)
        end
    end
end