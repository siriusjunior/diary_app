# == Schema Information
#
# Table name: plans
#
#  id         :bigint           not null, primary key
#  code       :string(255)      not null
#  interval   :integer          not null
#  name       :string(255)      not null
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Plan < ApplicationRecord
end
