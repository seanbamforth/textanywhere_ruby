##TextAnywhere_Ruby
Being a Ruby Gem for the sending of text messages via TextAnywhere. 
http://www.textanywhere.net/default.aspx

We use the HTTP Service as defined here: 
http://developer.textapp.net/HTTPService/Default.aspx

##Using The Gem
The Hello World for using this gem looks a little like this: 

```ruby
# variables acc_no,password and mobile_no
# are set by yourself. acc_no is your text anywhere
# account number, password is the password and 
# mobile_no is the number it goes to. 
# note that the text message will appear to come 
# from a sender called "foo-bar"
#

a = TextAnywhere_ruby.new(acc_no,password,"foo-bar")
a.client_billing_reference="12345"
resp =  a.send(mobile_no,"Hello World.","cliref")
puts "The Message has been sent" if a.is_ok(resp)
puts resp
```

###Some other useful things are as follows: 

```ruby
sms = TextAnywhere_ruby.new(acc_no,password,"foo-bar")
sms.live!  #Live sending of messages
sms.test!  #Now we're sending test messages
puts "Gordon's alive!" if sms.live?

sms.use_https! #switch to https
sms.use_http #switch back to http
sms.is_ok(response) #checks if the response from a call is OK. 
sms.client_billing_reference="personal" #set the client billing reference 
resp =  sms.send(mobile_no,"Hello World.","cliref") #send a message
sms.test_service #Test if the service is OK
resp = sms.credits_left #get the number of credits left.

sms.no_reply_originator("bar-foo") #set no originator (with text)
sms.no_reply_phone_number("+1-555-9176") #set the reply number
sms.reply_to_email("sean@pingdipong.com") #response get forwarded to the stated email address

resp =  sms.send([mobile_no,mobile_no2],"Hello World.","cliref") #send message to multiple recipients.
```

##A Note on Response
Data returned from textAnyWhere is converted to a Hash. If you want to see what's in the hash, the easiest thing to do is look in the hash. I've converted the XML described in the TextAnywhere API directly. 

See here: 
http://developer.textapp.net/HTTPService/Methods_SendSMS.aspx

returns something like: 
```ruby
{
  "Transaction"=> {  
    "IP"=>"92.232.200.54", 
    "Code"=>"1", 
    "Description"=>"Transaction OK"
  }, 
  "Destinations"=>{
    {Destination=>{Number=>"+55512345", "Code"=>"1"},
    {Destination=>{Number=>"+55512348", "Code"=>"1"},
  }
}
```

##Methods and the SuchLike

###def live?
Are we in live mode. 

###def live!
Put us in live mode

###def test!
Put us in test mode 

###def use_https!
Use https for the web service 

###def use_http!
Use Http for the web service

###def initialize(username,password,originator,options = {})
Create the object. You need to say what your username and 
password is. Originator is who the message is from.

###def send(destinations,body,clientmessagereference="ref",options = {})
See http://developer.textapp.net/HTTPService/Methods_SendSMS.aspx

###def format_number(phone)
Allows you to format a phone number for use by this service. Not really needed by you.

###def is_ok(response)
Is the response OK. Were any errors returned. 

###def client_billing_reference=(val)
Set the client billing reference. This can be used to track who sent what messages. Please Note that this is not the same as the "clientmessagereference", which is used to track messages.

###def status(clientmessagereference)
Find out the status of a text message based on the client message reference. 

###def reply
See: http://developer.textapp.net/HTTPService/Methods_GetSMSReply.aspx
This method is used to retrieve messages sent as replies to messages previously sent using the SendSMS method, where reply_to_web_service has been used. 

###def restore_originator
Restores the originator, and sets the reply method back to the default. Used if you've used one of the no_reply or reply_to methods. 

###def test_service
Tests the service is working 

###def credits_left
Tells us how many credits we've got left

###def inbound(number="", keyword="")
See: http://developer.textapp.net/HTTPService/Methods_GetSMSInbound.aspx

###def premium_inbound(shortcode,keyword)
See: http://developer.textapp.net/HTTPService/Methods_GetPremiumSMSInbound.aspx

###def send_premium(rbid,body,clientmessagereference,options = {})
See: http://developer.textapp.net/HTTPService/Methods_SendPremiumSMS.aspx

###def premium_status(clientmessagereference)
See: http://developer.textapp.net/HTTPService/Methods_GetPremiumSMSStatus.aspx

###def subscribers(number="", keyword="")
See: http://developer.textapp.net/HTTPService/Methods_GetSubscribers.aspx

###def no_reply_originator(orig="")
Messages will now be sent from "orig". 

###def no_reply_phone_number(orig="")
Messages will now be sent from the number passed in. 

###def reply_to_email(email)
Messages can be replied to, and the replies go to your email address.

###def reply_to_web_service
Messages can be replied to, and the replies go to the textanywhere web service. use "Inbound" to pick these up. 

###def reply_to_url(url)
Messages can be replied to, and the replies go to the specified web service.

###def no_reply_to_shortcode(shortcode)
Messages can be replied to, and the replies come from the specified shortcode.


Comparison between textanywhere and other Suppliers
====================================================

TextAnywhere messages generally cost more than other suppliers. In the case of Twilio, it can be the difference between 1p and 10p

Even when you're sending the text messages to the UK (TextAnywhere is based in the UK), they cost much more than ClickATell and Twilio. 

However, TextAnywhere has advantages: 

 - There's no need to sign up for a telephone number when sending messages to the US. It's just pay-as-you-go. 
 - I've used textanywhere for 8 years, and I've never had any problem sending messages. Messages sent in the UK are sent as priority messages. If you absolutely must have them arrive, then I'd start with TextAnywhere
 - The support is good. This may sound like heresy, but you can actually phone them up. 
 - The reply to email option is really smooth. 
 - You can send messages from an alphabetic sender. If you've got a web service called "foo-bar", then you can have the sender register on the phone as "foo-bar" instead of a random number. (I don't know if this works in countries other than the UK, so you'll have to check it out.)
 - You can send messages from a number you support independently of the service. (e.g. You can have the messages look like they've been sent from your personal mobile phone number.)


ToDo
====
 - Make sure that dependencies are correct in the gemfile
 - split it into multiple files. 
 - push it to ruby forge
 