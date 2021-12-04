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
        let!(:user) { create(:user) }
        before do
            login_as user
        end

        context '投稿内容が有効な場合' do
            it 'ダイアリーが投稿できること' do
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
                visit new_diary_path
                within '#post_form' do
                    fill_in 'ダイアリー本文', with: ''
                    page.accept_confirm { click_button '投稿する' }
                end
                expect(page).to have_content 'ダイアリーの投稿に失敗しました'
                expect(page).to have_content 'ダイアリー本文を入力してください'
            end
        end

        context '1日以内に投稿がされている場合' do
            it '2度目の投稿ができないこと' do
                create(:diary, user: user)
                find('#new_diary_icon').click
                expect(page).to have_content 'ダイアリーの投稿は１日１回までです'
            end
        end
        
        context '投稿がされて1日経過した場合' do
            it '2日目の投稿ができること' do
                create(:diary, user: user)
                travel_to 1.day.from_now do
                    visit new_diary_path
                    within '#post_form' do
                        attach_file 'アップロード画像(任意)', Rails.root.join('spec','fixtures','dummy.png')
                        fill_in 'ダイアリー本文', with: 'テスト投稿のダミーテキスト'
                        page.accept_confirm { click_button '投稿する' }
                    end
                    expect(page).to have_content 'ダイアリー2日目を投稿しました'
                end
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
                    attach_file 'アップロード画像', Rails.root.join('spec','fixtures','dummy.png')
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
                sleep(2)
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

    describe 'コメント認可' do
        let!(:user) { create(:user) }
        let!(:comment_unauthorized) { create(:diary, comment_authorization: false) }
        
        context 'コメントを許可しない場合' do
            it 'ダイアリー作成者の場合コメントのオフ通知と設定リンクが表示されること' do
                login_as user
                visit new_diary_path
                within '#post_form' do
                    fill_in 'ダイアリー本文', with: 'コメント認可のダミーテキスト'
                    uncheck 'コメントを許可する'
                    page.accept_confirm { click_button '投稿する' }
                end
                # 以下の1行が無いとvisitが効かない
                expect(page).to have_content('ダイアリー1日目を投稿しました')
                visit diary_path(user.diaries.last)
                expect(page).to have_content('コメントはオフになっています。設定を変更する')
                expect(page).to have_link('設定')
            end
            it 'ダイアリー作成者でない場合コメントのオフ通知のみが表示されること' do
                login_as user
                visit diary_path(comment_unauthorized)
                expect(page).to have_content('コメントはオフになっています')
                expect(page).not_to have_link('設定')
            end
        end
        context 'コメントを許可する場合' do
            it 'コメント欄が表示されること' do
                login_as user
                visit new_diary_path
                within '#post_form' do
                    fill_in 'ダイアリー本文', with: 'コメント認可のダミーテキスト'
                    check 'コメントを許可する'
                    page.accept_confirm { click_button '投稿する' }
                end
                # 以下の1行が無いとvisitが効かない
                expect(page).to have_content('ダイアリー1日目を投稿しました')
                visit diary_path(user.diaries.last)
                expect(page).to have_content('0件のコメント')
            end
        end
    end

    describe 'コメント投稿' do
        let!(:user) { create(:user) }
        let!(:user2) { create(:user) }
        let!(:diary_by_user) { create(:diary, user: user) }
        context 'ログインしている場合' do
            before do
                login_as user
            end
            it 'コメントを投稿できること' do
                visit diary_path(diary_by_user)
                find('#comment-post__form').click
                fill_in "comment-post__form", with: 'テスト投稿のダミーコメント'
                click_button 'コメント'
                expect(page).to have_content 'テスト投稿のダミーコメント'
                expect(page).to have_content "#{diary_by_user.comments.count}件のコメント"
            end
        end

        context 'ログインしていない場合' do
            it 'コメントフォームにログインリンクが表示されていること' do
                visit diary_path(diary_by_user)
                expect(page).to have_content 'いいね・コメントするにはログインが必要です'
                expect(page).to have_link 'ログイン'
            end
            
            it 'コメントフォームのログインリンクからログインして当該ダイアリー詳細に戻ること' do
                visit diary_path(diary_by_user)
                within "#before_login" do
                    click_link('ログイン')
                end
                expect(page).to have_content 'こちらからログインしてください'
                fill_in 'メールアドレス', with: user2.email
                fill_in 'パスワード', with: '12345678'
                click_button 'ログイン'
                expect(page).to have_content 'ログインしました'
                expect(current_path).to eq diary_path(diary_by_user)
                expect(page).to have_css '.comment-post__input'
            end
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
            within "#comment-#{ comment_by_user.id }" do
                expect(page).to have_css '.comment-edit-button'
                expect(page).to have_css '.comment-delete-button'
            end
        end
        
        it '自分以外のコメントに編集ボタンが表示されないこと' do
            visit diary_path(diary)
            within "#comment-#{ comment_by_others.id }" do
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
            within "#comment-#{ comment_by_user.id }" do
                page.accept_confirm { find('.comment-delete-button').click }
            end
            expect(page).not_to have_content comment_by_user.body
        end
    end

    describe 'コメントいいね' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary) }
        let!(:comment) { create(:comment, diary: diary) }
        context 'ログインユーザーの場合' do
            before do
                login_as user
            end
            
            it 'コメントいいねができるとともにいいね数が反映されること' do
                visit diary_path(diary) 
                expect {
                    within "#comment-#{ comment.id }" do
                        find('.comment-like-button').click
                        expect(page).to have_content "#{ comment.comment_likes.count }"
                        expect(page).to have_css '.comment-unlike-button'
                    end
                }.to change(user.like_comments, :count).by(1)
            end
            
            it 'コメントいいねの取り消しができるとともにいいね数が反映されること' do
                user.comment_like(comment)
                visit diary_path(diary) 
                expect {
                    within "#comment-#{ comment.id }" do
                        find('.comment-unlike-button').click
                        expect(page).to have_content "#{ comment.comment_likes.count }"
                        expect(page).to have_css '.comment-like-button'
                    end
                }.to change(user.like_comments, :count).by(-1)
            end
        end

        context 'ログインユーザーではない場合' do
            it 'コメントにコメントいいねフォームがないこと' do
                visit diary_path(diary) 
                within "#comment-#{ comment.id }" do
                    expect(page).not_to have_css '.comment-like-button'
                end
            end
        end
    end

    describe 'いいね' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary) }

        context 'ログインユーザーの場合' do
            before do
                login_as user
            end
            it 'ダイアリーにいいねができるとともにいいね数が反映されること' do
                visit diary_path(diary) 
                expect {
                    within "#like_area-#{ diary.id }" do
                        find('.like-button').click
                        #いいねした数がビューに反映されているかどうか
                        expect(page).to have_content "#{ diary.likes.count }"
                        expect(page).to have_css '.unlike-button'
                    end
                }.to change(user.like_diaries, :count).by(1)
            end
            
            it 'ダイアリーにいいねの取り消しができるとともにいいね数が反映されること' do
                user.like(diary)
                visit diary_path(diary) 
                expect {
                    within "#like_area-#{ diary.id }" do
                        find('.unlike-button').click
                        #いいね解除した数がビューに反映されているかどうか
                        expect(page).to have_content "#{ diary.likes.count }"
                        expect(page).to have_css '.like-button'
                    end
                }.to change(user.like_diaries, :count).by(-1)
            end
        end

        context 'ログインユーザーではない場合' do
            it 'ダイアリーにいいねフォームがないこと' do
                visit diary_path(diary) 
                expect(page).not_to have_css '.like-button'
            end
        end
    end

    describe '画像リセット' do
        let!(:user) { create(:user) }
        let!(:diary) { create(:diary, user: user) }
        before do
            login_as user
        end
        it 'ダイアリー編集ページで画像リセットができること' do
            visit edit_diary_path(diary)
            within "#uploader" do
                expect(page).to have_css '#preview_link'
                page.accept_confirm { click_link '画像をリセット' }
                expect(page).not_to have_css '#preview_link'
            end
        end
    end

    describe 'ダイアリー検索' do
        let!(:user) { create(:user) }
        let!(:diary_1) { create(:diary, body: "ダイアリー検索のダミーテキスト") }
        let!(:diary_2) { create(:diary, body: "2番目の検索用のダミーテキスト") }
        before do
            login_as user
        end
        context '検索値がある場合' do
            it '該当するダイアリーが表示されること' do
                within '#search__form' do
                    fill_in 'q[body]', with: 'ダミーテキスト'
                    click_button '検索'
                end
                expect(page).to have_content '「ダミーテキスト」でヒットしたダイアリー: 2件'
                expect(page).to have_content diary_1.body
                expect(page).to have_content diary_2.body
            end
            it '検索結果が何も表示されないこと' do
                within '#search__form' do
                    fill_in 'q[body]', with: 'ノーダイアリー'
                    click_button '検索'
                end
                expect(page).to have_content '「ノーダイアリー」でヒットしたダイアリー: 0件'
                expect(page).not_to have_content diary_1.body
            end
        end
        context '検索値がない場合' do
            it 'ページを移動しないで、エラーメッセージが表示されること' do
                visit diary_path(diary_1)
                within '#search__form' do
                    fill_in 'q[body]', with: ''
                    click_button '検索'
                end
                expect(page).to have_content '検索ワードを入力してください'
                expect(current_path).to eq diary_path(diary_1)
            end
        end
    end

    describe 'ダイアリー日数リセット' do
        let!(:user) { create(:user) }
        let!(:diary_1) { create(:diary, user: user) }
        let!(:diary_2) { create(:diary, user: user) }
        before do
            login_as user
        end
        it 'ダイアリー日数が順番通りに反映されていること' do
            travel_to 1.day.from_now do
                visit new_diary_path
                expect(page).to have_content 'ダイアリー3日目'
            end
        end
        it 'ダイアリー日数のリセットができるとともに、投稿が反映されていること', js: true do
            # 1日のダイアリー投稿数の制限がかかるので1日経過させておく
            travel_to 1.day.from_now do
                visit new_diary_path
                within '#post_form' do
                    page.accept_confirm { click_link 'リセット' }
                end
                expect(page).to have_content 'ダイアリー日数がリセットされました'
                within '#post_form' do
                    fill_in 'ダイアリー本文', with: '日数リセット後のダミーテキスト'
                    page.accept_confirm { click_button '投稿する' }
                end
                expect(page).to have_content 'ダイアリー1日目を投稿しました'
                expect(page).to have_content '日数リセット後のダミーテキスト'
            end
        end
    end
end