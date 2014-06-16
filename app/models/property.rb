class Property < ActiveRecord::Base
  belongs_to :company
  has_many :parts
  validates :company_id, presence: true
  validates :code, presence: true, length: { maximum: 20 }
  validates :name, presence: true, length: { maximum: 40 }
  validates :propertyID, presence: true, length: { maximum: 10 }
end
