require 'json'
module Wyqs
  class Consumner
    attr_reader :appid, :app_secret, :site

    def initialize(appid = Wyqs.appid, app_secret = Wyqs.app_secret, endpoint = Wyqs.site)
      @appid = appid
      @app_secret = app_secret
      @endpoint = site
    end
    
    def get_request_token(options = {})
      params = {
        :timestamp => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        :format => 'json',
        :appid => @app_key,
        :authvers => '1.0',
        :signmethod => 'md5'
      }
      params.merge!(options)
      str = '#{appid}&#{authvers}&#{format}&#{signmethod}&#{timestamp}'
      params["sign"] = Digest::MD5.hexdigest(str).upcase!
      res = Net::HTTP.post_form(URI.parse(@site), params)
      if params[:format] == 'json'
        JSON.parse(res.body)
      else
        res.body
      end
    end
  end
end
