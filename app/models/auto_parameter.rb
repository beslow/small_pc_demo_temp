class AutoParameter < ActiveRecord::Base
  belongs_to :automation
  has_one :parameter
  validates :automation_id, presence: true
  validates :parameter_id, presence: true
end
