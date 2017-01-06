class ReplacementUniversity < ApplicationRecord
  validates :name, presence: true

  belongs_to :state
  has_many :colleges
  has_many :batch_applicants, through: :colleges
  has_many :founders, through: :colleges
  has_many :batch_applications, through: :batch_applicants
end
