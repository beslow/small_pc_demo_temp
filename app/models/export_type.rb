class ExportType < ActiveRecord::Base
  has_many :automations
  validates :name, presence: true
end
