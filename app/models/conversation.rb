class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :interview

  has_many :messages, dependent: :destroy
  has_many :reports, dependent: :destroy
end


# test
