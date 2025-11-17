class Interview < ApplicationRecord
  has_many :conversations

  validates :body, presence: true
  validates :target_role, presence: true
  validates :seniority, presence: true
  validates :language, presence: true
end
