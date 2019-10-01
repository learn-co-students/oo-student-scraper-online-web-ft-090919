require 'open-uri'
require 'pry'
#doc.css("div.student-card").first  = student card
#doc.css("div.student-card").first.css("div.card-text-container p").text   = location
#doc.css("div.student-card").first.css("div.card-text-container h4").text = name
#doc.css("div.student-card").first.css("a").attribute("href").value  = url

#doc.css("div.social-icon-container a").first.attribute("href").text  = profile links
#doc.css("div.social-icon-container a").first.css("img").attribute("src").value profile img link


#doc.css("div.profile-quote").text  = profile quote



class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    array = []
    doc.css("div.student-card").each do |student| 
      location = student.css("div.card-text-container p").text
      name = student.css("div.card-text-container h4").text
      profile_url = student.css("a").attribute("href").value

      var = {:name => name, :location => location, :profile_url => profile_url}
      array << var
    end
    array
    
    
    #binding.pry
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    
    hash = {
      :profile_quote=> doc.css("div.profile-quote").text,
      :bio=> doc.css("div.description-holder p").text}
    
    doc.css("div.social-icon-container a").each do |a| 
      case a.css("img").attribute("src").value
      when "../assets/img/twitter-icon.png"
        hash[:twitter] = a.attribute("href").value
      when "../assets/img/linkedin-icon.png"
        hash[:linkedin] = a.attribute("href").value
      when  "../assets/img/github-icon.png"
        hash[:github] = a.attribute("href").value
      when "../assets/img/rss-icon.png"
        hash[:blog] = a.attribute("href").value
      end
    end
    #binding.pry
    hash
  end

end

