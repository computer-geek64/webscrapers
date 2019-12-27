#!/usr/bin/ruby
# ApacheWebscraper.rb

require "httparty"
require "nokogiri"


url = ARGV.length == 1 ? ARGV[0] : "http://localhost/"
response = HTTParty.get(url)
document = Nokogiri::HTML.parse(response.body.to_s)


title = document.css("title")[0].text.strip
current_directory = title.split("Index of ")[-1].strip

entries = document.css("tr > td > a").map(&:text)
directories = entries.select do |x| x.to_s.end_with?("/") && !x.to_s.include?("Parent Directory") end
files = entries.select do |x| !x.to_s.end_with?("/") && !x.to_s.include?("Parent Directory") end
puts "Current Directory: #{current_directory}"
puts "Directories: #{directories.to_a.to_s}"
puts "Files: #{files.to_a.to_s}"
