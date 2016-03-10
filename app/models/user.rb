class User < ActiveRecord::Base
  has_many :librarys
  has_many :games, through: :librarys
  
  before_save { self.email = email.downcase }
  validates :username, presence: true, length: { maximum: 60 }
  
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def add(game)
    @game = Game.find_by(id: game.id)
    self.librarys.create(game: @game)
  end
  
  def remove(game)
    @game = Game.find(game.id)
    librarys.find_by(game_id: @game.id).destroy
  end
  
  
  
end
