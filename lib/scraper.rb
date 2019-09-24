require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    student_array = []

    html = open(index_url)
    doc = Nokogiri::HTML(html)

    students = doc.css("div.student-card")

    students.each do |student|

      student_array << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a")[0]['href']
        # base url => html.base_uri.to_s[0..36]
      }

    end
    student_array
  end

  def self.scrape_profile_page(profile_url)

    profile_hash = {}

    html = open(profile_url)
    doc = Nokogiri::HTML(html)

    social_container = doc.css("div.social-icon-container")[0]
    social_links = social_container.css("a").map {|link| link['href']}

    social_links.each do |link|

      profile_hash[:twitter] = link if link.match(/twitter\.com/)
      profile_hash[:linkedin] = link if link.match(/linkedin\.com/)
      profile_hash[:github] = link if link.match(/github\.com/)
      profile_hash[:blog] = link if link.match(/^http:\/\/(?!github$|twitter$|linkedin$).*/)

    end

    profile_hash[:profile_quote] = doc.css("div.profile-quote").text.strip
    profile_hash[:bio] = doc.css(".bio-content .description-holder").first.text.strip

    profile_hash
  end

end
