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
    validates :code, presence: true
    validates :interval, presence: true
    validates :name, presence: true
    validates :price, presence: true
    enum interval: { month: 1, year: 2 }
end
