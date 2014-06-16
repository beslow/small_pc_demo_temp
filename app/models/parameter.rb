class Parameter < ActiveRecord::Base
  belongs_to :part
  belongs_to :auto_parameter
  validates :part_id, presence: true
  validates :name, presence: true, length: { maximum: 20 }
  validates :description, length: { maximum: 100 }
end
