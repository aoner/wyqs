require 'json'
module Wyqs
  class Client
    attr_reader :appid, :app_secret, :endpoint

    def initialize(appid = Wyqs.appid, app_secret = Wyqs.app_secret, endpoint = Wyqs.endpoint)
      @appid = appid
      @app_secret = app_secret
      @endpoint = endpoint 
    end

    def invoke(method, options = {})
      params = {
        :timestamp => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        :format => 'json',
        :appid => @app_key,
        :authvers => '1.0',
        :method => method,
        :signmethod => 'md5'
      }
      params.merge!(options)
      str = @app_secret + (params.sort.collect { |param| "#{param[0]}#{param[1]}" }).join("") + @app_secret
      params["sign"] = Digest::MD5.hexdigest(str).upcase!
      res = Net::HTTP.post_form(URI.parse(@endpoint), params)
      if params[:format] == 'json'
        JSON.parse(res.body)
      else
        res.body
      end
    end
    
    def get_request_token(options = {})
      params = {
        :timestamp => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        :format => 'json',
        :appid => @app_key,
        :authvers => '1.0',
        :method => 'get',
        :signmethod => 'md5'
      }
      params.merge!(options)
      str = "#{appid}&#{authvers}&#{format}&#{signmethod}&#{timestamp}"
      params["sign"] = Digest::MD5.hexdigest(str).upcase!
      res = Net::HTTP.post_form(URI.parse(@endpoint), params)
      if params[:format] == 'json'
        JSON.parse(res.body)
      else
        res.body
      end
    end
  end
end
