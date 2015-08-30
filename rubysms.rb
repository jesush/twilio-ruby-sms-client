require 'rubygems'
require 'twilio-ruby'
require 'yaml'

# Load Configuration File
config = begin
	YAML.load(File.open("config.yml"))
rescue ArgumentError => e
  puts "Could not load configuration file: #{e.message}"
  abort
end

ACCOUNT_SID = config["account_sid"]
AUTH_TOKEN = config["auth_token"]
FROM = config["your_number"]



if ARGV
	if ARGV.count == 2
		phone, message = ARGV
		name = "No Name"
	elsif ARGV.count == 3
		phone, name, message = ARGV
	end
end

if ACCOUNT_SID == "TWILIOSID" || AUTH_TOKEN == "TWILIOTOKEN" || FROM == "+YOUR_NUMBER"
	puts "Please make sure to configure your TWILIO Credentials before using script."
	puts "More info here: https://www.twilio.com/help/faq/twilio-basics/where-are-my-test-credentials"
	abort
end
def send_message(numberList, message)
	client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
	puts "Sending Message to #{numberList.inspect}"
	numberList.each do |phone_to, phone_name|
		if validate_phone(phone_to)
			puts "Valid Phone : #{validate_phone(phone_to)}"
			client.account.messages.create(
		    :from => FROM,
		    :to => phone_to,
		    :body => message
		  )
		  puts "Sent message to #{phone_name} : #{phone_to}"
		end
	end
end

def validate_phone(phone)
	lookup_client = Twilio::REST::LookupsClient.new(ACCOUNT_SID, AUTH_TOKEN)
	begin
		response = lookup_client.phone_numbers.get(phone)
		response.phone_number
		#debug_response(response)
		return phone
	rescue => e
		# Debug
		puts "There was an error: #{e}"
		raise e unless e.code == 20404
    	return false
	end
end

numbers = {}
numbers.store( phone,name )
send_message(numbers,message)