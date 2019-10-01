require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    index = Nokogiri::HTML(html)
      index.css("div.student-card").each do |student|
        student_details = {}
        student_details[:name] = student.css("h4.student-name").text
        student_details[:location] = student.css("p.student-location").text
        student_details[:profile_url] = student.css("a").attribute("href").value
        students << student_details
  end
students

end
  #
  def self.scrape_profile_page(profile_url)
    student_profile = {}
     html = open(profile_url)
     profile = Nokogiri::HTML(html)
      profile.css("div.main-wrapper.profile .social-icon-container a").each do |social|
        if social.attribute("href").value.include?("twitter")
          student_profile[:twitter] = social.attribute("href").value
        elsif social.attribute("href").value.include?("linkedin")
          student_profile[:linkedin] = social.attribute("href").value
        elsif social.attribute("href").value.include?("github")
          student_profile[:github] = social.attribute("href").value
        else social.attribute("href").value.include?("blog")
          student_profile[:blog] = social.attribute("href").value
        end
end
  student_profile[:profile_quote] = profile.css("div.profile-quote").text
  student_profile[:bio] = profile.css("div.description-holder p").text
student_profile
end



    #   doc = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/"))
    # binding.pry

#index- doc.css("div.student-card").text
#student name: student.css("h4.student-name")
#location location.css("p.student-location")
#profile link doc.css("div.student a").attribute("href").value
end
