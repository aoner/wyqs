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
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5'
      }
      params.merge!(options)
      str = (params.sort.collect { |c| "#{c[1]}" }).join("&")
      puts str
      str = Digest::MD5.hexdigest(str).downcase#"#{params[:appid]}&#{params[:authvers]}&#{params[:format]}&#{params[:signmethod]}&#{params[:timestamp]}"
      puts str
      sign = [app_secret,str,""].join("&")
      puts sign
      params["sign"] = URI.encode(Base64.encode64(sign))
      res = Net::HTTP.post_form(URI(@site)), params)
      puts params
      if params[:format] == 'json'
        JSON.parse(res.body)
      else
        res.body
      end
    end
  end
end
