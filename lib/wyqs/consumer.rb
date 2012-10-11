require 'json'
module Wyqs
  class Consumer
    attr_reader :appid, :appsecret, :tokensecret, :accesstoken

    def initialize(appid = Wyqs.appid, appsecret = Wyqs.appsecret)
      @appid = appid
      @appsecret = appsecret
    end
    
    def get_request_token(options = {})
      params = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5',
        :site => 'http://routeapitest.5173.com:14167/request.do?'
      }
      params.merge!(options)
      str = [params[:appid],params[:authvers],params[:format],params[:signmethod],params[:timestamp]].join("&")
      params["sign"] = encrypt(str,appsecret,tokensecret)
      res = Net::HTTP.post_form(URI(params[:site]), params)
      #if params[:format] == 'json'
      @tokensecret = JSON.parse(res.body)["BizResult"]["RequestToken"]
      
      param = {
        :timestamp => Time.now.to_i.to_s,
        :format => 'json',
        :appid => @appid,
        :authvers => '1.0',
        :signmethod => 'md5',
        :tokensecret => @tokensecret,
        :site => 'http://routeapitest.5173.com:14167/access.do?'
      }
      accessstr = [param[:appid],param[:authvers],param[:format],,param[:tokensecret],param[:signmethod],param[:timestamp]].join("&")
      param["sign"] = encrypt(accessstr,appsecret,@tokensecret)
      res = Net::HTTP.post_form(URI(param[:site]), param)
      #@accesstoken = 
      JSON.parse(res.body)
      #else
      #  res.body
      #end
    end
    
    private
    def encrypt(signatureBase, appsecret, tokensecret)
      basestr = Digest::MD5.hexdigest(signatureBase).downcase
      puts basestr
      puts [appsecret,basestr,tokensecret].join("&")
      URI.encode(Base64.encode64s([appsecret,basestr,tokensecret].join("&")))
    end
  end
end
