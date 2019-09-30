require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    student_index_array = []
    site = Nokogiri::HTML(open(index_url))
    
    site.css(".student-card").each do |student| 
      
      student_index_array << student_hash = {
      :name => student.css(".student-name").text,
      :location => student.css(".student-location").text,
      :profile_url => student.css("a").attribute('href').value
      }

    end 
    student_index_array
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    attr_hash = {}
    
      profile.css(".social-icon-container a").each do |social|
          if social.attr("href").include?("twitter")
            attr_hash[:twitter] = social.attr("href") 
          elsif social.attr("href").include?("linkedin")
            attr_hash[:linkedin] = social.attr("href") 
          elsif social.attr("href").include?("github")
            attr_hash[:github] = social.attr("href") 
          elsif social.attr("href").include?(".com/")
          attr_hash[:blog] = social.attr("href") 
          end   
      end 
      
    attr_hash[:profile_quote] = profile.css("div.profile-quote").text 
    attr_hash[:bio] = profile.css("p").text 
    attr_hash
    
  end 

end

