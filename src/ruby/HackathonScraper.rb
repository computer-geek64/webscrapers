#!/usr/bin/ruby
# HackathonScraper.rb

require "httparty"
require "nokogiri"


url = "https://devpost.com/hackathons"
options = Hash.new

if ARGV.length > 0
  query = ARGV.join("+")
  options[:search] = query
  options[:challenge_type] = ["all", "in-person", "online"][0]
  options[:sort_by] = ["Recently+Added", "Submission+Deadline", "Prize+Amount"][0]
  url << "?"
  options.each do |k, v|
    url << "#{k.to_s}=#{v}&"
  end
  url = url[0...-1]
end

response = HTTParty.get(url)
if response.code != 200
  puts "ERROR: Response code #{response.code}"
  exit(response.code)
end

document = Nokogiri::HTML.parse(response.body.to_s)

titles = document.css("h2.title").map {|x| x.text.strip}
links = document.css("a[data-role=featured_challenge]").map {|x| x["href"]}
descriptions = document.css("p.challenge-description").map {|x| x.text.strip}
locations = document.css("p.challenge-location").map {|x| x.text.strip}
prizes = document.css("i.fa-trophy + div.stat-content").map {|x| x.text.strip.split(" prizes")[0].split(" in")[0].gsub(" ", "")}
times = document.css("i.fa-clock + div.stat-content").map {|x| x.text.strip.split(" to submit")[0]}
participants = document.css("i.fa-user-friends + span.value").map {|x| x.text.strip}

puts "Names: #{titles.to_s}"
puts "Links: #{links.to_s}"
puts "Descriptions: #{descriptions.to_s}"
puts "Locations: #{locations.to_s}"
puts "Prizes: #{prizes.to_s}"
puts "Times: #{times.to_s}"
puts "Participants: #{participants.to_s}"
