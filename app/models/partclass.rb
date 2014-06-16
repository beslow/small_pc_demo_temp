class Partclass < ActiveRecord::Base
  has_many :parts
  validates :name, presence: true, length: { maximum: 20 }
end
