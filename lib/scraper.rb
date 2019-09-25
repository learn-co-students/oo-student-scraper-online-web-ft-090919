require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = page.css("div.roster-cards-container .student-card")
    students.collect do |student|
      {name: student.css(".student-name").text,
      location: student.css(".student-location").text,
      profile_url: student.css("a").attribute("href").value}
    end
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    page = Nokogiri::HTML(open(profile_url))
    links = page.css("div.social-icon-container a").collect { |a| a.attribute('href').value}
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
    
    {twitter: "http://twitter.com/flatironschool",
    linkedin: "https://www.linkedin.com/in/flatironschool",
    github: "https://github.com/learn-co",
    blog: "http://flatironschool.com",
    profile_quote: "\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
    bio:  "I'm a school" }
    
  end

end

