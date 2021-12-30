# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  body        :text(65535)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chatroom_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_messages_on_chatroom_id  (chatroom_id)
#  index_messages_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chatroom_id => chatrooms.id)
#  fk_rails_...  (user_id => users.id)
#
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :body, presence: true, length: { maximum: 300 }
  validate :number_of_times

  # 契約状況に応じた制御
  def number_of_times
    return if user.subscripting_premium_plan?
    # subscripting?でlatest_contract.current_period_startは有効期間内のpaymentを持つ
    return if user.subscripting_basic_plan? &&
              user.messages
                  .where(created_at: user.latest_contract.current_period_start...user.latest_contract.current_period_end)
                  .size < 20
                  # 20件目の投稿は可能
    # 契約期間が切れた,未契約者の制限,10件目の投稿は可能
    return if user.messages.size <= 10
    errors.add(:base, '今月のメッセージ可能回数をオーバーしました。')
  end
  
end
