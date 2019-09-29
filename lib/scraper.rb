require 'open-uri'
require 'pry'
require 'nokogiri'
class Scraper
  
  def self.scrape_index_page(index_url)
    students = []
    
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    doc.css("div.student-card").each do |student|
     student_info = {}
     student_info[:name] = student.css(".student-name").text
      student_info[:location] = student.css(".student-location").text
      student_info[:profile_url] = student.css("a").attribute("href").value
      
      students << student_info
      
    end 
    students
  end
    
  

 def self.scrape_profile_page(profile_url)
      page = Nokogiri::HTML(open(profile_url))
      output_hash = {}

      # student[:profile_quote] = page.css(".profile-quote")
      # student[:bio] = page.css("div.description-holder p")
      container = page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
      container.each do |link|
        if link.include?("twitter")
          output_hash[:twitter] = link
        elsif link.include?("linkedin")
          output_hash[:linkedin] = link
        elsif link.include?("github")
          output_hash[:github] = link
        elsif link.include?(".com")
          output_hash[:blog] = link
        end
      end
      output_hash[:profile_quote] = page.css(".profile-quote").text 
      output_hash[:bio] = page.css("div.description-holder p").text
      output_hash
      #binding.pry
  end
    
      
  
    
    
    


end 


