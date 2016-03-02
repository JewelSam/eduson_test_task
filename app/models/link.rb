class Link < ActiveRecord::Base
  belongs_to :medium

  validates :url, :medium_id, presence: true
end
