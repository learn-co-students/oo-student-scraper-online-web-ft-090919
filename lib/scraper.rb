require 'open-uri'
require 'pry'

class Scraper

  
  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    all_students = doc.css(".student-card")
    all_students.each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      url = student.css("a").attribute("href").value
      students << {:name => name, :location => location, :profile_url => url}
    end
    students
  end
  
  def self.scrape_profile_page(profile_url)
    student = {}
    profile = Nokogiri::HTML(open(profile_url))
    links = profile.css(".social-icon-container").children.css("a").map { |link| link.attribute('href').value} 
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = profile.css(".profile-quote").text if profile.css(".profile-quote")
    student[:bio] = profile.css("div.bio-content.content-holder div.description-holder p").text if profile.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end