require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper


  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    all_students = doc.css(".student-card")
    all_students.each { |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      url = student.css("a").attribute("href").value
      students << {:name => name, :location => location, :profile_url => url}
    }
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_links = doc.css(".vitals-container .social-icon-container a")
    social_links.each { |link|
      if link.attribute("href").text.include?("twitter")
        profile_hash[:twitter] = link.attribute("href").text
      elsif link.attribute("href").text.include?("linkedin")
        profile_hash[:linkedin] = link.attribute("href").text
      elsif link.attribute("href").text.include?("github")
        profile_hash[:github] = link.attribute("href").text
      else
        profile_hash[:blog] = link.attribute("href").text
      end
    }
    profile_quote = doc.css(".vitals-text-container .profile-quote").text
    bio = doc.css(".details-container .description-holder p").text
    profile_hash[:profile_quote] = profile_quote
    profile_hash[:bio] = bio
    profile_hash
  end

end

