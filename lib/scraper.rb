require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    web_page = Nokogiri::HTML(open(index_url))
    students = []
    web_page.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_page = student.css("a").attribute("href").value
      student_info = {
        :name => name,
        :location => location,
        :profile_url => profile_page
      }
      students << student_info
      end
    students
  end

  def self.scrape_profile_page(profile_url)
    web_page = Nokogiri::HTML(open(profile_url))
      student = {}
      containers = web_page.css(".social-icon-container a").collect {|icon| icon.attribute("href").value}
      containers.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        elsif link.include?(".com")
          student[:blog] = link
        end
      end
      student[:profile_quote] = web_page.css(".profile-quote").text
      student[:bio] = web_page.css("div.description-holder p").text
      student
  end

end

