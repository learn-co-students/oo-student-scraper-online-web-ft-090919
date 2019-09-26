require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = open_url(index_url)
    student_cards = doc.css("div.roster-cards-container div.student-card a")
    student_cards.map do |student_card|
      card_text = student_card.css("div.card-text-container")
      {
        name: card_text.css("h4.student-name").text,
        location: card_text.css("p.student-location").text,
        profile_url: student_card.attribute("href").value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = open_url(profile_url)
    student_hash = {}

    #Add basics to hash
    student_hash[:profile_quote] = doc.css("div.profile-quote").text
    student_hash[:bio] = doc.css("div.description-holder p").text

    #Get all of the a's containing social media links, then map them to strings storing the url
    socials = doc.css("div.social-icon-container a").map { |a| a.attribute("href").value }

    #Add each social url to the student hash
    socials.each do |social|
      #Extract site name out of url
      site = social.reverse.scan(/\.(.+?)[\/.]/).first.first.reverse
      #Key is symbol version of site if it's a known site, otherwise it's a blog
      key = ["github", "linkedin", "twitter"].include?(site) ? site.to_sym : :blog
      student_hash[key] = social
    end
    student_hash
  end

  private
  def self.open_url(url)
    Nokogiri::HTML(open(url))
  end

end
