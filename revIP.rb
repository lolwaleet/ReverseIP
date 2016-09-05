require 'colorize'
require 'net/http'
require 'json'

sep      = ('-'*60).colorize(:cyan)
leets    = [ 'T3N38R15', 'MakMan', 'Maini', 'MithaiWala' ] 

puts ' _____                              _____ _____  
|  __ \                            |_   _|  __ \ 
| |__) |_____   _____ _ __ ___  ___  | | | |__) |
|  _  // _ \ \ / / _ \ \'__/ __|/ _ \ | | |  ___/ 
| | \ \  __/\ V /  __/ |  \__ \  __/_| |_| |     
|_|  \_\___| \_/ \___|_|  |___/\___|_____|_| ~ by '.colorize(:yellow) + 'AnonGuy'.colorize(:magenta)

print 'Greets to ~ '.colorize(:green)
leets.each { |leet| if (leet == leets.last) then (puts leet.colorize(:cyan)) else (print leet.colorize(:cyan) + ' -- ') end } # .. I know.
puts sep

print 'IP/Domain --> '.colorize(:red)
ip     = gets.chomp

json   = Net::HTTP.post_form(URI.parse('http://domains.yougetsignal.com/domains.php'), { 'remoteAddress' => ip, 'key' => '' }).body
parsed = JSON.parse(json)
puts sep

def statusCode(site)
	response = ''
	begin
		Net::HTTP.start(site, 80) {|http|
			response = http.head('/')
		}
		return response.code
	rescue StandardError
		return ':('
	end
end

if parsed['status'] == 'Fail'
	abort('[!] '.colorize(:red) + parsed['message'].split('. ')[0] + "\n#{sep}\n")
else
	puts 'Target            -- '.colorize(:red) + parsed['remoteIpAddress']
	puts 'Number of Domains -- '.colorize(:red) + parsed['domainCount']; len = parsed['domainCount']
	puts sep

	domains = parsed['domainArray']
	puts 'Domains -- '.colorize(:red)
	domains.each.with_index(1) { |domain, index|
		puts '[ '.colorize(:cyan) + (if(len.length == 2) then(index.to_s.rjust(2, '0').colorize(:red)) elsif(len.length == 3) then(index.to_s.rjust(3, '0').colorize(:red)) else (index.to_s.colorize(:red)) end) + ' ]'.colorize(:cyan) + ' -- '+ '[ '.colorize(:cyan) + domain[0].colorize(:green) + ' ]'.colorize(:cyan) + ' -- ' + '[ '.colorize(:cyan) + statusCode(domain[0]).colorize(:yellow) + ' ]'.colorize(:cyan) # .. don't
	}
end