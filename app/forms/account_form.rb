class AccountForm
    include ActiveModel::Model
    attr_accessor :avatar, :username, :introduction, :labels, :avatar_cache

    validates :username, presence: true
    validates :introduction, length: { maximum: 150 }
    validate :label_length

    def label_length
        tag_list = set_label_list
        if tag_list
            tag_list.each { |tag| if tag.length > 5 then errors.add(:labels, "の最大文字数は5文字です") end }
        end
    end

    delegate :persisted?, to: :user

    def initialize(attributes = nil, user: User.new)
        @user = user
        attributes ||= default_attributes
        super(attributes)
    end

    def save
        ActiveRecord::Base.transaction do
            # 配列に戻す
            labels = set_label_list
            user.add_tag!(labels)
            user.update!(avatar: avatar, username: username, introduction: introduction)
        end
        rescue ActiveRecord::RecordInvalid
        false
    end

    def to_model
        user
    end

    private

        attr_reader :user

        def default_attributes
            {
                avatar: user.avatar,
                username: user.username,
                introduction: user.introduction,
                labels: user.tags.pluck(:name).join(",")
            }  
        end

        def set_label_list
            labels.split(",")
        end
end