require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    scraped_students = []

    doc.css('div.student-card').each do |student|
      name = student.css('.student-name').text
      location = student.css('.student-location').text
      profile_url = student.css('a').attribute('href').value
      info = {
        name: name,
        location: location,
        profile_url: profile_url
      }
      scraped_students << info
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    students = {}

    social = doc.css('.social-icon-container a').collect { |student| student.attribute('href').value }
    social.each do |url|
      if url.include?('twitter')
        students[:twitter] = url
      elsif url.include?('linkedin')
        students[:linkedin] = url
      elsif url.include?('github')
        students[:github] = url
      elsif url.include?('.com')
        students[:blog] = url
      end
    end
    students[:profile_quote] = doc.css('.profile-quote').text
    students[:bio] = doc.css('div.description-holder p').text
    students
    end
  end
