require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(url)
    html = Nokogiri::HTML(open(url))
    student_card = html.css(".student-card")
    
    student_list = student_card.map do |student|
      student_hash = {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a")[0].attributes["href"].value
      }
    end
  end

  def self.scrape_profile_page(profile_slug)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_slug))
    
    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
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

    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end

