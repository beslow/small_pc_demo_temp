class Part < ActiveRecord::Base
  belongs_to :partclass
  belongs_to :type
  belongs_to :property
  has_many :parameters, dependent: :destroy
  has_many :combos
  has_many :automations
  validates :property_id, presence: true
  #validates :no, presence: true, length: { maximum: 24 }
  validates :name, presence: true, length: { maximum: 20 }
  validates :class, presence: true
  #validates :classify_id, presence: true, length: { maximum: 2 }
  validates :description, length: { maximum: 100 }
  validates :table_row_num, length: { maximum: 2 }
  validates :table_column_num, length: { maximum: 2 }
  validates :table_line_type1, length: { maximum: 1 }
  validates :table_line_type2, length: { maximum: 1 }
  validates :table_line_color, length: { maximum: 2 }
  validates :name, uniqueness: { scope: :company_id }
end
