require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーション' do
    it '本文は必須であること' do
      diary = build(:diary, body: nil)
      diary.valid?
      expect(diary.errors[:body]).to include('を入力してください')
    end
    
    it '本文は最大500文字であること' do
      diary = build(:diary, body: 'a'*501)
      diary.valid?
      expect(diary.errors[:body]).to include('は500文字以内で入力してください')
    end

    describe 'スコープ' do
      describe 'body_contain' do
        let!(:diary){ create(:diary, body: 'hello world!') }
        subject { Diary.body_contain('hello') }
        it { is_expected.to include diary }
      end

      describe 'thumbnail' do
        let!(:diary_with_image){ create(:diary)}
        let!(:diary_with_noimage){ create(:diary, image: nil)}
        subject { Diary.thumbnail }
        it { is_expected.to include diary_with_image }
        it { is_expected.not_to include diary_with_noimage }
      end

      describe 'recent' do
          let!(:diary_first) { create(:diary, created_at: Time.zone.now) }
          let!(:diary_last) { create(:diary, created_at: 1.hour.ago) }
          before do
            create_list(:diary, 5, created_at: 10.minutes.ago)
          end
          context '最新のダイアリーが含まれること' do
            subject { Diary.recent(1) }
            it { is_expected.to include diary_first}
          end
          context '最新ではないダイアリーが含まれないこと' do
            subject { Diary.recent(6) }
            it { is_expected.not_to include diary_last }
          end
        end
    end
  end
end
