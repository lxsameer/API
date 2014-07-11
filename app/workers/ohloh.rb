require 'net/http'
require 'rexml/document'


api_key = 'eBziSrPVdYY0FrRpXFqtdg'
response = Net::HTTP.get_response("www.ohloh.net", "/accounts/lxsameer.xml?v=1&api_key=#{api_key}", 80)



if response.code != '200'
  STDERR.puts "#{response.code} - #{response.message}"
  exit 1
end

# Parse the response into a structured XML object
xml = REXML::Document.new(response.body)
# Did Ohloh return an error?
error = xml.root.get_elements('/response/error').first
if error
  STDERR.puts "#{error.text}"
  exit 1
end

# Output all the immediate child properties of an Account
xml.root.get_elements('/response/result/account').first.each_element do |element|
  puts "#{element.name}:\t#{element.text}" unless element.has_elements?
end

xml_kudo_rank = xml.root.get_elements('/response/result/account/kudo_score/kudo_rank').first
kudo_rank = xml_kudo_rank ? xml_kudo_rank.text.to_i : 1
position = xml.root.get_elements('/response/result/account/kudo_score/position').first.text
c = 0
xml.root.get_elements('/response/result/account/languages/language/total_commits').each do |l|
  c += l.text.to_i
end

puts "c<<>>>>>>>>>>>> #{c}"
