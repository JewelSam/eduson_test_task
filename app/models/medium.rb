class Medium < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :pictures, dependent: :destroy
  belongs_to :user

  validates :name, :user_id, presence: true
end
