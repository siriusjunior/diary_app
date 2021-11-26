require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it 'ユーザー名は必須であること' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'メールアドレスは必須であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスは一意であること' do
      user = create(:user)
      same_email_user = build(:user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end
  end

  describe 'インスタンスメソッド' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }
    let!(:diary_by_user_a) { create(:diary, user: user_a) }
    let!(:diary_by_user_b) { create(:diary, user: user_b) }
    let!(:diary_by_user_c) { create(:diary, user: user_c) }
    let!(:comment_by_user_b) { create(:comment, diary: diary_by_user_a, user: user_b) }
    describe 'own?' do
      context '自分のオブジェクトの場合' do
        it 'trueを返す' do
          expect(user_a).own?(diary_by_user_a).to be true
        end
      end

      context '自分のオブジェクトではない場合' do
        it 'falseを返す' do
          expect(user_a).own?(diary_by_user_b).to be false
        end
      end
    end

    describe 'like' do
      it 'いいねできること' do
        expect { user_a.like(diary_by_user_b) }.to change { Like.count }.by(1)
      end
    end

    describe 'unlike'
      it 'いいねを解除できること' do
        user_a.like(diary_by_user_b)
        expect { user_a.unlike(diary_by_user_b) }.to change { Like.count }.by(-1)
      end
    end

    describe 'like?' do
      context 'いいねしている場合' do
        it 'trueを返す' do
          user_a.like(diary_by_user_b)
          expect { user_a.like?(diary_by_user_b) }.to be true
        end
      end
      context 'いいねしていない場合' do
        it 'falseを返す' do
          expect { user_a.like?(diary_by_user_b) }.to be false
        end
      end
    end

    describe 'comment_like' do
      it 'コメントいいねできること' do
        expect { user_a.comment_like(ccomment_by_user_b) }.to change { CommentLike.count }.by(1)
      end
    end

    describe 'comment_unlike'
      it 'コメントいいねを解除できること' do
        user_a.comment_like(comment_by_user_b)
        expect { user_a.comment_unlike(comment_by_user_b) }.to change { CommentLike.count }.by(-1)
      end
    end

    describe 'comment_like?' do
      context 'コメントいいねしている場合' do
        it 'trueを返す' do
          user_a.comment_like(comment_by_user_b)
          expect { user_a.comment_like?(comment_by_user_b) }.to be true
        end
      end
      context 'コメントいいねしていない場合' do
        it 'falseを返す' do
          expect { user_a.comment_like?(comment_by_user_b) }.to be false
        end
      end
    end

    describe 'like?' do
      context 'いいねしている場合' do
        it 'trueを返す' do
          user_a.like(diary_by_user_b)
          expect { user_a.like?(diary_by_user_b) }.to be true
        end
      end
      context 'いいねしていない場合' do
        it 'falseを返す' do
          expect { user_a.like?(diary_by_user_b) }.to be false
        end
      end
    end

    describe 'follow' do
      it 'フォローできること' do
        expect { user_a.follow(user_b) }.to cahge { Relationship.count }.by(1)
      end
    end
    
    describe 'unfollow' do
      it 'フォローが解除できること' do
        user_a.follow(user_b)
        expect { user_a.unfollow(user_b) }.to cahge { Relationship.count }.by(-1)
      end
    end
    
    describe 'following?' do
      context 'フォローしている場合' do
        it 'trueを返す' do
          user_a.follow(user_b)
          expect { user_a.following?(user_b) }.to be true
        end
      end
      context 'フォローしていない場合' do
        it 'falseを返す' do
          expect { user_a.following?(user_b) }.to be false
        end
      end
    end

    describe 'feed' do
      before do
        user_a.follow(user_b)
      end
      subject { user_a.feed}
      it { is_expected.to include diary_by_user_a }
      it { is_expected.to include diary_by_user_b }
      it { is_expected.not_to include diary_by_user_c }
    end

    describe 'cannot_post?' do
      context  '1日以内に投稿した場合' do
        it 'trueを返す' do
          create(:diary, user: user_a, created_at: Time.zone.now)
          expect(user_a.cannot_post?).to be true
        end
      end
      context  '1日以内に投稿していない場合' do
        it 'falseを返す' do
          expect(user_a.cannot_post?).to be false
        end
      end
    end

    describe 'add_tag!' do
      labels = ["料理", "温泉", "音楽"]
      
      context 'タグが存在しない場合' do
        it 'タグとタグリンクが作成されること' do
          expect { user_a.add_tag!(labels) }.to cahge { Tag.count }.by(3).
            and change { TagLink.count }.by(3)
        end
      end

      context 'タグが存在する場合' do
        it '登録タグがない場合は、タグとタグリンクが削除されること' do
          user_a.add_tag!(labels)
          expect { user_a.add_tag!() }.to cahge { Tag.count }.by(-3).
            and change { TagLink.count }.by(-3)
        end
        it '登録タグがない、かつ他ユーザーがタグを登録中の場合は、タグが残り、タグリンクだけが削除されること' do
          user_a.add_tag!(labels)
          user_b.add_tag!(labels)
          expect { user_a.add_tag!() }.to cahge { Tag.count }.by(0).
            and change { TagLink.count }.by(-3)
        end
      end
      
    end
  end
end
