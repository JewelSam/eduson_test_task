class Picture < ActiveRecord::Base
  belongs_to :medium

  validates :medium_id, presence: true

  has_attached_file :image, styles: { thumb: "150x150#" }
  validates_attachment :image, presence: true,
                       content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
                       size: { in: 0..3.megabytes }
end
