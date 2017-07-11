require 'json'
require 'colorize'
require 'net/http'
require 'mechanize'

sep      = ('-'*85).colorize(:cyan)
leets    = [ 'T3N38R15', 'MakMan', 'Maini', 'MithaiWala' ] 

puts ' _____                              _____ _____  
|  __ \                            |_   _|  __ \ 
| |__) |_____   _____ _ __ ___  ___  | | | |__) |
|  _  // _ \ \ / / _ \ \'__/ __|/ _ \ | | |  ___/ 
| | \ \  __/\ V /  __/ |  \__ \  __/_| |_| |     
|_|  \_\___| \_/ \___|_|  |___/\___|_____|_| ~ by '.colorize(:yellow) + 'AnonGuy'.colorize(:magenta)

print 'Greets to ~ '.colorize(:green)
leets.each { |leet| (leet == leets.last ? (puts leet.colorize(:cyan)) : (print leet.colorize(:cyan) + ' -- ')) } # .. I know.
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
		return response.code.colorize(:yellow)
	rescue StandardError
		return '???'.colorize(:red)
	end
end

def getCMS(site) # lotta fps .-.
	cms = ''
	begin
		cms  = Mechanize.new.get('http://' + site).at('meta[name="generator"]')[:content]
		return cms.to_s.colorize(:yellow)
	rescue StandardError
		return '???'.colorize(:red)
	end
end

if parsed['status'] == 'Fail'
	abort('[!] '.colorize(:red) + parsed['message'].split('. ')[0] + "\n#{sep}\n")
else
	puts 'Target            -- '.colorize(:red) + parsed['remoteIpAddress']
	puts 'Number of Domains -- '.colorize(:red) + parsed['domainCount']; len = parsed['domainCount'].length
	puts sep

	domains = parsed['domainArray']
	puts 'Domains -- '.colorize(:red)
	domains.each.with_index(1) {|domain, index|
		dashes     = '-' * (domains.flatten.max_by(&:size).length - domain[0].length + 1)
		httpStatus = statusCode(domain[0])
		cms        = getCMS(domain[0])
		
		puts '[ '.colorize(:cyan) + index.to_s.rjust(len, '0').colorize(:red) + ' ]'.colorize(:cyan) + ' -- ' + '[ '.colorize(:cyan) + domain[0].to_s.colorize(:green) + ' ] '.colorize(:cyan) + dashes.to_s + ' [ '.colorize(:cyan) + httpStatus.to_s + ' ]'.colorize(:cyan) + ' [ '.colorize(:cyan) + cms + ' ]'.colorize(:cyan)
	}
end
puts sep
