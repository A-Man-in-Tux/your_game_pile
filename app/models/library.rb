class Library < ActiveRecord::Base
  belongs_to :user 
  belongs_to :game
  
  validates :game, presence: true
  validates_uniqueness_of :game_id, scope: :user_id
end
