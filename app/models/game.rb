class Game < ActiveRecord::Base
    has_many :librarys
    has_many :users, through: :librarys
    
    serialize :api_data, JSON
    
    has_attached_file :image, styles: {medium: "272x380>", thumb: "157x218!"}, default_url: "temp_pic.jpg", 
        path:":rails_root/public/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/game_images/:style/:basename.:extension",
        url:"/#{Rails.env}#{ENV['RAILS_TEST_NUMBER']}/game_images/:style/:basename.:extension"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ 
    
    validates :api_id, presence: true, uniqueness: true
    
    def image_from_url(url)
       self.image = URI.parse(url) 
    end
    
    
    def self.search(search)
        if search
            where('title LIKE ?', "%#{search}%")
        else
            all
        end
    end
    
    def self.giantbomb_search(search)
        api_key = ENV['FB_APP_ID']
        base_url = "http://www.giantbomb.com/api"
        search_url = base_url + "/search/" + "?" + "api_key=" + "#{api_key}" +
                    "&format=json&query=" + %Q["#{search}"] + "&resources=game"
        uri = URI(search_url)
                    
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        games = Array.new
        
        data["results"].each do |x|
          
         games << {title: "#{x['name']}", image_url: "#{x['image']['small_url']}", 
                    api_id: "#{x['id']}", api_url: "#{x['api_detail_url']}", 
                    api_data: x}
            
        end
        return games
    
    end
    
end
