require 'json'
module Wyqs
  class Consumer
    attr_reader :appid, :app_secret,:params
    attr_reader :accesstoken,:requesttoken,

    def initialize(appid = Wyqs.appid, app_secret = Wyqs.app_secret)
      @appid = appid
      @app_secret = app_secret
      @site = site
      @params = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5'
      }
    end
    
    def get_request_token(options = {})
      @params.merge!(options)
      str = Digest::MD5.hexdigest((@params.collect { |c| "#{c[1]}" }).join("&")).downcase
      @params["sign"] = URI.encode(Base64.encode64s([app_secret,str,""].join("&")))
      res = Net::HTTP.post_form(URI(@params[:site]), params)
      if @params[:format] == 'json'
      JSON.parse(res.body)
      else
        res.body
      end
    end
  end
end
