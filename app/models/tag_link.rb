# == Schema Information
#
# Table name: tag_links
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tag_links_on_tag_id              (tag_id)
#  index_tag_links_on_user_id             (user_id)
#  index_tag_links_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
class TagLink < ApplicationRecord
    belongs_to :user
    belongs_to :tag
end
