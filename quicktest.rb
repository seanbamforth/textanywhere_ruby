require './lib/textanywhere_ruby.rb'

a = TextAnywhere_ruby.new("user","password","orig")
a.test!
a.client_billing_reference="12345"
resp =  a.send(["07802653722","07802653722"],"this is a test","cliref")
puts "messages have been sent" if a.is_ok(resp)
puts resp

#puts a.status("cliref")
#puts a.format_number("07802 653722")
#puts a.format_number("+01 765 8765")
#puts a.format_number("44 7802 653722")

