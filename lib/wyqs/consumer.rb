require 'json'
module Wyqs
  class Consumer
    attr_reader :appid, :app_secret, :site

    def initialize(appid = Wyqs.appid, app_secret = Wyqs.app_secret, site = Wyqs.site)
      @appid = appid
      @app_secret = app_secret
      @site = site
    end
    
    def get_request_token(options = {})
      params = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @app_key,
        :authvers => '1.0',
        :signmethod => 'md5'
      }
      params.merge!(options)
      str = '#{appid}&#{authvers}&#{format}&#{signmethod}&#{timestamp}'
      params["sign"] = Digest::MD5.hexdigest(str).upcase!
      res = Net::HTTP.post_form(URI.parse(URI.encode(@site)), params)
      if params[:format] == 'json'
        JSON.parse(res.body)
      else
        res.body
      end
    end
  end
end
