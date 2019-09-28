require 'open-uri'
require 'pry'

class Scraper
# :name
# :profile_url
# :location
  def self.scrape_index_page(index_url)

    doc = Nokogiri::HTML(open(index_url))
      students = []
      doc.css("div.student-card").each do |student|
        students << student = {
          :name => student.css("h4.student-name").text,
          :location => student.css("p.student-location").text,
          :profile_url => student.css("a").attribute("href").value
          }

      end
      students
    end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    hash = {}
          # hash[:name] = doc.css("h1.profile-name").text
          # hash[:location] = doc.css("h2.profile-location").text
          hash[:profile_quote] = doc.css('div.profile-quote').text
          hash[:bio] = doc.css("div.description-holder p").text
          ###########################works###################################
          social_media = doc.css("div.social-icon-container a")
            if social_media
          social_media = social_media.map { |site| site.attribute("href").value }
            social_media.each do |check|
              ####WORKKKSSSSS!######
                  if check.include?("twitter")
                    hash[:twitter] = check
                  elsif check.include?("linkedin")
                      hash[:linkedin] = check
                  elsif check.include?("github")
                        hash[:github] = check
                  else
                        hash[:blog] = check
                  end
              end

              def not_for_scrape_but_ok
                students_array.each do |student_hash|
                self.new(student_hash)
              binding.pry
              end


              end
            end
          hash
  end
# #  describe "#scrape_profile_page" do
# #    it "is a class method that scrapes a student's profile page and returns a hash of attributes describing an individual student" do
# #      profile_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/students/joe-burgess.html"
# #      scraped_student = Scraper.scrape_profile_page(profile_url)
# #      expect(scraped_student).to be_a(Hash)
# #      expect(scraped_student).to match(student_joe_hash)
# #    end
# #
# #    it "can handle profile pages without all of the social links" do
# #      profile_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/students/david-kim.html"
# #      scraped_student = Scraper.scrape_profile_page(profile_url)
# #      expect(scraped_student).to be_a(Hash)
# #      expect(scraped_student).to match(student_david_hash)
# #    end
# #  end
end
# {:twitter=>"https://twitter.com/jmburges", :linkedin=>"https://www.linkedin.com/in/jmburges",
#   :github=>"https://github.com/jmburges", :blog=>"http://joemburgess.com/",
#   :profile_quote=>"\"Reduce to a previously solved problem\"",
#   :bio=>"I grew up outside of the Washington DC (NoVA!) and went to college at Carnegie Mellon
#   University in Pittsburgh. After college, I worked as an Oracle consultant for IBM for a bit
#   and now I teach here at The Flatiron School."}
