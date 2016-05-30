class Library < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  validates :game, presence: true
  validates:game_id, uniqueness: { scope: :user_id }
end
