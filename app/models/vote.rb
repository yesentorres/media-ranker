class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  # ensures user cannot upvote a work more than once
  validates :user, uniqueness: { scope: :work, message: "has already voted for this work" }
end
