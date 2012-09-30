require 'json'
module Wyqs
  class Client
    attr_reader :app_key, :app_secret, :endpoint

    def initialize(app_key = Wyqs.app_key, app_secret = Wyqs.app_secret, endpoint = Wyqs.endpoint)
      @app_key = app_key
      @app_secret = app_secret
      @endpoint = endpoint 
    end

    def invoke(method, options = {})
      params = {
        :timestamp => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        :format => 'json',
        :app_key => @app_key,
        :vq => '1.0',
        :method => method,
        :sign_method => 'md5'
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
  end
end
