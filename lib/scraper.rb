require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)

    html = open(index_url)
    doc = Nokogiri::HTML(html)

    student_info = doc.css(".student-card a")
    student_info.collect do |element|
      
      {
        :name => element.css(".student-name").text,
        :location => element.css(".student-location").text,
        :profile_url => element.attr("href")
      }

    end
    
  end

  def self.scrape_profile_page(profile_url)
    
    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    hash = {}
    profile = doc.css(".vitals-container .social-icon-container a")
    profile.each do |element|

      if element.attr("href").include?("twitter")
        hash[:twitter] = element.attr("href")
      elsif element.attr("href").include?("linkedin")
        hash[:linkedin] = element.attr("href")
      elsif element.attr("href").include?("github")
        hash[:github] = element.attr("href")
      elsif element.attr("href").include?(".com/")
        hash[:blog] = element.attr("href")
      end
    end

    hash[:profile_quote] = doc.css(".profile-quote").text 
    hash[:bio] = doc.css(".description-holder p").text 

    hash

  end



end

