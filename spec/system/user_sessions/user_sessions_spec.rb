require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
    let(:user) { create(:user) }
    
    describe 'ログイン' do
        context '認証情報が正しい場合' do
            it 'ログインができること' do
                visit login_path
                fill_in 'メールアドレス', with: user.email
                fill_in 'パスワード', with: '12345678'
                click_button 'ログイン'
                expect(current_path).to eq diaries_path
                expect(page).to have_content 'ログインしました'
            end
        end
        context '認証情報に誤りがある場合' do
            it 'ログインができないこと' do
                visit login_path
                fill_in 'メールアドレス', with: user.email
                fill_in 'パスワード', with: '1234'
                click_button 'ログイン'
                expect(current_path).to eq login_path
                expect(page).to have_content 'ログインに失敗しました'
            end
        end
    end

    describe 'ログアウト' do
        before do
            login
        end
        it 'ログアウトできること' do
            page.accept_confirm do
                click_on('ログアウト')
            end
            expect(page).to have_content 'ログアウトしました'
            expect(current_path).to eq root_path
        end
    end
    
end