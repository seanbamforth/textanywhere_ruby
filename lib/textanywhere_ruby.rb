require 'open-uri'
require 'nokogiri'

class TextAnywhere_ruby
  def self.hi()
    "hello there"
  end

  def live?
    @is_live
  end

  def live!
    @is_live = true 
  end

  def test!
    @is_live = false 
  end

  def use_https!
    @start_url = "https://www.textapp.net/webservice/httpservice.aspx"
    @is_https = true 
  end

  def use_http!
    @start_url = "http://www.textapp.net/webservice/httpservice.aspx"
    @is_https = false 
  end

  def default_options
    {:method=>"",
    :returncsvstring=>"false",
    :externallogin=>"",
    :password=>"",
    :clientbillingreference=>"all",
    :clientmessagereference=>"",
    :originator=>"",
    :destinations=>"",
    :body=>"",
    :validity=>72,
    :charactersetid=>2,
    :replymethodid=>1,
    :replydata=>"",
    :statusnotificationurl=>"",
    :number=>"",
    :keyword=>"",
    :shortcode=>"",
    :rbid=>""}
  end

  def send_params
    [
      :method,
      :returncsvstring,
      :externallogin,
      :password,
      :clientbillingreference,
      :clientmessagereference,
      :originator,
      :destinations,
      :body,
      :validity,
      :charactersetid,
      :replymethodid,
      :replydata,
      :statusnotificationurl
    ]
  end

  def status_params
    [
      :method,
      :returncsvstring,
      :externallogin,
      :password,
      :clientmessagereference
    ]
  end

  def base_params
    [
      :method,
      :returncsvstring,
      :externallogin,
      :password
    ]
  end

  def inbound_params
    [
      :method,
      :returncsvstring,
      :externallogin,
      :password,
      :number,
      :keyword
    ]
  end

  def premium_inbound_params
    [
      :method,
      :returncsvstring,
      :externallogin,
      :password,
      :shortcode,
      :keyword
    ]
  end

  def send_premium_params
    [
      :returncsvstring,
      :externallogin,
      :password,
      :clientbillingreference,
      :clientmessagereference,
      :rbid,
      :body,
      :validity,
      :charactersetid,
      :statusnotificationurl
    ]
  end

  def subscriber_params
    [
      :returncsvstring,
      :externallogin,
      :password,
      :number,
      :keyword
    ]
  end

  def initialize(username,password,originator,options = {})
    live!
    use_http!

    @options = default_options
    @options[:externallogin] = username 
    @options[:password] = password
    @options[:originator] = originator if originator
    
    @options.merge(options)
    @remember_originator = @options[:originator] 
  end

  def send(destinations,body,clientmessagereference="ref",options = {})
    if live? 
      return live_send(destinations,body,clientmessagereference,options)
    else
      return test_send(destinations,body,clientmessagereference,options)
    end
  end

  def format_number(phone)
    phone = phone.gsub(/[^0-9]/, "")
    
    if phone.start_with?("00")
      phone = phone[2..-1]
    end
    if phone.start_with?("0")
      phone = "44" + phone[1..-1]
    end
    phone = "+" + phone 

    return phone 
  end

  def to_csv(destinations)
    if destinations.kind_of?(Array)
      ret = ""
      destinations.each do |dest|
        ret=ret+"," if ret != ""
        ret = ret + (format_number(dest))
      end
    else
      ret = (format_number(destinations)) 
    end 
    return ret
  end

  def format_response(response)
    hash = {}

    response.children.each do |p|
      if p.children.length > 1 || p.children.children.length > 1
         new_item = format_response(p)
      else 
        new_item = p.inner_html 
      end 

      if hash.has_key?(p.name) 
        unless hash[p.name].is_a?(Array)
          hash[p.name] = [] << hash[p.name]
        end
        hash[p.name] << new_item 
      else 
        hash[p.name] = new_item
      end
    end
    return hash 
  end

  def is_ok(response)
    response["Transaction"]["Code"].to_i == 1
  end

  def get_html_content(requested_url)
    response = Nokogiri::XML(open(requested_url))
    trans_code = response.xpath('//Transaction/Code').inner_text().to_i
    trans_text = response.xpath('//Transaction/Description').inner_text()

    a = format_response(response.xpath("/*"))
    puts a
    return a
  end 

  def client_billing_reference=(val)
    @options[:clientbillingreference] = val
  end

  #params is an array of symbols. Use this array to create
  #a url containing only those symbols as parameters. 
  #Array is created from the @options variable
  #need to send this off to the internet and get answer back.
  def ta_response(params)
    url = ""
    params.each do |param|
      url = url + "&" if url != ""
      url = url + param.to_s + "=" + URI::encode(@options[param].to_s)
    end 
    response = get_html_content(@start_url + "?" + url)
    puts url 
    return response
  end

  #live send a text message - finished.
  def live_send(destinations,body,clientmessagereference,options = {})
    @options[:method] = 'sendsms'
    @options[:destinations] = to_csv(destinations) 
    @options[:clientmessagereference] = clientmessagereference
    @options[:body] = body
    @options.merge(options)
    response = ta_response(send_params)
    return response
  end

  #get status of text message - finished
  def status(clientmessagereference)
    @options[:method] = 'getsmsstatus'
    @options[:clientmessagereference] = clientmessagereference
    response = ta_response(status_params)
    return response
  end

  #get replies from the text message - OK 
  def reply
    @options[:method] = 'getsmsreply'
    @options[:clientmessagereference] = clientmessagereference
    response = ta_response(status_params)
    return response
  end

  def restore_originator
    @options[:originator] = @remember_originator
    @options[:replydata] = ""
    @options[:replymethodid] = 1
  end

  #Test service is working. All OK 
  def test_service
    @options[:method] = 'testservice'
    response = ta_response(base_params)
    return response
  end

  #test send a message - we're OK
  def test_send(destinations,body,clientmessagereference,options = {})
    @options[:method] = 'testsendsms'
    @options[:clientmessagereference] = clientmessagereference
    @options[:destinations] = to_csv(destinations)
    @options[:body] = body
    @options.merge(options)
    response = ta_response(send_params)

    return response
  end

  #the credits left - ok 
  def credits_left
    @options[:method] = 'GetCreditsLeft'
    response = ta_response(base_params)
    return response
  end

  #should be ok
  def inbound(number="", keyword="")
    number = @options['originator'] if number == ""
    @options[:method] = 'GetSMSInbound'
    @options[:number] = number 
    @options[:keyword] = keyword
    
    response = ta_response(inbound_params)
    return response
  end

  #should be ok
  def premium_inbound(shortcode,keyword)
    @options[:method] = 'GetPremiumSMSInbound'
    @options[:shortcode] = number 
    @options[:keyword] = keyword

    response = ta_response(premium_inbound_params)
    return response
  end

  def send_premium(rbid,body,clientmessagereference,options = {})
    @options[:method] = 'SendPremiumSMS'
    @options.merge(options)

    @options[:clientmessagereference] = clientmessagereference
    @options[:rbid] = rbid
    @options[:body] = body

    response = ta_response(send_premium_params)
    return response
  end

  def premium_status(clientmessagereference)
    @options[:method] = 'GetPremiumSMSStatus'    
    @options[:clientmessagereference] = clientmessagereference
    response = ta_response(status_params)
    return response
  end

  def subscribers(number="", keyword="")
    @options[:method] = 'GetSubscribers'

    number = @options['originator'] if number == ""

    @options[:number] = number 
    @options[:keyword] = keyword
    response = ta_response(subscriber_params)
    return response
  end

  def method_for(method)
    reply = {
      :no_reply=>1,
      :reply_to_email=>2,
      :reply_to_web_service=>3,
      :send_phone_no=>4,
      :reply_to_url=>5,
      :no_reply_use_shortcode=>7
    }[method]

    reply = 1 unless reply
    return reply
  end

  def no_reply_originator(orig="")
    @options[:replymethodid] = 1
    @options[:replydata] = "" 
    @options[:originator] = orig unless orig==""
  end

  def no_reply_phone_number(orig="")
    @options[:replymethodid] = 4
    @options[:replydata] = "" 
    @options[:originator] = orig unless orig==""
  end

  def reply_to_email(email)
    @options[:replymethodid] = 2
    @options[:replydata] = email
    @options[:originator] = ""
  end

  def reply_to_web_service
    @options[:replymethodid] = 3
    @options[:replydata] = ""
    @options[:originator] = ""
  end

  def reply_to_url(url)
    @options[:replymethodid] = 5
    @options[:replydata] = url
    @options[:originator] = ""
  end

  def no_reply_to_shortcode(shortcode)
    @options[:replymethodid] = 7
    @options[:replydata] = ""
    @options[:originator] = shortcode
  end

end

