require 'open-uri'
require 'pry'
require "byebug"

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students_xml = doc.css("div .student-card")
    students_array = []
    students_xml.each do |student|
      name = student.css("div h4").text.strip
      location = student.css("p").text.strip
      profile_url = student.css("a").attribute("href").value
      student_hash = {
        :name => name,
        :location => location,
        :profile_url => profile_url
      }
      students_array << student_hash
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile = doc.css(".main-wrapper.profile")
    social_accounts = profile.css("div .social-icon-container a").map { |account| account.attribute("href").value }
    profile_quote = profile.css("div .profile-quote").text.strip
    bio = profile.css("div .description-holder p").text.strip
    student_hash = {}
    social_accounts.each do |account|
      if account.include?("twitter")
        student_hash[:twitter] = account
      elsif account.include?("linkedin")
        student_hash[:linkedin] = account
      elsif account.include?("github")
        student_hash[:github] = account
      else
        student_hash[:blog] = account
      end
    end
    student_hash[:profile_quote] = profile_quote
    student_hash[:bio] = bio
    student_hash
  end

end

