class Combo < ActiveRecord::Base
  belongs_to :part
  validates :sort, presence: true, length: { maximum: 2 }
  validates :part_id, presence: true
  validates :sub_part_id, presence: true
end
