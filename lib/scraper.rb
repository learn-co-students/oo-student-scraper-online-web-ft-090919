require 'open-uri'
#require 'nokogiri'
require 'pry'

class Scraper
  

  def self.scrape_index_page(index_url)
     students = []
    #puts "Hello"
   # html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/")
   
    doc = Nokogiri::HTML(open(index_url))
    
    doc.css(".roster-cards-container").each do |cards|
      cards.css(".student-card a").each do |student| 
        std_url = "#{student.attr('href')}"
        std_location = student.css(".student-location").text
        std_name = student.css(".student-name").text 
        students << {name: std_name, location: std_location, url: std_url}
        #binding.pry
      end 
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    links = profile_page.css(".social-icon-container").children.css("a").collect { |element_name| element_name.attribute('href').value}
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
    student
  end

end

