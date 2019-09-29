require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative './course.rb'

class Scraper
  
  def get_page 
    doc = Nokogiri::HTML(open("http://learn-co-curriculum.github.io/site-for-scraping/courses"))
  end 
  
  def get_courses
    self.get_page.css(".post")
  end 
  
  def make_courses 
    self.get_courses.each do |post|
      course = Course.new 
      course.title = post.css("h2").text 
      course.schedule = post.css(".date").text 
      course.description = post.css("p").text
    end 
  end 
    
  def print_courses
    self.make_courses
    Course.all.each do |course|
      if course.title && course.title != ""
        puts "Title: #{course.title}"
        puts "  Schedule: #{course.schedule}"
        puts "  Description: #{course.description}"
      end
    end
  end
  
end

# collection of courses: doc.css(".post")
# title: doc.css(".post").first.css("h2").text
# schedule: doc.css(".post").first.css(".date").text
# description: doc.css(".post").first.css("p").text

__________________________________________________________


def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_info = {:name => name,
                :location => location,
                :profile_url => profile_url}
      students << student_info
      end
    students
   end
   
   __________________________________________________________
   
   
  def self.scrape_profile_page(profile_url)
      page = Nokogiri::HTML(open(profile_url))
      student = {}

      # student[:profile_quote] = page.css(".profile-quote")
      # student[:bio] = page.css("div.description-holder p")
      
      container = page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
      container.each do |link|
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
      student[:profile_quote] = page.css(".profile-quote").text
      student[:bio] = page.css("div.description-holder p").text
      student
  end