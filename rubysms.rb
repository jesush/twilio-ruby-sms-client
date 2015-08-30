require 'rubygems'
require 'twilio-ruby'

ACCOUNT_SID = "TWILIOSID"
AUTH_TOKEN = "TWILIOTOKEN"
FROM = "+YOUR_NUMBER"

if ARGV
	if ARGV.count == 2
		phone, message = ARGV
		name = "No Name"
	elsif ARGV.count == 3
		phone, name, message = ARGV
	end
end

def debug_response(response)
	puts "Response: #{response}"
	puts "Response Data: #{response.inspect}"

	puts "Country Code: #{response.country_code}"
end

def debug(phone, name, message)
	if phone
		puts "Phone: #{phone}"
		validate_phone(phone)
	end
	if name
		puts "Name: #{name}"
	end
	if message
		puts "Message: #{message}"
	end
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