require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe 'バリデーション' do
    it '本文は必須であること' do
      diary = build(:diary, body: nil)
      diary.valid?
      expect(diary.errors[:body]).to include('を入力してください')
    end
  end
end
