require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    html = open(index_url)
    
    doc = Nokogiri::HTML(html)
    student_cards = doc.css('.student-card')
    info_hash_array = student_cards.map { |card| {
        :name => card.css('.student-name').map { |element| element.text }.first,
        :location => card.css('.student-location').map { |element| element.text }.first,
        :profile_url => card.css('a').map { |a| a["href"] }.first
      }
    }
    # puts info_hash_array
    # We need :name, :location and :profile_url
    # binding.pry
  end
  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    
    doc = Nokogiri::HTML(html)
    bio = doc.css('.description-holder p').map { |element| element.text }.first
    # puts bio

    quote = doc.css('.profile-quote').map { |element| element.text }.first

    # puts quote

    return_hash = doc.css('.social-icon-container a').inject({
      :bio => bio,
      :profile_quote => quote
    }) { |profile_hash, a|
      img_type = a.css('img').map { |img| img["src"]}.first.split('/').last
      href = a['href']

      if img_type == 'twitter-icon.png'
        profile_hash[:twitter] = href
      elsif img_type == 'linkedin-icon.png'
        profile_hash[:linkedin] = href
      elsif img_type == 'github-icon.png'
        profile_hash[:github] = href
      elsif img_type == 'rss-icon.png'
        profile_hash[:blog] = href
      end
      profile_hash
    }
    # puts return_hash
    return_hash
  end
end

