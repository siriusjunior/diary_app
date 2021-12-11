# == Schema Information
#
# Table name: contracts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_contracts_on_plan_id  (plan_id)
#  index_contracts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#  fk_rails_...  (user_id => users.id)
#
class Contract < ApplicationRecord
  belongs_to :plan
  belongs_to :user
  has_many :payments, dependent: :restrict_with_error
  has_one :contract_cancellation, dependent: :restrict_with_error
end
