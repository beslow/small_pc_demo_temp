class Automation < ActiveRecord::Base
  belongs_to :part
  belongs_to :export_type
  has_many :auto_parameters , dependent: :destroy
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :part_id, presence: true
  validates :export_type_id, presence: true
end