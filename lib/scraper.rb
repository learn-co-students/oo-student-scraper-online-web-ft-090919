require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc_data = Nokogiri::HTML.parse(html)
    person_info = [] #array of hashes {:name => "Abby Smith", :location => "Brooklyn, NY", :profile_url => "students/abby-smith.html"}

    #NAME = doc_data.css("div .student-card")[0].css(".student-name").text
    #LOCATION = doc_data.css("div .student-card")[0].css(".student-location").text
    #PROFILE = doc_data.css("div .student-card")[0].css("a").attr("href").value

    doc_data.css("div .student-card").each do |person|
      name = person.css(".student-name").text
      location = person.css(".student-location").text
      profile = person.css("a").attr("href").value
      person_info << {:name => name, :location => location, :profile_url => profile}
    end
    person_info
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc_data = Nokogiri::HTML.parse(html)
    new_hash = {}
    profile_info = []
    #scrape Twitter URL, LinkedIn URL, GitHub URL, blog URL, profile quote, and bio
    # doc_data.css("div .social-icon-container").css("a")[3].attr("href")
    doc_data.css("div .social-icon-container").css("a").each do |social|
      new_hash[:twitter] = social.attr("href") if social.attr("href").include? "twitter"
      new_hash[:linkedin] = social.attr("href") if social.attr("href").include? "linkedin"
      new_hash[:github] = social.attr("href") if social.attr("href").include? "github"
      if !(social.attr("href").include? "github") && !(social.attr("href").include? "linkedin") &&
         !(social.attr("href").include? "twitter") && (social.attr("href").include? ".com")
         new_hash[:blog] = social.attr("href")
       end
    end
    new_hash[:profile_quote] = doc_data.css("div .profile-quote").text #.gsub!(/[\"]/, "")
    new_hash[:bio] = doc_data.css("div .description-holder p").text
    new_hash
  end

end
