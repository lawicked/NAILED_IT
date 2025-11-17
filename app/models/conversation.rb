class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :interview

  has_many :messages
  has_many :reports
end


# test
