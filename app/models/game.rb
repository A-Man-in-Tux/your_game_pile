class Game < ActiveRecord::Base

  has_many :librarys
  has_many :users, through: :librarys

  serialize :api_data, JSON
  serialize :platforms, JSON

  has_attached_file :image, styles: { medium: '272x380>', thumb: '157x218!' }, default_url: 'temp_pic.jpg',
    path: ":rails_root/public/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/game_images/:style/:basename.:extension",
    url: "/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/game_images/:style/:basename.:extension"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates :api_id, presence: true, uniqueness: true

  scope :a_z, -> { order 'title asc' }
  scope :z_a, -> { order 'title desc' }

  def image_from_url(url)
    self.image = URI.parse(url)
  end

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def self.filter(filter, games)
    if filter == 'a-z'
      games.sort_by(&:title)
    end
    if filter == 'z-a'
      games.sort_by(&:title).reverse
    end
  end

  def self.giantbomb_search(search)
    api_key = ENV['FB_APP_ID']
    base_url = 'http://www.giantbomb.com/api'
    search_url = base_url + '/search/' + '?' + 'api_key=' + api_key.to_s +
      '&format=json&query=' + %Q["#{search}"] + '&resources=game' + '&limit=8'

    uri = URI(search_url)

    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    giantbomb_results(data)
  end

  def self.giantbomb_results(data)
    games = Array.new
    data['results'].each do |x|
      game = { title: x['name'].to_s, image_url: x['image']['small_url'].to_s,
      api_id: x['id'].to_s, api_url: x['api_detail_url'].to_s,
      api_data: x }
      platforms = Array.new
      x['platforms'].each do |y|
        platform = { name: y['name'].to_s, id: y['id'].to_s, api_url: y['api_detail_url'].to_s }
        platforms << platform
      end
      game.store('platforms', platforms)
      games << game
    end
  end

  def self.fetch_price
    Rails.cache.fetch("#{cache_key}/price", expires_in: 6.hours) do
      # pull price from ebay api
    end
  end
end
